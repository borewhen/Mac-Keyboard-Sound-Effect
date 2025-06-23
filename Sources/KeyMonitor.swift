import Cocoa
import Carbon

class KeyMonitor {
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private let callback: () -> Void
    
    init(callback: @escaping () -> Void) {
        self.callback = callback
        print("KeyMonitor: Initialized")
    }
    
    func startMonitoring() {
        print("KeyMonitor: Starting monitoring...")
        
        // Request accessibility permissions
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        let trusted = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if !trusted {
            print("KeyMonitor: Accessibility permissions are required for key monitoring")
            print("KeyMonitor: Please grant permissions in System Preferences > Security & Privacy > Privacy > Accessibility")
            return
        }
        
        print("KeyMonitor: Accessibility permissions granted")
        
        // Create event tap for key events
        let eventMask = CGEventMask(1 << CGEventType.keyDown.rawValue)
        
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask,
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                // Use a weak reference to avoid retain cycles and crashes
                if let refcon = refcon {
                    let monitor = Unmanaged<KeyMonitor>.fromOpaque(refcon).takeUnretainedValue()
                    DispatchQueue.main.async {
                        print("KeyMonitor: Key event detected, calling callback...")
                        monitor.callback()
                        print("KeyMonitor: Callback completed")
                    }
                }
                return Unmanaged.passUnretained(event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )
        
        if let eventTap = eventTap {
            runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            if let runLoopSource = runLoopSource {
                CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
                CGEvent.tapEnable(tap: eventTap, enable: true)
                print("KeyMonitor: Key monitoring started successfully")
            }
        } else {
            print("KeyMonitor: Failed to create event tap")
        }
    }
    
    func stopMonitoring() {
        print("KeyMonitor: Stopping monitoring...")
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        
        if let runLoopSource = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        }
        
        eventTap = nil
        runLoopSource = nil
        print("KeyMonitor: Key monitoring stopped")
    }
    
    deinit {
        print("KeyMonitor: Deinitializing...")
        stopMonitoring()
    }
} 