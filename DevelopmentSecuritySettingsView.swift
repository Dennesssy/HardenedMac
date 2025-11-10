//
//  DevelopmentSecuritySettingsView.swift
//  Security Hardening Settings - Development Security (Items 41-60)
//
//  Created on November 09, 2025.
//

import SwiftUI

struct DevelopmentSecuritySettingsView: View {
    // Network & HTTP Security
    @AppStorage("blockUnencryptedHTTP") private var blockUnencryptedHTTP = false
    @AppStorage("requireHTTPSEnforcement") private var requireHTTPSEnforcement = true
    
    // Secrets & Credentials
    @AppStorage("blockPlaintextSecrets") private var blockPlaintextSecrets = true
    @AppStorage("blockCloudCredentials") private var blockCloudCredentials = true
    @AppStorage("auditLLMAPIKeys") private var auditLLMAPIKeys = true
    
    // Git Security
    @AppStorage("requireSignedCommits") private var requireSignedCommits = false
    
    // AI Security
    @AppStorage("sandboxAIModelExecution") private var sandboxAIModelExecution = false
    @AppStorage("blockAIOutputExecution") private var blockAIOutputExecution = false
    
    // Deployment & Release
    @AppStorage("requireReviewBeforeDeployment") private var requireReviewBeforeDeployment = true
    @AppStorage("requireSignedReleases") private var requireSignedReleases = true
    
    // Package & Supply Chain
    @AppStorage("lockNPMPackageVersions") private var lockNPMPackageVersions = false
    @AppStorage("blockNPMRegistrySpoofing") private var blockNPMRegistrySpoofing = false
    @AppStorage("blockSupplyChainAttacks") private var blockSupplyChainAttacks = true
    @AppStorage("monitorLicenseCompliance") private var monitorLicenseCompliance = false
    
    // Telemetry
    @AppStorage("disableTelemetry") private var disableTelemetry = false
    
    // State variables
    @State private var isAuditingEnvVars = false
    @State private var suspiciousEnvVars = 0
    
    @State private var isAuditingGitHistory = false
    @State private var secretsInGitHistory = 0
    
    @State private var isAuditingIntegrations = false
    @State private var integrationCount = 0
    
    @State private var isAuditingNodeModules = false
    @State private var cveCount = 0
    @State private var lastCVEAudit: Date?
    
    @State private var isMonitoringAPIRateLimits = false
    @State private var apiServices: [APIService] = []
    @State private var showingAddService = false
    @State private var newServiceName = ""
    @State private var newServiceLimit = 100
    
