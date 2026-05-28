# DontSleep

A simple macOS menu bar app that prevents your Mac from going to sleep for a specified duration.

## Features

- 🌙 **Menu Bar Only** - Lives in your menu bar, no Dock icon
- ⏱️ **Quick Timers** - Preset durations: 15, 30, or 60 minutes
- ⚙️ **Custom Duration** - Set any custom duration in minutes
- 🟢 **Status Indicator** - Visual feedback showing when prevent-sleep is active
- 🕐 **End Time Display** - Shows when the timer will end
- 🛑 **Easy Stop** - Stop the timer anytime with one click

## How It Works

DontSleep uses macOS's built-in `caffeinate` command to prevent your system from sleeping. This is the same utility Apple provides with macOS, ensuring safe and reliable operation.

## Usage

1. Click the moon icon (🌙) in your menu bar
2. Select a preset duration or choose "Custom Duration..." for your own timing
3. The icon changes to indicate active status (⏳)
4. Your Mac will stay awake for the specified duration
5. Click "Stop Timer" to end early, or let it finish automatically

## Requirements

- macOS 13.0 or later
- No additional dependencies required

## Installation

### From Source

1. Clone this repository:
   ```bash
   git clone git@github.com:seekaytahn/dontsleep.git
   ```
2. Open `DontSleep.xcodeproj` in Xcode
3. Build and run (⌘R)

### Running the App

The app will appear only in your menu bar. Look for the moon icon (🌙) in the top-right area of your screen.

## Technical Details

- Built with **SwiftUI** and **AppKit**
- Uses `MenuBarExtra` for menu bar integration
- Implements `Process` API to manage the `caffeinate` command
- Menu bar only app (uses `.accessory` activation policy)

## License

[Add your license here]

## Author

[Add your name/info here]

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
