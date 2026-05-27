import SwiftUI
import AppKit
import Combine

class AppState: ObservableObject {
    @Published var isRunning = false
    @Published var endTime: Date?
    private var currentTask: Process?
    
    // Check if caffeinate process is actually running
    var isCaffeinateActuallyRunning: Bool {
        guard let task = currentTask else { return false }
        return task.isRunning
    }
    
    func startCaffeinate(minutes: Int) {
        // Stop any existing task
        stopCaffeinate()
        
        self.isRunning = true
        self.endTime = Date().addingTimeInterval(TimeInterval(minutes * 60))
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        task.arguments = ["-t", "\(minutes * 60)"]
        
        // Set up termination handler to update state when done
        task.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isRunning = false
                self?.currentTask = nil
                self?.endTime = nil
            }
        }
        
        self.currentTask = task
        
        // Launch runs asynchronously, allowing the UI to stay responsive
        do {
            try task.run()
        } catch {
            print("Failed to start caffeinate: \(error)")
            self.isRunning = false
            self.currentTask = nil
            self.endTime = nil
        }
    }
    
    func stopCaffeinate() {
        currentTask?.terminate()
        currentTask = nil
        isRunning = false
        endTime = nil
    }
    
    // Check system for any running caffeinate processes
    func checkSystemForCaffeinate() -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/pgrep")
        task.arguments = ["caffeinate"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""
            
            // If pgrep finds processes, it returns PIDs
            return !output.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } catch {
            print("Failed to check for caffeinate: \(error)")
            return false
        }
    }
}

// Shared instance accessible across the app's scenes
let appState = AppState()

@main
struct CaffeinateApp: App {
    @StateObject private var state = appState
    
    var body: some Scene {
        MenuBarExtra(
            state.isRunning ? "Caffeinate ⏳" : "Caffeinate",
            systemImage: state.isRunning ? "mug.fill" : "mug"
        ) {
            CaffeinateMenu()
                .environmentObject(state)
        }
        .menuBarExtraStyle(.window)
    }
}

struct CaffeinateMenu: View {
    @EnvironmentObject var state: AppState
    @State private var customMinutes: String = ""
    @State private var showCustomInput: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    let durations = [
        (name: "15 minutes", minutes: 15),
        (name: "30 minutes", minutes: 30),
        (name: "60 minutes", minutes: 60)
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Caffeinate")
                .font(.headline)
            
            // Status indicator
            if state.isRunning {
                HStack {
                    Circle()
                        .fill(state.isCaffeinateActuallyRunning ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(state.isCaffeinateActuallyRunning ? "Active" : "Stopped")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Display end time on same line
                    if let endTime = state.endTime {
                        Text("• Ends at \(endTime, style: .time)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if state.isRunning {
                Button("Stop Timer") {
                    state.stopCaffeinate()
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(durations, id: \.name) { duration in
                    Button(duration.name) {
                        state.startCaffeinate(minutes: duration.minutes)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Custom duration section
                Button(showCustomInput ? "Hide Custom" : "Custom Duration...") {
                    showCustomInput.toggle()
                    if !showCustomInput {
                        customMinutes = ""
                        isTextFieldFocused = false
                    } else {
                        // Focus the text field when showing custom input
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isTextFieldFocused = true
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                if showCustomInput {
                    HStack(spacing: 8) {
                        TextField("Minutes", text: $customMinutes)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                            .multilineTextAlignment(.center)
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                if let minutes = Int(customMinutes), minutes > 0 {
                                    state.startCaffeinate(minutes: minutes)
                                    customMinutes = ""
                                    showCustomInput = false
                                }
                            }
                        
                        Button("Start") {
                            if let minutes = Int(customMinutes), minutes > 0 {
                                state.startCaffeinate(minutes: minutes)
                                customMinutes = ""
                                showCustomInput = false
                            }
                        }
                        .disabled(Int(customMinutes) == nil || Int(customMinutes) ?? 0 <= 0)
                    }
                    .padding(.horizontal, 10)
                }
            }
            
            Divider()
            
            Button("Quit") {
                // Stop caffeinate process before quitting
                state.stopCaffeinate()
                NSApp.terminate(nil)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(10)
    }
}
