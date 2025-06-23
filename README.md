# MacKeyTalk

A Swift macOS application that runs in the background and plays a sound effect whenever you press any key on your keyboard.

## Features

- 🎵 Plays a pleasant keyboard click sound on every key press
- 🔄 Runs completely in the background
- 📱 Status bar icon for easy access and control
- 🔒 Proper accessibility permissions handling
- ⚡ Low latency sound generation using AVFoundation

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for building)
- Accessibility permissions (will be requested automatically)

## Building the App

### Using Swift Package Manager

1. Clone this repository:
```bash
git clone https://github.com/yourusername/MacKeyTalk.git
cd MacKeyTalk
```

2. Build the app:
```bash
swift build -c release
```

3. Run the app:
```bash
.build/release/MacKeyTalk
```

### Using Xcode

1. Open the project in Xcode:
```bash
open Package.swift
```

2. Select the `MacKeyTalk` target
3. Build and run (⌘+R)

## Usage

1. **First Run**: The app will request accessibility permissions. Go to System Preferences > Security & Privacy > Privacy > Accessibility and add the app.

2. **Background Operation**: Once running, the app will appear as a keyboard icon (⌨️) in your status bar.

3. **Sound Effects**: Every key press will trigger a pleasant keyboard click sound.

4. **Quitting**: Right-click the status bar icon and select "Quit" to stop the app.

## How It Works

- **Key Monitoring**: Uses Carbon Event Taps to monitor global key events
- **Sound Generation**: Generates a custom 800Hz sine wave with fade in/out for a natural keyboard sound
- **Background Operation**: Runs as an accessory app with no dock icon
- **Status Bar Integration**: Provides easy access through the macOS status bar

## Technical Details

- **Language**: Swift 5.9
- **Frameworks**: Cocoa, Carbon, AVFoundation
- **Architecture**: Event-driven with callback-based key monitoring
- **Audio**: Real-time sine wave generation at 44.1kHz

## Permissions

The app requires accessibility permissions to monitor global key events. This is necessary for:
- Detecting key presses from any application
- Running in the background
- Providing a system-wide keyboard sound effect

## Troubleshooting

### No Sound
- Check that your system volume is not muted
- Ensure the app has microphone permissions if needed
- Try restarting the app

### Keys Not Detected
- Verify accessibility permissions are granted
- Restart the app after granting permissions
- Check System Preferences > Security & Privacy > Privacy > Accessibility

### App Won't Start
- Ensure you're running macOS 13.0 or later
- Check that all dependencies are properly installed
- Try building with Xcode for more detailed error messages

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.