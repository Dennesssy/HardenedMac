//
//  SystemSecuritySettingsView.swift
//  Security Hardening Settings - System & SSH (Items 11-20)
//
//  Created on November 09, 2025.
//

import SwiftUI

struct SystemSecuritySettingsView: View {
    @AppStorage("disableSSHPasswordAuth") private var disableSSHPasswordAuth = false
    @AppStorage("blockSudoWithoutPassword") private var blockSudoWithoutPassword = true
    @AppStorage("monitorSSHAccess") private var monitorSSHAccess = false
    @AppStorage("sshAlertEmail") private var sshAlertEmail = ""
    @AppStorage("blockEvalExec") private var blockEvalExec = false
    
    @State private var isAuditingSSHKeys = false
    @State private var sshKeyCount = 0
    @State private var lastSSHKeyAudit: Date?
    
    @State private var isScanningSensitiveFiles = false
    @State private var worldReadableFileCount = 0
    
    @State private var isAuditingCronJobs = false
    @State private var suspiciousCronJobs = 0
    @State private var lastCronAudit: Date?
    
    @State private var isAuditingLaunchAgents = false
    @State private var launchAgentCount = 0
    @State private var lastLaunchAgentAudit: Date?
    
    @State private var tmpPermissions = "1777"
    @State private var isAuditingGitHooks = false
    @State private var gitHookCount = 0
    
    var body: some View {
        Form {
            // MARK: - SSH Security
            Section {
                Toggle("Disable SSH Password Authentication", isOn: $disableSSHPasswordAuth)
                    .help("Require key-based authentication only")
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Audit ~/.ssh/authorized_keys")
                            if let lastAudit = lastSSHKeyAudit {
                                HStack(spacing: 4) {
                                    Text("Last audit: \(lastAudit, format: .relative(presentation: .named))")
                                    if sshKeyCount > 0 {
                                        Text("•")
                                        Text("\(sshKeyCount) keys found")
                                    }
                                }
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
                            auditSSHKeys()
                        } label: {
                            if isAuditingSSHKeys {
                                ProgressView().controlSize(.small)
                            } else {
                                Text("Review Keys")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAuditingSSHKeys)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Toggle("Monitor Port 22 (SSH) Access", isOn: $monitorSSHAccess)
                        .help("Track and log SSH connection attempts")
                    
                    if monitorSSHAccess {
                        HStack {
                            Text("Alert Email:")
                                .foregroundStyle(.secondary)
                            TextField("email@example.com", text: $sshAlertEmail)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: 300)
                        }
                        .padding(.leading, 20)
                    }
                }
                
            } header: {
                Label("SSH Security", systemImage: "lock.shield.fill")
            } footer: {
                Text("Strengthen SSH access controls and monitoring")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - File System Permissions
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Remove World-Readable Files")
                            if worldReadableFileCount > 0 {
                                Text("\(worldReadableFileCount) files found")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            } else if isScanningSensitiveFiles {
                                Text("Scanning...")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("Click to scan sensitive directories")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            scanForWorldReadableFiles()
                        } label: {
                            if isScanningSensitiveFiles {
                                ProgressView().controlSize(.small)
                            } else {
                                Text("Scan & Fix")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isScanningSensitiveFiles)
                    }
                }
                
                HStack {
                    Text("Lock Down /tmp Permissions")
                    Spacer()
                    Picker("", selection: $tmpPermissions) {
                        Text("1777 (Sticky)").tag("1777")
                        Text("0755 (Restrictive)").tag("0755")
                        Text("0750 (Very Restrictive)").tag("0750")
                        Text("0700 (Owner Only)").tag("0700")
                    }
                    .frame(width: 180)
                }
                .help("Control /tmp directory access permissions")
                
            } header: {
                Label("File Permissions", systemImage: "folder.badge.questionmark")
            } footer: {
                Text("Manage file and directory access permissions")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - System Tasks & Jobs
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Audit Cron Jobs for Exploits")
                            if let lastAudit = lastCronAudit {
                                HStack(spacing: 4) {
                                    Text("Last audit: \(lastAudit, format: .relative(presentation: .named))")
                                    if suspiciousCronJobs > 0 {
                                        Text("•")
                                        Text("\(suspiciousCronJobs) suspicious")
                                            .foregroundStyle(.red)
                                    }
                                }
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
                            auditCronJobs()
                        } label: {
                            if isAuditingCronJobs {
                                ProgressView().controlSize(.small)
                            } else {
                                Text("Audit Now")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAuditingCronJobs)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Audit LaunchAgents Permissions")
                            if let lastAudit = lastLaunchAgentAudit {
                                HStack(spacing: 4) {
                                    Text("Last audit: \(lastAudit, format: .relative(presentation: .named))")
                                    if launchAgentCount > 0 {
                                        Text("•")
                                        Text("\(launchAgentCount) agents")
                                    }
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            } else {
                                Text("Never audited")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            }
                        }
                        
                        Spacer()
                        
                        if launchAgentCount > 0 {
                            Text("\(launchAgentCount)")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(.blue.opacity(0.2))
                                .foregroundStyle(.blue)
                                .clipShape(Capsule())
                        }
                        
                        Button {
                            auditLaunchAgents()
                        } label: {
                            if isAuditingLaunchAgents {
                                ProgressView().controlSize(.small)
                            } else {
                                Text("Review Agents")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAuditingLaunchAgents)
                    }
                }
                
            } header: {
                Label("System Jobs", systemImage: "calendar.badge.clock")
            } footer: {
                Text("Monitor scheduled tasks and background processes")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Script & Execution Security
            Section {
                Toggle("Block eval/exec in Scripts", isOn: $blockEvalExec)
                    .help("Prevent dynamic code evaluation in shell scripts")
                
                Toggle("Block sudo Without Password", isOn: $blockSudoWithoutPassword)
                    .help("Require password for all sudo commands")
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Audit Git Hooks for Malware")
                            if gitHookCount > 0 {
                                Text("\(gitHookCount) hooks found")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("No git hooks detected")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            auditGitHooks()
                        } label: {
                            if isAuditingGitHooks {
                                ProgressView().controlSize(.small)
                            } else {
                                Text("Scan Hooks")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAuditingGitHooks)
                    }
                }
                
            } header: {
                Label("Execution Control", systemImage: "play.slash.fill")
            } footer: {
                Text("Control script execution and privilege escalation")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("System Security")
    }
    
