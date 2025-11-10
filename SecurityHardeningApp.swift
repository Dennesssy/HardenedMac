//
//  SecurityHardeningApp.swift
//  Example app integration for Security Hardening Settings
//
//  Created on November 09, 2025.
//

import SwiftUI

@main
struct SecurityHardeningApp: App {
    var body: some Scene {
        WindowGroup {
            SecurityHardeningView()
                .frame(minWidth: 900, minHeight: 600)
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        #endif
        
        #if os(macOS)
        // Additional settings window (optional)
        Settings {
            SecurityHardeningView()
        }
        #endif
    }
}

// MARK: - Alternative Integration Examples

/*
 
 INTEGRATION OPTIONS
 ===================
 
 1️⃣ Standalone Window (Current implementation)
    Use SecurityHardeningView() as the main content view
 
 2️⃣ Settings Window (macOS)
    Add to Settings scene for macOS apps:
    
    Settings {
        SecurityHardeningView()
    }
 
 3️⃣ Tab within existing app:
    
    TabView {
        YourMainView()
            .tabItem { Label("Main", systemImage: "house") }
        
        SecurityHardeningView()
            .tabItem { Label("Security", systemImage: "shield") }
    }
 
 4️⃣ Sheet presentation:
    
    @State private var showingSecuritySettings = false
    
    Button("Security Settings") {
        showingSecuritySettings = true
    }
    .sheet(isPresented: $showingSecuritySettings) {
        SecurityHardeningView()
    }
 
 5️⃣ Existing sidebar integration:
    
    NavigationSplitView {
        List {
            // Your existing sidebar items
            NavigationLink("Dashboard", destination: DashboardView())
            NavigationLink("Files", destination: FilesView())
            
            // Add security section
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
        // Your detail view logic
    }
 
 6️⃣ Toolbar button:
    
    .toolbar {
        ToolbarItem(placement: .navigation) {
            Button {
                showingSecuritySettings.toggle()
            } label: {
                Label("Security", systemImage: "shield.fill")
            }
        }
    }
 
 */
