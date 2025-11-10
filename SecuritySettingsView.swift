//
//  SecuritySettingsView.swift
//  Security Hardening Settings
//
//  Created on November 09, 2025.
//

import SwiftUI

struct SecuritySettingsView: View {
    @AppStorage("blockDangerousShellCommands") private var blockDangerousShellCommands = false
    @AppStorage("requireMFA") private var requireMFA = false
    @AppStorage("disableImplicitFileAccess") private var disableImplicitFileAccess = false
    @AppStorage("requireDatabaseAuth") private var requireDatabaseAuth = true
    @AppStorage("blockNetworkTools") private var blockNetworkTools = false
    @AppStorage("sandboxDevelopment") private var sandboxDevelopment = false
    @AppStorage("blockGitCredentialCaching") private var blockGitCredentialCaching = false
    @AppStorage("blockFileDescriptorLeaks") private var blockFileDescriptorLeaks = false
    
    @State private var selectedDirectories: [URL] = []
    @State private var showingDirectoryPicker = false
    @State private var isAuditingAPIKeys = false
    @State private var lastAPIKeyAudit: Date?
    @AppStorage("autoAuditAPIKeys") private var autoAuditAPIKeys = false
    
    var body: some View {
        Form {
            // MARK: - Command & Script Protection
            Section {
                Toggle("Block Dangerous Shell Commands", isOn: $blockDangerousShellCommands)
                    .help("Prevents execution of potentially harmful shell commands")
                
                Toggle("Block eval/exec in Scripts", isOn: $blockFileDescriptorLeaks)
                    .help("Blocks dynamic code evaluation and execution")
                
            } header: {
                Label("Command Protection", systemImage: "terminal.fill")
            } footer: {
                Text("Restricts execution of potentially dangerous commands and scripts")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Authentication & Access Control
            Section {
                Toggle("Require MFA for Sensitive Tools", isOn: $requireMFA)
                    .help("Enables multi-factor authentication for critical operations")
                
                Toggle("Require Authentication for Database Access", isOn: $requireDatabaseAuth)
                    .help("Enforces authentication before accessing databases")
                
            } header: {
                Label("Authentication", systemImage: "key.fill")
            } footer: {
                Text("Strengthen access control with additional authentication layers")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - File System Security
            Section {
                Toggle("Disable Implicit File Access", isOn: $disableImplicitFileAccess)
                    .help("Requires explicit permission for file operations")
                
                Toggle("Block File Descriptor Leaks", isOn: $blockFileDescriptorLeaks)
                    .help("Prevents file descriptor leakage between processes")
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Encrypt Sensitive Directories")
                        Spacer()
                        Button("Select Directories...") {
                            showingDirectoryPicker = true
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    if !selectedDirectories.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(selectedDirectories, id: \.self) { url in
                                HStack {
                                    Image(systemName: "folder.fill")
                                        .foregroundStyle(.secondary)
                                    Text(url.path)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Button {
                                        removeDirectory(url)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.tertiary)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
            } header: {
                Label("File System", systemImage: "folder.fill.badge.gearshape")
            } footer: {
                Text("Control file access and protect sensitive data")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Network & External Tools
            Section {
                Toggle("Block Network Tools (curl/wget)", isOn: $blockNetworkTools)
                    .help("Prevents use of common network download utilities")
                
                Toggle("Block Git Credential Caching", isOn: $blockGitCredentialCaching)
                    .help("Disables storing Git credentials in memory")
                
            } header: {
                Label("Network Security", systemImage: "network")
            } footer: {
                Text("Restrict network access and external tool usage")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Development Environment
            Section {
                Toggle("Sandbox Development Environments", isOn: $sandboxDevelopment)
                    .help("Isolates development tools from the system")
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("API Key Exposure Audit")
                            if let lastAudit = lastAPIKeyAudit {
                                Text("Last audit: \(lastAudit, format: .relative(presentation: .named))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Never audited")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            runAPIKeyAudit()
                        } label: {
                            if isAuditingAPIKeys {
                                ProgressView()
                                    .controlSize(.small)
                            } else {
                                Text("Run Audit Now")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAuditingAPIKeys)
                    }
                    
                    Toggle("Enable Automatic Auditing", isOn: $autoAuditAPIKeys)
                        .help("Automatically scan for exposed API keys in code")
                }
                
            } header: {
                Label("Development", systemImage: "hammer.fill")
            } footer: {
                Text("Security controls for development workflows")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Security Hardening")
        .fileImporter(
            isPresented: $showingDirectoryPicker,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: true
        ) { result in
            handleDirectorySelection(result)
        }
    }
    
    // MARK: - Helper Methods
    
    private func removeDirectory(_ url: URL) {
        selectedDirectories.removeAll { $0 == url }
    }
    
    private func handleDirectorySelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            selectedDirectories.append(contentsOf: urls)
        case .failure(let error):
            print("Directory selection failed: \(error.localizedDescription)")
        }
    }
    
    private func runAPIKeyAudit() {
        isAuditingAPIKeys = true
        
        // Simulate audit process
        Task {
            try? await Task.sleep(for: .seconds(2))
            
            await MainActor.run {
                lastAPIKeyAudit = Date()
                isAuditingAPIKeys = false
            }
            
            // TODO: Implement actual API key scanning logic
            // - Scan source files for common API key patterns
            // - Check for exposed credentials in git history
            // - Validate .gitignore coverage
        }
    }
}

#Preview {
    NavigationStack {
        SecuritySettingsView()
    }
    .frame(width: 600, height: 700)
}
