import Cocoa
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var keyMonitor: KeyMonitor?
    private var soundPlayer: SoundPlayer?
    private var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up the app to run in background
        NSApp.setActivationPolicy(.accessory)
        
        // Initialize sound player
        soundPlayer = SoundPlayer()
        
        // Initialize key monitor
        keyMonitor = KeyMonitor { [weak self] in
            self?.soundPlayer?.playKeySound()
        }
        
        // Create status bar item for easy access
        setupStatusBar()
        
        // Start monitoring keys
        keyMonitor?.startMonitoring()
        
        print("Mac Keyboard Sound Effect is running in the background")
        print("Press any key to hear the sound effect")
        print("Right-click the status bar icon to quit")
    }
    
    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.title = "⌨️"
            button.toolTip = "Mac Keyboard Sound Effect"
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem?.menu = menu
    }
    
    @objc private func quit() {
        keyMonitor?.stopMonitoring()
        NSApp.terminate(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false // Keep running even when no windows are open
    }
} 