    var body: some View {
        Form {
            // MARK: - Network Security
            Section {
                Toggle("Block Unencrypted HTTP Requests", isOn: $blockUnencryptedHTTP)
                    .help("Force all network requests to use HTTPS")
                
                Toggle("Require HTTPS Enforcement", isOn: $requireHTTPSEnforcement)
                    .help("Enable App Transport Security (ATS) and HTTPS-only mode")
                
            } header: {
                Label("Network Security", systemImage: "network.badge.shield.half.filled")
            } footer: {
                Text("Enforce secure network communication protocols")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Secrets & Credentials
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Audit Environment Variables")
                            if suspiciousEnvVars > 0 {
                                Text("\(suspiciousEnvVars) suspicious variables found")
                                    .font(.caption)
                                    .foregroundStyle(.orange)
                            } else {
                                Text("Click to scan for exposed credentials")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            auditEnvironmentVariables()
                        } label: {
                            if isAuditingEnvVars {
                                ProgressView().controlSize(.small)
                            } else {
                                Text("Audit Now")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAuditingEnvVars)
                    }
                }
                
                Toggle("Block Plaintext Secrets in Git", isOn: $blockPlaintextSecrets)
                    .help("Prevent committing unencrypted secrets")
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Audit Git History for Secrets")
                            if secretsInGitHistory > 0 {
                                Text("\(secretsInGitHistory) potential secrets found")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            } else {
                                Text("Scan commit history for exposed credentials")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            auditGitHistory()
                        } label: {
                            if isAuditingGitHistory {
                                ProgressView().controlSize(.small)
                            } else {
                                Text("Scan History")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAuditingGitHistory)
                    }
                }
                
                Toggle("Block Cloud Credentials in Code", isOn: $blockCloudCredentials)
                    .help("Prevent hardcoding AWS, Azure, GCP credentials")
                
                Toggle("Audit LLM API Keys", isOn: $auditLLMAPIKeys)
                    .help("Monitor and validate AI service API keys")
                
            } header: {
                Label("Secrets Management", systemImage: "key.fill")
            } footer: {
                Text("Prevent credential exposure in code and version control")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Git & Version Control
            Section {
                Toggle("Require Signed Commits", isOn: $requireSignedCommits)
                    .help("Enforce GPG/SSH commit signing")
                
            } header: {
                Label("Version Control", systemImage: "arrow.triangle.branch")
            } footer: {
                Text("Strengthen git security and commit verification")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - AI Security
            Section {
                Toggle("Sandbox AI Model Execution", isOn: $sandboxAIModelExecution)
                    .help("Isolate AI model inference from system")
                
                Toggle("Block Execution of AI Output", isOn: $blockAIOutputExecution)
                    .help("Prevent running code generated by AI models")
                
            } header: {
                Label("AI Security", systemImage: "brain")
            } footer: {
                Text("Control AI model execution and output handling")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Deployment Security
            Section {
                Toggle("Require Review Before Deployment", isOn: $requireReviewBeforeDeployment)
                    .help("Mandate code review for production deploys")
                
                Toggle("Require Signed Releases", isOn: $requireSignedReleases)
                    .help("Enforce code signing for release builds")
                
            } header: {
                Label("Deployment", systemImage: "arrow.up.doc.fill")
            } footer: {
                Text("Control deployment processes and release signing")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Package & Dependency Security
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Audit node_modules for CVEs")
                            if let lastAudit = lastCVEAudit {
                                HStack(spacing: 4) {
                                    Text("Last audit: \(lastAudit, format: .relative(presentation: .named))")
                                    if cveCount > 0 {
                                        Text("•")
                                        Text("\(cveCount) vulnerabilities")
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
                            auditNodeModules()
                        } label: {
                            if isAuditingNodeModules {
                                ProgressView().controlSize(.small)
                            } else {
                                Text("Audit CVEs")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAuditingNodeModules)
                    }
                }
                
                Toggle("Lock NPM Package Versions", isOn: $lockNPMPackageVersions)
                    .help("Use exact versions in package.json")
                
                Toggle("Block NPM Registry Spoofing", isOn: $blockNPMRegistrySpoofing)
                    .help("Verify package registry authenticity")
                
                Toggle("Block Supply Chain Attacks", isOn: $blockSupplyChainAttacks)
                    .help("Monitor for malicious package updates")
                
                Toggle("Monitor License Compliance", isOn: $monitorLicenseCompliance)
                    .help("Track software licenses in dependencies")
                
            } header: {
                Label("Package Security", systemImage: "shippingbox.fill")
            } footer: {
                Text("Protect against dependency vulnerabilities and supply chain attacks")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Third-Party Integration
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Audit Third-Party Integrations")
                            if integrationCount > 0 {
                                Text("\(integrationCount) integrations found")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            } else {
                                Text("No integrations detected")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            auditThirdPartyIntegrations()
                        } label: {
                            if isAuditingIntegrations {
                                ProgressView().controlSize(.small)
                            } else {
                                Text("Audit Now")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(isAuditingIntegrations)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Monitor API Rate Limits")
                        Spacer()
                        Button {
                            showingAddService.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .buttonStyle(.plain)
                    }
                    
                    if showingAddService {
                        VStack(spacing: 8) {
                            TextField("Service Name", text: $newServiceName)
                                .textFieldStyle(.roundedBorder)
                            
                            HStack {
                                Text("Rate Limit:")
                                Stepper("\(newServiceLimit) req/min", value: $newServiceLimit, in: 10...10000, step: 10)
                            }
                            
                            HStack {
                                Button("Cancel") {
                                    showingAddService = false
                                    newServiceName = ""
                                    newServiceLimit = 100
                                }
                                .buttonStyle(.bordered)
                                
                                Button("Add Service") {
                                    if !newServiceName.isEmpty {
                                        apiServices.append(APIService(name: newServiceName, rateLimit: newServiceLimit))
                                        showingAddService = false
                                        newServiceName = ""
                                        newServiceLimit = 100
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(newServiceName.isEmpty)
                            }
                        }
                        .padding(.leading, 20)
                    }
                    
                    if !apiServices.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(apiServices) { service in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(service.name)
                                            .font(.body)
                                        Text("\(service.rateLimit) requests/min")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Button {
                                        apiServices.removeAll { $0.id == service.id }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.red)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(8)
                                .background(.quaternary.opacity(0.5))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                
            } header: {
                Label("Integrations", systemImage: "point.3.connected.trianglepath.dotted")
            } footer: {
                Text("Monitor third-party services and API usage")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // MARK: - Privacy & Telemetry
            Section {
                Toggle("Disable Telemetry/Analytics", isOn: $disableTelemetry)
                    .help("Block usage data collection and reporting")
                
            } header: {
                Label("Privacy", systemImage: "hand.raised.fill")
            } footer: {
                Text("Control data collection and analytics")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Development Security")
    }
    
    // MARK: - Helper Methods
    
    private func auditEnvironmentVariables() {
        isAuditingEnvVars = true
        
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            
            await MainActor.run {
                // TODO: Implement environment variable audit
                // - Scan process environment
                // - Check for common secret patterns (API_KEY, PASSWORD, etc.)
                // - Validate encryption status
                suspiciousEnvVars = Int.random(in: 0...5)
                isAuditingEnvVars = false
            }
        }
    }
    
    private func auditGitHistory() {
        isAuditingGitHistory = true
        
        Task {
            try? await Task.sleep(for: .seconds(3))
            
            await MainActor.run {
                // TODO: Implement git history scan
                // - Use git log to scan commits
                // - Search for credential patterns
                // - Check for accidentally committed secrets
                secretsInGitHistory = Int.random(in: 0...8)
                isAuditingGitHistory = false
            }
        }
    }
    
    private func auditNodeModules() {
        isAuditingNodeModules = true
        
        Task {
            try? await Task.sleep(for: .seconds(2.5))
            
            await MainActor.run {
                // TODO: Implement npm audit
                // - Run npm audit or equivalent
                // - Check against CVE databases
                // - Report vulnerable packages
                cveCount = Int.random(in: 0...15)
                lastCVEAudit = Date()
                isAuditingNodeModules = false
            }
        }
    }
    
    private func auditThirdPartyIntegrations() {
        isAuditingIntegrations = true
        
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            
            await MainActor.run {
                // TODO: Implement integration audit
                // - Scan for API keys and credentials
                // - Check integration permissions
                // - Validate OAuth scopes
                integrationCount = Int.random(in: 0...10)
                isAuditingIntegrations = false
            }
        }
    }
}

// MARK: - Supporting Types

struct APIService: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let rateLimit: Int
}

#Preview {
    NavigationStack {
        DevelopmentSecuritySettingsView()
    }
    .frame(width: 700, height: 900)
}
