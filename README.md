# Security Hardening Settings for macOS

A comprehensive SwiftUI-based security settings interface with 60+ security controls organized into 4 main categories.

## 📁 Files Created

### Core Views
- **`SecurityHardeningView.swift`** - Main container with sidebar navigation
- **`SecuritySettingsView.swift`** - Basic Hardening (Items 1-10)
- **`SystemSecuritySettingsView.swift`** - System Security (Items 11-20)
- **`AutomationMonitoringSettingsView.swift`** - Automation & Monitoring (Items 21-40)
- **`DevelopmentSecuritySettingsView.swift`** - Development Security (Items 41-60)

### Supporting Files
- **`SecurityHardeningApp.swift`** - Example app integration
- **`SecuritySettingsControlMapping.swift`** - Complete control mapping documentation

## 🎯 Features

### UI Controls Used
- **38 Toggles** - On/off switches for security features
- **16 Audit Buttons** - Trigger security scans and audits
- **1 Picker** - Permission level selection
- **2 Text Fields** - Email input and command entry
- **3 Expandable Sections** - Dynamic lists for commands, services, and directories

### Architecture Highlights
✅ **Persistent Settings** - Uses `@AppStorage` for automatic UserDefaults storage  
✅ **Async Operations** - All audit functions use Swift Concurrency  
✅ **Loading States** - Progress indicators during scans  
✅ **Relative Timestamps** - "2 minutes ago" style formatting  
✅ **Badge Indicators** - Count displays for findings  
✅ **Help Tooltips** - Hover help text for all controls  
✅ **Grouped Forms** - Native macOS settings styling  
✅ **SF Symbols** - Consistent iconography  

## 📊 Security Categories

### 1. Basic Hardening (10 settings)
- Command & script protection
- Authentication controls
- File system security
- Network restrictions
- Development environment isolation

### 2. System Security (10 settings)
- SSH hardening
- File permissions
- Scheduled task auditing
- Execution controls

### 3. Automation & Monitoring (20 settings)
- Process monitoring
- Network monitoring
- Container security
- Package management
- Browser extension auditing

### 4. Development Security (20 settings)
- Secrets management
- Git security
- AI model controls
- Dependency auditing
- Supply chain protection

## 🚀 Quick Start

### Option 1: Standalone App
```swift
import SwiftUI

@main
struct MySecurityApp: App {
    var body: some Scene {
        WindowGroup {
            SecurityHardeningView()
                .frame(minWidth: 900, minHeight: 600)
        }
    }
}
```

### Option 2: Add to Existing Sidebar
```swift
NavigationSplitView {
    List {
        // Your existing items...
        
        Section("Security") {
            NavigationLink(value: SecurityCategory.basicHardening) {
                Label("Basic Hardening", systemImage: "shield.fill")
            }
            NavigationLink(value: SecurityCategory.systemSecurity) {
                Label("System Security", systemImage: "lock.shield.fill")
            }
            NavigationLink(value: SecurityCategory.automationMonitoring) {
                Label("Automation", systemImage: "gear.badge.checkmark")
            }
            NavigationLink(value: SecurityCategory.developmentSecurity) {
                Label("Development", systemImage: "hammer.fill")
            }
        }
    }
} detail: {
    // Detail view
}
```

### Option 3: Sheet Presentation
```swift
@State private var showingSecurity = false

Button("Security Settings") {
    showingSecurity = true
}
.sheet(isPresented: $showingSecurity) {
    NavigationStack {
        SecurityHardeningView()
    }
}
```

## 🔨 Implementation Status

### ✅ Complete
- All UI components
- Navigation structure
- State management
- Loading states
- Mock data demonstrations

### ⚠️ TODO (Implementation Required)
All views contain `TODO` comments marking where actual security logic should be implemented:

#### File System Operations
- Directory encryption
- Permission scanning
- File monitoring
- PATH auditing

#### Process & System Monitoring
- Process killing
- Binary signature verification
- System call monitoring
- Docker container scanning

#### Network Security
- Port monitoring
- DNS query logging
- Connection tracking
- SSH attempt detection

#### Git & Version Control
- Credential scanning
- Commit signature verification
- Hook malware detection
- History secret scanning

#### Package Management
- npm/pip audit integration
- CVE database queries
- Brew package listing
- License compliance checking

## 📱 Platform Support

Designed primarily for **macOS** with:
- Native Settings-style forms
- Sidebar navigation
- File picker integration
- System-level security controls

Can be adapted for iOS/iPadOS by:
- Replacing `NavigationSplitView` with `NavigationStack`
- Using `.navigationDestination` for routing
- Adjusting form styles for mobile
- Removing system-specific features (SSH, LaunchAgents, etc.)

## 🎨 Customization

### Changing Colors
Update the `.foregroundStyle()` modifiers:
```swift
.foregroundStyle(.blue)  // Change to .green, .purple, etc.
```

### Adjusting Layout
Modify frame sizes in previews:
```swift
#Preview {
    SecurityHardeningView()
        .frame(width: 1200, height: 800)  // Customize size
}
```

### Adding New Settings
1. Add toggle/state variable to appropriate view
2. Add UI control in the Form
3. Implement logic in helper methods
4. Update control mapping documentation

## 🔐 Security Considerations

This interface provides **controls** for security features. Actual implementation requires:

- **System-level permissions** (Full Disk Access, etc.)
- **Root/sudo access** for some operations
- **Helper tools** or daemons for monitoring
- **Sandboxing considerations** for App Store distribution
- **Entitlements** for file access, network monitoring, etc.

## 📝 License

Customize as needed for your project.

## 🤝 Contributing

To add new security settings:
1. Choose appropriate category file
2. Add control in the form
3. Add state management with `@AppStorage`
4. Implement logic in helper methods
5. Update mapping documentation

---

**Total Settings:** 60  
**Total Views:** 5  
**Lines of Code:** ~1,500+  
**Platform:** macOS (adaptable to iOS)  
**Framework:** SwiftUI