    // MARK: - Helper Methods
    
    private func auditSSHKeys() {
        isAuditingSSHKeys = true
        
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            
            await MainActor.run {
                // TODO: Implement actual SSH key audit
                // - Parse ~/.ssh/authorized_keys
                // - Check key formats and fingerprints
                // - Validate key permissions
                sshKeyCount = Int.random(in: 1...5)
                lastSSHKeyAudit = Date()
                isAuditingSSHKeys = false
            }
        }
    }
    
    private func scanForWorldReadableFiles() {
        isScanningSensitiveFiles = true
        
        Task {
            try? await Task.sleep(for: .seconds(2))
            
            await MainActor.run {
                // TODO: Implement actual file permission scan
                // - Check sensitive directories
                // - Find files with 0644/0664 permissions
                // - Offer to fix permissions
                worldReadableFileCount = Int.random(in: 0...15)
                isScanningSensitiveFiles = false
            }
        }
    }
    
    private func auditCronJobs() {
        isAuditingCronJobs = true
        
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            
            await MainActor.run {
                // TODO: Implement cron job audit
                // - Parse user and system crontabs
                // - Check for suspicious commands
                // - Validate script permissions
                suspiciousCronJobs = Int.random(in: 0...3)
                lastCronAudit = Date()
                isAuditingCronJobs = false
            }
        }
    }
    
    private func auditLaunchAgents() {
        isAuditingLaunchAgents = true
        
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            
            await MainActor.run {
                // TODO: Implement LaunchAgent audit
                // - Scan ~/Library/LaunchAgents
                // - Check /Library/LaunchAgents
                // - Validate permissions and owners
                launchAgentCount = Int.random(in: 0...12)
                lastLaunchAgentAudit = Date()
                isAuditingLaunchAgents = false
            }
        }
    }
    
    private func auditGitHooks() {
        isAuditingGitHooks = true
        
        Task {
            try? await Task.sleep(for: .seconds(1))
            
            await MainActor.run {
                // TODO: Implement git hook scan
                // - Find all .git/hooks directories
                // - Scan hook scripts for malicious patterns
                // - Check hook permissions
                gitHookCount = Int.random(in: 0...8)
                isAuditingGitHooks = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        SystemSecuritySettingsView()
    }
    .frame(width: 650, height: 700)
}
