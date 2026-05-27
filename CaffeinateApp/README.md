# ☕ Caffeinate

A simple, elegant macOS menu bar app to prevent your Mac from sleeping. Built with SwiftUI.

![macOS](https://img.shields.io/badge/macOS-13.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

✨ **Simple & Clean Interface** - Lives in your menu bar, out of your way

⏱️ **Preset Timers** - Quick access to 15, 30, and 60 minute durations

🎯 **Custom Duration** - Set any duration you need in minutes

🟢 **Live Status Indicator** - See at a glance when caffeinate is active

⏰ **End Time Display** - Know exactly when your timer will finish

🛑 **Easy Stop** - Cancel the timer anytime

🎨 **Visual Feedback** - Menu bar icon changes when active (☕ → ☕️)

## Screenshots

### Idle State
```
☕ Caffeinate
├─ Caffeinate
├─ [15 minutes]
├─ [30 minutes]
├─ [60 minutes]
├─ [Custom Duration...]
├─ ─────────────
└─ [Quit]
```

### Running State
```
☕️ Caffeinate ⏳
├─ Caffeinate
├─ 🟢 Active • Ends at 3:45 PM
├─ [Stop Timer]
├─ ─────────────
└─ [Quit]
```

## Installation

### Build from Source

1. Clone this repository:
   ```bash
   git clone git@github.com:seekaytahn/caffeinateapp.git
   cd caffeinateapp
   ```

2. Open `CaffeinateApp.xcodeproj` in Xcode

3. Build and run (⌘R)

4. Optional: Archive and export the app to your Applications folder

## Usage

1. **Launch the app** - It appears in your menu bar as a coffee mug icon ☕

2. **Start a timer** - Click the icon and select a duration:
   - Choose from preset options (15, 30, or 60 minutes)
   - Or click "Custom Duration..." to enter any number of minutes

3. **Monitor status** - When active:
   - Menu bar icon fills in (☕️) and shows an hourglass (⏳)
   - Green dot shows "Active" status
   - End time is displayed

4. **Stop early** - Click "Stop Timer" to end before the timer finishes

5. **Quit the app** - Click "Quit" (automatically stops any running timer)

## How It Works

This app is a wrapper around macOS's built-in `caffeinate` command-line utility. When you start a timer:

```bash
/usr/bin/caffeinate -t <seconds>
```

The app manages the process and automatically cleans up when:
- The timer naturally expires
- You manually stop the timer
- You quit the app

## Requirements

- macOS 13.0 (Ventura) or later
- No additional permissions required

## Technical Details

- **Framework**: SwiftUI
- **Architecture**: MVVM with ObservableObject
- **Process Management**: Uses `Process` to spawn and monitor `caffeinate`
- **UI Pattern**: MenuBarExtra with window style
- **State Management**: Combine with @Published properties

## Project Structure

```
CaffeinateApp/
├── CaffeinateApp.swift      # Main app file
│   ├── AppState             # Observable state management
│   ├── CaffeinateApp        # App entry point
│   └── CaffeinateMenu       # UI view
└── README.md                # This file
```

## Code Highlights

### State Management
```swift
class AppState: ObservableObject {
    @Published var isRunning = false
    @Published var endTime: Date?
    private var currentTask: Process?
}
```

### Process Lifecycle
```swift
task.terminationHandler = { [weak self] _ in
    DispatchQueue.main.async {
        self?.isRunning = false
        self?.currentTask = nil
        self?.endTime = nil
    }
}
```

## Contributing

Contributions are welcome! Here are some ideas for enhancements:

- [ ] Add notifications when timer completes
- [ ] Remember last used custom duration
- [ ] Add keyboard shortcuts
- [ ] Display remaining time countdown
- [ ] Support for "indefinite" mode (no timer)
- [ ] Prevent display sleep option
- [ ] System sleep prevention options (disk, system, etc.)

## License

MIT License - feel free to use this code for your own projects!

## Acknowledgments

- Built with ❤️ using SwiftUI
- Uses macOS's built-in `caffeinate` utility
- Inspired by the need for a simple, native caffeinate GUI

## Support

If you find this useful, give it a ⭐️ on GitHub!

---

**Note**: This app prevents your Mac from sleeping but does not prevent the display from sleeping. If you need to keep the display awake, use `caffeinate -d` flag (would require code modification).
