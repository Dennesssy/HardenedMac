//
//  HardenedMacApp.swift
//  HardenedMac
//
//  Created by Dennis Stewart Jr. on 11/9/25.
//

import SwiftUI

// NOTE: This is **not** the app’s entry point any more.
// The real entry point is `FCloudUIApp` defined in FCloudUI.swift.
// Keeping this struct can be handy for previewing or testing isolated UI.
struct HardenedMacPlaceholder: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Model

/// Simple model that represents a group of cache locations.
struct CacheGroup: Identifiable {
    let id = UUID()
    let title: String
    let items: [String]
    let color: Color
}

// MARK: - Sample Data

fileprivate let cacheGroups: [CacheGroup] = [
    CacheGroup(
        title: "Xcode Development (6 locations)",
        items: [
            "Derived Data (typically 10‑50 GB)",
            "Archives",
            "Device Support",
            "Simulator Caches",
            "SwiftUI Previews",
            "Build Cache"
        ],
        color: .blue
    ),
    CacheGroup(
        title: "Browser & Internet (8 locations)",
        items: [
            "Safari History & Cache",
            "Chrome Cache (Default & Code Cache)",
            "Firefox Cache & Profiles",
            "Browser Cookies"
        ],
        color: .orange
    ),
    CacheGroup(
        title: "Development Tools (12 locations)",
        items: [
            "Build Tools: NPM, Gradle, Maven, Pip",
            "Languages: Rust Cargo, Ruby (Gems & Versions), Python (venv & cache)",
            "Package Managers: CocoaPods, Gem Cache",
            "Build Artifacts: Maven Repository"
        ],
        color: .purple
    ),
    CacheGroup(
        title: "Container & Cloud (5 locations)",
        items: [
            "Docker (Overlay, Images, BuildX)",
            "Minikube Cache",
            "Kubernetes Cache",
            "Kubectl Config",
            "AWS CLI Cache"
        ],
        color: .green
    ),
    CacheGroup(
        title: "IDEs & Editors (8 locations)",
        items: [
            "VSCode Extensions & Cache",
            "Code/VSCodium Cache",
            "IntelliJ IDEA (Caches, System, Indexing)",
            "Eclipse Cache",
            "Maven Repository"
        ],
        color: .pink
    ),
    CacheGroup(
        title: "System & Logs (5 locations)",
        items: [
            "System Caches",
            "System Library Caches",
            "System Logs",
            "Var Logs",
            "Crash Reports"
        ],
        color: .red
    ),
    CacheGroup(
        title: "Temporary & Cleanup (5 locations)",
        items: [
            "Trash Bin",
            "Temporary Items",
            "/var/tmp",
            "/tmp",
            "Downloads Folder"
        ],
        color: .gray
    ),
    CacheGroup(
        title: "Package Managers (3 locations)",
        items: [
            "Homebrew Cache & Downloads",
            "MacPorts Cache"
        ],
        color: .yellow
    ),
    CacheGroup(
        title: "Application & Recent (6 locations)",
        items: [
            "Application Caches",
            "Local Share",
            "Recently Used Files",
            "Recent Documents",
            "Recent Servers",
            "Xcode Preferences"
        ],
        color: .teal
    )
]

// MARK: - View

struct ContentView: View {
    // MARK: Layout helpers
    private let bullet = "•"
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // ---- Header -------------------------------------------------
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enhanced Cleaning System – Outperforms CleanMyMac")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(.primary)
                    
                    Text("""
                        • Comprehensive Coverage – 55+ locations vs CleanMyMac's ~30
                        • Development‑Focused – 35+ development cache locations
                        • Container Support – Docker, Kubernetes, Minikube scanning
                        • Color‑Coded Display – Visual categorization with 16+ color schemes
                        • Size Sorting – Largest files first for maximum impact
                        • Selective Deletion – Choose exactly what to remove
                        • Real‑time Feedback – Success/failure counts per deletion
                        • Safe Deletion – One‑by‑one removal with error handling
                        """)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // ---- Sections ------------------------------------------------
                ForEach(cacheGroups) { group in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(group.title)
                            .font(.headline)
                            .foregroundColor(group.color)
                        
                        // Bullet list
                        ForEach(group.items, id: \.self) { item in
                            HStack(alignment: .top, spacing: 4) {
                                Text(bullet)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(item)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // ---- Footer -------------------------------------------------
                Text("Total Scan Coverage: 55+ Cache Locations")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 600, height: 800)
    }
}
