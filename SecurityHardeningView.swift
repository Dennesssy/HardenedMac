//
//  SecurityHardeningView.swift
//  Main Security Settings Container with Sidebar Navigation
//
//  Created on November 09, 2025.
//

import SwiftUI

struct SecurityHardeningView: View {
    @State private var selectedCategory: SecurityCategory? = .basicHardening
    
    var body: some View {
        NavigationSplitView {
            // MARK: - Sidebar
            List(selection: $selectedCategory) {
                Section("Security Hardening") {
                    ForEach(SecurityCategory.allCases) { category in
                        NavigationLink(value: category) {
                            Label(category.title, systemImage: category.icon)
                        }
                    }
                }
            }
            .navigationTitle("Security")
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
            #endif
            
        } detail: {
            // MARK: - Detail View
            if let selectedCategory {
                categoryView(for: selectedCategory)
            } else {
                SecurityOverviewView()
            }
        }
    }
    
    @ViewBuilder
    private func categoryView(for category: SecurityCategory) -> some View {
        switch category {
        case .basicHardening:
            SecuritySettingsView()
        case .systemSecurity:
            SystemSecuritySettingsView()
        case .automationMonitoring:
            AutomationMonitoringSettingsView()
        case .developmentSecurity:
            DevelopmentSecuritySettingsView()
        }
    }
}

// MARK: - Security Category Enum

enum SecurityCategory: String, CaseIterable, Identifiable {
    case basicHardening = "Basic Hardening"
    case systemSecurity = "System Security"
    case automationMonitoring = "Automation & Monitoring"
    case developmentSecurity = "Development Security"
    
    var id: String { rawValue }
    
    var title: String {
        rawValue
    }
    
    var icon: String {
        switch self {
        case .basicHardening:
            return "shield.fill"
        case .systemSecurity:
            return "lock.shield.fill"
        case .automationMonitoring:
            return "gear.badge.checkmark"
        case .developmentSecurity:
            return "hammer.fill"
        }
    }
    
    var description: String {
        switch self {
        case .basicHardening:
            return "Essential security controls including command protection, authentication, file system security, and development environment safeguards."
        case .systemSecurity:
            return "System-level security including SSH hardening, file permissions, scheduled task auditing, and execution controls."
        case .automationMonitoring:
            return "Automated monitoring and security enforcement for processes, network activity, containers, and system resources."
        case .developmentSecurity:
            return "Development workflow security including secrets management, git security, AI controls, package auditing, and supply chain protection."
        }
    }
    
    var itemCount: Int {
        switch self {
        case .basicHardening:
            return 10
        case .systemSecurity:
            return 10
        case .automationMonitoring:
            return 20
        case .developmentSecurity:
            return 20
        }
    }
}

// MARK: - Overview View

struct SecurityOverviewView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(.blue)
                    
                    Text("Security Hardening")
                        .font(.largeTitle.bold())
                    
                    Text("Comprehensive security controls for your development environment and system")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                Divider()
                    .padding(.horizontal, 40)
                
                // Categories Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(SecurityCategory.allCases) { category in
                        CategoryCard(category: category)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Quick Stats
                GroupBox {
                    VStack(spacing: 12) {
                        HStack {
                            Label("Total Security Controls", systemImage: "checklist")
                            Spacer()
                            Text("60")
                                .font(.title2.bold())
                                .foregroundStyle(.blue)
                        }
                        
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Categories")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("4")
                                    .font(.title3.bold())
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Audit Tools")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("15")
                                    .font(.title3.bold())
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Monitoring")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text("12")
                                    .font(.title3.bold())
                            }
                        }
                    }
                    .padding()
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Overview")
    }
}

struct CategoryCard: View {
    let category: SecurityCategory
    
    var body: some View {
        NavigationLink(value: category) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: category.icon)
                        .font(.title)
                        .foregroundStyle(.blue)
                    
                    Spacer()
                    
                    Text("\(category.itemCount)")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.blue.opacity(0.2))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
                
                Text(category.title)
                    .font(.headline)
                
                Text(category.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                
                Spacer()
            }
            .padding()
            .frame(height: 180)
            .background(.quaternary.opacity(0.5))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Main View") {
    SecurityHardeningView()
        .frame(width: 1000, height: 700)
}

#Preview("Overview") {
    NavigationStack {
        SecurityOverviewView()
    }
    .frame(width: 800, height: 700)
}
