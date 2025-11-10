import SwiftUI
import Foundation
import Observation

// MARK: - Models

struct Agent: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    var isRunning: Bool = false
    var isOffline: Bool = false
    let status: String
}

struct Package: Identifiable {
    let id = UUID()
    let name: String
    let version: String
}

struct ShellItem: Identifiable {
    let id = UUID()
    let category: String
    let name: String
    let command: String
}

struct SecurityOption: Identifiable {
    let id = UUID()
    let category: String
    let title: String
    let description: String
    let impact: String
    var enabled: Bool = false
}

// MARK: - Security Execution

class SecurityExecutor {
    static let shared = SecurityExecutor()
    private let fileManager = FileManager.default

    func execute(_ option: SecurityOption, enabled: Bool) {
        switch option.title {
        case "Block python http.server":
            if enabled {
                addShellAlias(for: "python http.server")
            }
        case "Block dangerous shell commands":
            if enabled {
                blockDangerousCommands()
            }
        default:
            break
        }
    }

    private func addShellAlias(for command: String) {
        let alias = "python() { if [[ \"$@\" == *\"http.server\"* ]]; then echo \"❌ http.server is blocked\"; return 1; fi; /usr/bin/python3 \"$@\"; }"
        appendToShellRC(alias, toFile: "~/.zshrc")
    }

    private func blockDangerousCommands() {
        let blocking = "alias eval='echo \"❌ eval blocked\"'\nalias exec='echo \"❌ exec blocked\"'"
        appendToShellRC(blocking, toFile: "~/.zshrc")
    }

    private func appendToShellRC(_ content: String, toFile path: String) {
        let expandedPath = (path as NSString).expandingTildeInPath
        if !fileManager.fileExists(atPath: expandedPath) {
            fileManager.createFile(atPath: expandedPath, contents: nil, attributes: nil)
        }
        if let fileHandle = FileHandle(forWritingAtPath: expandedPath) {
            fileHandle.seekToEndOfFile()
            if let data = "\n\(content)\n".data(using: .utf8) {
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        }
    }
}

// MARK: - ViewModel

@Observable
class AppViewModel {
    var searchQuery = ""
    var selectedTab = "overview"
    var selectedAgent: Agent?

    var agents: [Agent] = [
        Agent(name: "Claude", icon: "brain.head.profile", color: .purple, isRunning: true, status: "Active"),
        Agent(name: "Gemini", icon: "sparkles", color: .orange, isRunning: true, status: "Active"),
        Agent(name: "Crush", icon: "bolt.fill", color: .red, isRunning: false, isOffline: true, status: "Offline"),
        Agent(name: "Codex", icon: "code.slash", color: .green, isRunning: true, status: "Active"),
        Agent(name: "OpenCode", icon: "cube.transparent", color: .blue, isRunning: true, status: "Active"),
        Agent(name: "DeepSeek", icon: "magnifyingglass.circle", color: .cyan, isRunning: false, status: "Idle"),
        Agent(name: "Engineer", icon: "hammer.fill", color: .yellow, isRunning: true, status: "Active"),
        Agent(name: "SwiftAgentSDK", icon: "swift", color: .red, isRunning: false, status: "Idle"),
        Agent(name: "Plandex", icon: "list.clipboard", color: .indigo, isRunning: true, status: "Active"),
    ]

    var packages: [Package] = [
        Package(name: "@anthropic-ai/sdk", version: "1.24.0"),
        Package(name: "swiftui-navigation", version: "2.1.0"),
        Package(name: "async-http-client", version: "1.23.0"),
        Package(name: "vapor", version: "4.92.0"),
        Package(name: "lmdb", version: "0.9.31"),
        Package(name: "sqlite", version: "3.45.0"),
        Package(name: "protobuf", version: "3.25.0"),
        Package(name: "llama-cpp", version: "0.2.25"),
    ]

    var shellItems: [ShellItem] = [
        ShellItem(category: "Aliases", name: "claude-dev", command: "alias claude-dev='ANTHROPIC_API_KEY=$DEV_KEY claude'"),
        ShellItem(category: "Aliases", name: "ll", command: "alias ll='ls -lah'"),
        ShellItem(category: "Cron", name: "Daily Backup", command: "0 2 * * * /usr/local/bin/backup.sh"),
        ShellItem(category: "Cron", name: "Weekly Report", command: "0 0 * * 0 /usr/local/bin/report.sh"),
        ShellItem(category: "Shell Profiles", name: ".zshrc", command: "~/.zshrc - Main shell configuration"),
        ShellItem(category: "Shell Profiles", name: ".bash_profile", command: "~/.bash_profile - Bash configuration"),
        ShellItem(category: "Scripts", name: "backup.sh", command: "/usr/local/bin/backup.sh"),
        ShellItem(category: "Scripts", name: "deploy.sh", command: "/usr/local/bin/deploy.sh"),
    ]

    var projects: [String] = [
        "HardenedMac",
        "FCloud",
        "DevTools",
        "MobileDevTools",
        "SwiftAgentSDK",
        "MCP4MAC",
        "Archon",
        "Development",
        "Practice",
        "AIAgents",
        "ToolKit",
        "Infrastructure",
        "Documentation",
        "UIComponents",
        "Scripts",
        "Automation",
        "Configuration",
        "Testing",
        "Deployment",
        "Security"
    ]

    var securityOptions: [SecurityOption] = [
        SecurityOption(category: "Shell Commands", title: "Block python http.server", description: "Prevent accidental exposure of sensitive files", impact: "High", enabled: true),
        SecurityOption(category: "SSH & Auth", title: "Disable SSH password auth", description: "Force key-based authentication only", impact: "High", enabled: true),
        SecurityOption(category: "Shell Commands", title: "Block dangerous shell commands", description: "Disable eval, exec, source on untrusted input", impact: "High"),
    ]
}

// MARK: - Root View

struct RootView: View {
    @State private var vm = AppViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(nsColor: .controlBackgroundColor),
                    Color(nsColor: .windowBackgroundColor)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Toolbar
                HStack(spacing: 12) {
                    Button(action: {}) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .help("Reload")

                    Button(action: {}) {
                        Label("New Folder", systemImage: "folder.badge.plus")
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.thinMaterial)
                .border(Color.white.opacity(0.1), width: 1)

                HStack(spacing: 0) {
                    // Sidebar
                    VStack(alignment: .leading, spacing: 0) {
                        List {
                            Section("Browse") {
                                NavigationLink(destination: ProjectsView(vm: vm)) {
                                    Label("All Projects", systemImage: "square.grid.2x2")
                                }

                                DisclosureGroup("Agents") {
                                    NavigationLink(destination: AgentsView(vm: vm)) {
                                        Label("All Agents", systemImage: "square.grid.3x3")
                                    }
                                }

                                DisclosureGroup("Packages") {
                                    NavigationLink(destination: PackagesView(vm: vm)) {
                                        Label("All Packages", systemImage: "cube.transparent")
                                    }
                                }

                                DisclosureGroup("Network") {
                                    Label("APIs", systemImage: "globe")
                                    Label("Webhooks", systemImage: "network")
                                }

                                DisclosureGroup("Shell") {
                                    NavigationLink(destination: ShellView(vm: vm)) {
                                        Label("Shell Commands", systemImage: "terminal")
                                    }
                                }

                                DisclosureGroup("Logs") {
                                    NavigationLink(destination: LogsView(vm: vm)) {
                                        Label("IDE Logs", systemImage: "xcode")
                                    }
                                    NavigationLink(destination: LogsView(vm: vm)) {
                                        Label("CLI Logs", systemImage: "terminal")
                                    }
                                    NavigationLink(destination: LogsView(vm: vm)) {
                                        Label("App Logs", systemImage: "square.fill")
                                    }
                                }

                                DisclosureGroup("Telemetry") {
                                    NavigationLink(destination: TelemetryView(vm: vm)) {
                                        Label("Scan & Status", systemImage: "radar")
                                    }
                                }

                                DisclosureGroup("Cleaning") {
                                    NavigationLink(destination: CleaningView(vm: vm)) {
                                        Label("Disk Cleanup", systemImage: "trash")
                                    }
                                }
                            }

                            Section("Status") {
                                Label("Running", systemImage: "play.fill")
                                Label("Offline", systemImage: "wifi.slash")
                            }
                        }
                        .listStyle(.sidebar)
                    }
                    .frame(width: 240)
                    .border(Color.white.opacity(0.1), width: 1)

                    // Main Content
                    VStack(spacing: 0) {
                        HStack(spacing: 24) {
                            TabButton(label: "Overview", isActive: vm.selectedTab == "overview", action: { vm.selectedTab = "overview" })
                            TabButton(label: "Agents", isActive: vm.selectedTab == "agents", action: { vm.selectedTab = "agents" })
                            TabButton(label: "Packages", isActive: vm.selectedTab == "packages", action: { vm.selectedTab = "packages" })
                            TabButton(label: "Shell", isActive: vm.selectedTab == "shell", action: { vm.selectedTab = "shell" })
                            TabButton(label: "Security", isActive: vm.selectedTab == "security", action: { vm.selectedTab = "security" })
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .border(Color.white.opacity(0.1), width: 1)

                        ScrollView {
                            VStack(alignment: .leading, spacing: 24) {
                                if vm.selectedTab == "overview" {
                                    AgentsGridView(vm: vm)
                                } else if vm.selectedTab == "agents" {
                                    AgentsTabView(vm: vm)
                                } else if vm.selectedTab == "packages" {
                                    PackagesTabView(vm: vm)
                                } else if vm.selectedTab == "shell" {
                                    ShellTabView(vm: vm)
                                } else if vm.selectedTab == "security" {
                                    SecurityTabView(vm: vm)
                                } else if vm.selectedTab == "settings" {
                                    SettingsView(vm: vm)
                                }
                            }
                            .padding(16)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color(nsColor: .controlBackgroundColor))
        }
        .environment(vm)
    }
}

// MARK: - Agents Grid (Overview - 9 agents as squares)

struct AgentsGridView: View {
    let vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Agents (\(vm.agents.count))")
                .font(.title3)
                .fontWeight(.semibold)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 12) {
                ForEach(vm.agents) { agent in
                    AgentSquareCard(agent: agent)
                }
            }
        }
    }
}

struct AgentSquareCard: View {
    let agent: Agent

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Image(systemName: agent.icon)
                        .font(.title2)
                        .foregroundColor(agent.color)

                    Text(agent.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }
                Spacer()

                VStack(spacing: 4) {
                    if agent.isRunning {
                        Label("Running", systemImage: "play.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.green.opacity(0.2))
                            .cornerRadius(4)
                    }

                    if agent.isOffline {
                        Label("Offline", systemImage: "wifi.slash")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }

            Spacer()

            HStack {
                Text(agent.status)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .frame(height: 140)
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Agents Tab View (with MCP, Skills, Prompts, Activity)

struct AgentsTabView: View {
    let vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                FloatingPanelButton(label: "MCP Servers", icon: "server.rack", color: .blue)
                FloatingPanelButton(label: "Skills", icon: "sparkles", color: .purple)
                FloatingPanelButton(label: "Prompts", icon: "text.bubble", color: .green)
                FloatingPanelButton(label: "Recent Activity", icon: "clock.fill", color: .orange)
                FloatingPanelButton(label: "Last Update", icon: "arrow.clockwise", color: .red)
                Spacer()
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(12)

            Text("Active Agents")
                .font(.title3)
                .fontWeight(.semibold)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 280))], spacing: 12) {
                ForEach(vm.agents.filter { $0.isRunning }) { agent in
                    AgentDetailCard(agent: agent)
                }
            }
        }
    }
}

struct AgentDetailCard: View {
    let agent: Agent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: agent.icon)
                    .font(.title2)
                    .foregroundColor(agent.color)
                Text(agent.name)
                    .font(.headline)
                Spacer()
                Circle()
                    .fill(agent.isRunning ? .green : .gray)
                    .frame(width: 8, height: 8)
            }

            Text("Status: \(agent.status)")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 8) {
                Label("MCP", systemImage: "link")
                Label("Skills", systemImage: "lightbulb")
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Packages Tab View

struct PackagesTabView: View {
    let vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Installed Packages (.pnpm)")
                .font(.title3)
                .fontWeight(.semibold)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 12) {
                ForEach(vm.packages) { pkg in
                    PackageCard(package: pkg)
                }
            }
        }
    }
}

struct PackageCard: View {
    let package: Package

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "cube.fill")
                    .foregroundColor(.blue)
                Text(package.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                Spacer()
            }

            Text("v\(package.version)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Shell Tab View (Aliases, Cron, Profiles, Scripts)

struct ShellTabView: View {
    let vm: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(Set(vm.shellItems.map { $0.category })).sorted(), id: \.self) { category in
                VStack(alignment: .leading, spacing: 8) {
                    Text(category)
                        .font(.headline)
                        .foregroundColor(.blue)

                    ForEach(vm.shellItems.filter { $0.category == category }) { item in
                        ShellItemRow(item: item)
                    }
                }
                .padding(12)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
        }
    }
}

struct ShellItemRow: View {
    let item: ShellItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.name)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text(item.command)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .monospaced()
        }
        .padding(8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(6)
    }
}

// MARK: - Security Tab View

struct SecurityTabView: View {
    let vm: AppViewModel
    @State private var selectedSection = "hardening" // or "apikeys"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Picker
            Picker("Security Section", selection: $selectedSection) {
                Text("Hardening Options").tag("hardening")
                Text("API Keys").tag("apikeys")
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            if selectedSection == "hardening" {
                // Existing Hardening Options
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Security Options")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("\(vm.securityOptions.filter { $0.enabled }.count)/\(vm.securityOptions.count) enabled")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    ForEach(vm.securityOptions) { option in
                        SecurityOptionRow(option: option)
                    }
                }
            } else {
                // API Keys Management
                SettingsView(vm: vm)
            }
        }
    }
}

struct SecurityOptionRow: View {
    @State var option: SecurityOption
    @State private var showStatus = false

    var body: some View {
        HStack(spacing: 12) {
            Toggle("", isOn: Binding(
                get: { option.enabled },
                set: { newValue in
                    option.enabled = newValue
                    SecurityExecutor.shared.execute(option, enabled: newValue)
                    withAnimation {
                        showStatus = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showStatus = false
                        }
                    }
                }
            ))
            .labelsHidden()

            VStack(alignment: .leading, spacing: 4) {
                Text(option.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(option.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(option.impact)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(impactColor(option.impact))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(impactColor(option.impact).opacity(0.2))
                .cornerRadius(4)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }

    func impactColor(_ impact: String) -> Color {
        switch impact {
        case "High": return .red
        case "Medium": return .orange
        default: return .gray
        }
    }
}

// MARK: - Navigation Views

struct ProjectsView: View {
    let vm: AppViewModel
    @State private var xcodeProjects: [XcodeProject] = []
    @State private var isLoading = true
    @State private var maxDepth = 5
    @State private var showFilters = false
    @State private var scanProgress = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Xcode Projects (.xcodeproj)")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { showFilters.toggle() }) {
                    Label(showFilters ? "Hide" : "Filters", systemImage: "line.3.horizontal.decrease.circle")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                Text("\(xcodeProjects.count) found")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if showFilters {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Max Depth")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        HStack {
                            TextField("Depth", value: $maxDepth, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 60)
                            Stepper("", value: $maxDepth, in: 1...10)
                                .labelsHidden()
                        }
                    }
                    Button(action: { scanForXcodeProjects() }) {
                        Label("Rescan", systemImage: "arrow.clockwise")
                            .font(.caption)
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                .padding(12)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
            }

            if !scanProgress.isEmpty {
                Text(scanProgress)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
            }

            if isLoading {
                ProgressView("Scanning for Xcode projects...")
                    .padding()
            } else if xcodeProjects.isEmpty {
                Text("No Xcode projects found")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 12) {
                    ForEach(xcodeProjects) { project in
                        XcodeProjectCard(project: project)
                    }
                }
            }
        }
        .padding(16)
        .onAppear {
            scanForXcodeProjects()
        }
    }

    private func scanForXcodeProjects() {
        isLoading = true
        scanProgress = "Starting scan..."

        DispatchQueue.global().async {
            let fileManager = FileManager.default
            var projects: [XcodeProject] = []

            let searchPaths = [
                NSHomeDirectory() + "/Development",
                NSHomeDirectory() + "/Desktop",
                NSHomeDirectory() + "/Documents",
                NSHomeDirectory() + "/Projects",
                NSHomeDirectory() + "/workspace"
            ]

            // DevStrip feature: Exclude paths
            let excludePaths = [
                "node_modules",
                ".build",
                "target",
                "dist",
                "build",
                ".git",
                "Library",
                ".Trash",
                "Downloads"
            ]

            for basePath in searchPaths {
                guard fileManager.fileExists(atPath: basePath) else { continue }

                DispatchQueue.main.async {
                    self.scanProgress = "Scanning \((basePath as NSString).lastPathComponent)..."
                }

                self.scanDirectory(
                    at: basePath,
                    depth: 0,
                    maxDepth: maxDepth,
                    excludePaths: excludePaths,
                    fileManager: fileManager,
                    projects: &projects
                )
            }

            DispatchQueue.main.async {
                self.xcodeProjects = projects.sorted { $0.modifiedDate > $1.modifiedDate }
                self.isLoading = false
                self.scanProgress = "Found \(projects.count) projects"

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.scanProgress = ""
                }
            }
        }
    }

    // DevStrip-inspired recursive scan with depth and exclude controls
    private func scanDirectory(at path: String, depth: Int, maxDepth: Int, excludePaths: [String], fileManager: FileManager, projects: inout [XcodeProject]) {
        guard depth < maxDepth else { return }

        guard let contents = try? fileManager.contentsOfDirectory(atPath: path) else { return }

        for item in contents {
            // Skip excluded paths
            if excludePaths.contains(item) || item.hasPrefix(".") {
                continue
            }

            let itemPath = (path as NSString).appendingPathComponent(item)

            // Check if this is an .xcodeproj
            if item.hasSuffix(".xcodeproj") {
                let name = (item as NSString).deletingPathExtension
                let url = URL(fileURLWithPath: itemPath)

                if let attrs = try? fileManager.attributesOfItem(atPath: itemPath),
                   let modDate = attrs[.modificationDate] as? Date {
                    projects.append(XcodeProject(
                        name: name,
                        path: itemPath,
                        url: url,
                        modifiedDate: modDate
                    ))
                }
                continue
            }

            // Recurse into subdirectories
            var isDirectory: ObjCBool = false
            if fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory), isDirectory.boolValue {
                scanDirectory(
                    at: itemPath,
                    depth: depth + 1,
                    maxDepth: maxDepth,
                    excludePaths: excludePaths,
                    fileManager: fileManager,
                    projects: &projects
                )
            }
        }
    }
}

struct XcodeProject: Identifiable {
    let id = UUID()
    let name: String
    let path: String
    let url: URL
    let modifiedDate: Date
}

struct XcodeProjectCard: View {
    let project: XcodeProject
    @State private var showFiles = false
    @State private var projectFiles: [ProjectFile] = []
    @State private var isLoadingFiles = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "applelogo")
                    .font(.title2)
                    .foregroundColor(.red)
                Text(project.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(project.path)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .monospaced()

                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(project.modifiedDate.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if showFiles {
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Files")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Spacer()
                        Button(action: { showFiles = false }) {
                            Image(systemName: "xmark")
                                .font(.caption)
                        }
                    }

                    if isLoadingFiles {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else if projectFiles.isEmpty {
                        Text("No files found")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(projectFiles.prefix(10)) { file in
                                    HStack {
                                        Image(systemName: fileIcon(file.name))
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                        Text(file.name)
                                            .font(.caption2)
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                }
                                if projectFiles.count > 10 {
                                    Text("... and \(projectFiles.count - 10) more")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(maxHeight: 150)
                    }
                }
                .padding(8)
                .background(Color.white.opacity(0.05))
                .cornerRadius(6)
            }

            HStack(spacing: 8) {
                Button(action: {
                    showFiles = true
                    loadProjectFiles()
                }) {
                    Label("Files", systemImage: "folder")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.blue.opacity(0.2))
                        .cornerRadius(6)
                }

                Button(action: { NSWorkspace.shared.open(project.url) }) {
                    Label("Open", systemImage: "arrow.up.right")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.green.opacity(0.2))
                        .cornerRadius(6)
                }
                Spacer()
            }
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }

    private func loadProjectFiles() {
        isLoadingFiles = true
        DispatchQueue.global().async {
            let fileManager = FileManager.default
            var files: [ProjectFile] = []

            if let contents = try? fileManager.contentsOfDirectory(atPath: project.path) {
                for item in contents {
                    let fullPath = (project.path as NSString).appendingPathComponent(item)
                    var isDir: ObjCBool = false
                    if fileManager.fileExists(atPath: fullPath, isDirectory: &isDir) {
                        files.append(ProjectFile(
                            name: item,
                            isDirectory: isDir.boolValue
                        ))
                    }
                }
            }

            DispatchQueue.main.async {
                projectFiles = files.sorted { $0.name < $1.name }
                isLoadingFiles = false
            }
        }
    }

    private func fileIcon(_ name: String) -> String {
        if name.hasSuffix(".swift") { return "swift" }
        if name.hasSuffix(".xcconfig") { return "gear" }
        if name.hasSuffix(".json") { return "curlybraces" }
        if name.hasSuffix(".plist") { return "doc.plaintext" }
        return "doc"
    }
}

struct ProjectFile: Identifiable {
    let id = UUID()
    let name: String
    let isDirectory: Bool
}

// MARK: - Running Agent Model (Anthropic MCP-style)

struct RunningAgent: Identifiable {
    let id = UUID()
    let name: String
    let pid: Int32
    let command: String
    let cpuUsage: Double
    let memoryMB: Double
    let configPath: String?
    let logPaths: [String]
    let mainFile: String?
    var isRunning: Bool
}

struct AgentFile: Identifiable {
    let id = UUID()
    let name: String
    let path: String
    let type: AgentFileType
    let size: Int64?
    let isEditable: Bool
}

enum AgentFileType {
    case config      // JSON configs
    case log         // Log files
    case main        // Main entry point (index.ts, main.py, etc.)
    case skill       // Skill/tool definitions
    case cache       // Cache files
}

struct AgentsView: View {
    let vm: AppViewModel
    @State private var runningAgents: [RunningAgent] = []
    @State private var selectedAgent: RunningAgent?
    @State private var agentFiles: [AgentFile] = []
    @State private var selectedFile: AgentFile?
    @State private var fileContent: String = ""
    @State private var isScanning = true
    @State private var isEditingFile = false
    @State private var refreshTimer: Timer?

    var body: some View {
        HSplitView {
            // Left: Agent List with PIDs
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Running Agents")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: { scanRunningAgents() }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                }

                if isScanning {
                    ProgressView("Detecting running agents...")
                        .padding()
                } else if runningAgents.isEmpty {
                    Text("No AI agents detected")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(runningAgents) { agent in
                                AgentCard(
                                    agent: agent,
                                    isSelected: selectedAgent?.id == agent.id
                                )
                                .onTapGesture {
                                    selectedAgent = agent
                                    loadAgentFiles(for: agent)
                                }
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 300, maxWidth: 400)
            .padding(16)

            // Middle: MCP-style Filesystem View
            VStack(alignment: .leading, spacing: 12) {
                if let agent = selectedAgent {
                    HStack {
                        Text("\(agent.name) Files")
                            .font(.headline)
                        Spacer()
                        Text("PID: \(agent.pid)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            // Group files by type (MCP-style organization)
                            let grouped = Dictionary(grouping: agentFiles, by: { $0.type })

                            ForEach([AgentFileType.config, .main, .skill, .log, .cache], id: \.self) { type in
                                if let files = grouped[type], !files.isEmpty {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(fileTypeLabel(type))
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.secondary)
                                            .padding(.top, 8)

                                        ForEach(files) { file in
                                            FileRow(
                                                file: file,
                                                isSelected: selectedFile?.id == file.id
                                            )
                                            .onTapGesture {
                                                selectedFile = file
                                                loadFileContent(file)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("Select an agent to view files")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .frame(minWidth: 250, maxWidth: 350)
            .padding(16)

            // Right: File Content Editor
            VStack(alignment: .leading, spacing: 12) {
                if let file = selectedFile {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(file.name)
                                .font(.headline)
                            Text(file.path)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        Spacer()
                        if file.isEditable {
                            Toggle(isOn: $isEditingFile) {
                                Text("Edit")
                                    .font(.caption)
                            }
                            .toggleStyle(.switch)

                            if isEditingFile {
                                Button(action: { saveFileContent(file) }) {
                                    Label("Save", systemImage: "square.and.arrow.down")
                                        .font(.caption)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }

                    if isEditingFile && file.isEditable {
                        TextEditor(text: $fileContent)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .border(Color.gray.opacity(0.3))
                    } else {
                        ScrollView {
                            Text(fileContent)
                                .font(.system(.body, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("Select a file to view")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .padding(16)
        }
        .onAppear {
            scanRunningAgents()
            startAutoRefresh()
        }
        .onDisappear {
            refreshTimer?.invalidate()
        }
    }

    private func fileTypeLabel(_ type: AgentFileType) -> String {
        switch type {
        case .config: return "⚙️ Configuration"
        case .log: return "📋 Logs"
        case .main: return "📦 Main Entry"
        case .skill: return "🛠️ Skills/Tools"
        case .cache: return "💾 Cache"
        }
    }

    private func scanRunningAgents() {
        isScanning = true
        DispatchQueue.global().async {
            var agents: [RunningAgent] = []

            // Define agent patterns to detect
            let agentPatterns: [(name: String, processName: String, configBase: String)] = [
                ("Claude", "claude", "~/.claude"),
                ("Gemini", "gemini", "~/.gemini"),
                ("OpenCode", "opencode", "~/.opencode"),
                ("Aider", "aider", "~/.aider"),
                ("Plandex", "plandex", "~/.plandex"),
                ("n8n", "n8n", "~/.n8n"),
                ("MCP Chrome", "mcp-chrome", "~/.mcp"),
                ("Codex", "codex", "~/.codex")
            ]

            for pattern in agentPatterns {
                agents.append(contentsOf: detectAgent(
                    name: pattern.name,
                    processName: pattern.processName,
                    configBase: pattern.configBase
                ))
            }

            DispatchQueue.main.async {
                self.runningAgents = agents.sorted { $0.cpuUsage > $1.cpuUsage }
                self.isScanning = false
            }
        }
    }

    private func detectAgent(name: String, processName: String, configBase: String) -> [RunningAgent] {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/ps")
        task.arguments = ["aux"]

        let pipe = Pipe()
        task.standardOutput = pipe

        var agents: [RunningAgent] = []

        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                let lines = output.components(separatedBy: "\n")
                for line in lines {
                    if line.contains(processName) && !line.contains("grep") {
                        if let agent = parseProcessLine(line, name: name, configBase: configBase) {
                            agents.append(agent)
                        }
                    }
                }
            }
        } catch {
            print("Failed to detect \(name): \(error)")
        }

        return agents
    }

    private func parseProcessLine(_ line: String, name: String, configBase: String) -> RunningAgent? {
        let components = line.split(separator: " ", omittingEmptySubsequences: true)
        guard components.count >= 11 else { return nil }

        guard let pid = Int32(components[1]),
              let cpu = Double(components[2]),
              let mem = Double(components[3]) else {
            return nil
        }

        let command = components[10...].joined(separator: " ")

        // Expand config path
        let configPath = (configBase as NSString).expandingTildeInPath

        return RunningAgent(
            name: name,
            pid: pid,
            command: String(command),
            cpuUsage: cpu,
            memoryMB: mem,
            configPath: FileManager.default.fileExists(atPath: configPath) ? configPath : nil,
            logPaths: findLogs(for: name, configBase: configPath),
            mainFile: findMainFile(for: name, configBase: configPath),
            isRunning: true
        )
    }

    private func findLogs(for name: String, configBase: String) -> [String] {
        var logs: [String] = []
        let fileManager = FileManager.default

        let logPaths = [
            configBase + "/logs",
            NSHomeDirectory() + "/Library/Logs/\(name)",
            "/var/log/\(name.lowercased())"
        ]

        for path in logPaths {
            if let files = try? fileManager.contentsOfDirectory(atPath: path) {
                for file in files where file.hasSuffix(".log") {
                    logs.append((path as NSString).appendingPathComponent(file))
                }
            }
        }

        return logs
    }

    private func findMainFile(for name: String, configBase: String) -> String? {
        let fileManager = FileManager.default
        let candidates = [
            configBase + "/index.ts",
            configBase + "/index.js",
            configBase + "/main.py",
            configBase + "/src/index.ts",
            configBase + "/bin/\(name.lowercased())"
        ]

        for candidate in candidates {
            if fileManager.fileExists(atPath: candidate) {
                return candidate
            }
        }

        return nil
    }

    private func loadAgentFiles(for agent: RunningAgent) {
        DispatchQueue.global().async {
            var files: [AgentFile] = []
            let fileManager = FileManager.default

            // Load config files
            if let configPath = agent.configPath {
                if let configFiles = try? fileManager.contentsOfDirectory(atPath: configPath) {
                    for file in configFiles where file.hasSuffix(".json") {
                        let fullPath = (configPath as NSString).appendingPathComponent(file)
                        if let attrs = try? fileManager.attributesOfItem(atPath: fullPath),
                           let size = attrs[.size] as? Int64 {
                            files.append(AgentFile(
                                name: file,
                                path: fullPath,
                                type: .config,
                                size: size,
                                isEditable: true
                            ))
                        }
                    }
                }
            }

            // Load main file
            if let mainFile = agent.mainFile {
                if let attrs = try? fileManager.attributesOfItem(atPath: mainFile),
                   let size = attrs[.size] as? Int64 {
                    files.append(AgentFile(
                        name: (mainFile as NSString).lastPathComponent,
                        path: mainFile,
                        type: .main,
                        size: size,
                        isEditable: false
                    ))
                }
            }

            // Load logs
            for logPath in agent.logPaths {
                if let attrs = try? fileManager.attributesOfItem(atPath: logPath),
                   let size = attrs[.size] as? Int64 {
                    files.append(AgentFile(
                        name: (logPath as NSString).lastPathComponent,
                        path: logPath,
                        type: .log,
                        size: size,
                        isEditable: false
                    ))
                }
            }

            DispatchQueue.main.async {
                self.agentFiles = files
            }
        }
    }

    private func loadFileContent(_ file: AgentFile) {
        DispatchQueue.global().async {
            if let content = try? String(contentsOfFile: file.path, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.fileContent = content
                    self.isEditingFile = false
                }
            }
        }
    }

    private func saveFileContent(_ file: AgentFile) {
        guard file.isEditable else { return }

        do {
            try fileContent.write(toFile: file.path, atomically: true, encoding: .utf8)
            isEditingFile = false
        } catch {
            print("Failed to save file: \(error)")
        }
    }

    private func startAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            scanRunningAgents()
        }
    }
}

// MARK: - Agent Card Component

struct AgentCard: View {
    let agent: RunningAgent
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(agent.isRunning ? Color.green : Color.red)
                    .frame(width: 8, height: 8)

                Text(agent.name)
                    .font(.headline)
                    .fontWeight(isSelected ? .bold : .semibold)

                Spacer()

                Text("\(Int(agent.cpuUsage))% CPU")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 12) {
                Label("PID: \(agent.pid)", systemImage: "number")
                    .font(.caption2)

                Label("\(Int(agent.memoryMB)) MB", systemImage: "memorychip")
                    .font(.caption2)
            }
            .foregroundColor(.secondary)

            if agent.configPath != nil || !agent.logPaths.isEmpty {
                HStack(spacing: 8) {
                    if agent.configPath != nil {
                        Label("Config", systemImage: "gear")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(4)
                    }
                    if !agent.logPaths.isEmpty {
                        Label("\(agent.logPaths.count) logs", systemImage: "doc.text")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
        }
        .padding(12)
        .background(isSelected ? Color.blue.opacity(0.2) : Color.white.opacity(0.05))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - File Row Component

struct FileRow: View {
    let file: AgentFile
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: fileIcon)
                .foregroundColor(fileColor)
                .frame(width: 16)

            VStack(alignment: .leading, spacing: 2) {
                Text(file.name)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .lineLimit(1)

                if let size = file.size {
                    Text(formatSize(size))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if file.isEditable {
                Image(systemName: "pencil")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(4)
    }

    private var fileIcon: String {
        switch file.type {
        case .config: return "gearshape.fill"
        case .log: return "doc.text.fill"
        case .main: return "play.circle.fill"
        case .skill: return "wrench.and.screwdriver.fill"
        case .cache: return "externaldrive.fill"
        }
    }

    private var fileColor: Color {
        switch file.type {
        case .config: return .blue
        case .log: return .orange
        case .main: return .green
        case .skill: return .purple
        case .cache: return .gray
        }
    }

    private func formatSize(_ size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
}

struct PackagesView: View {
    let vm: AppViewModel
    var body: some View {
        Text("Packages List")
    }
}

struct ShellView: View {
    let vm: AppViewModel
    var body: some View {
        Text("Shell Commands")
    }
}

// MARK: - Settings View with Keychain API Key Storage

struct APIKey: Identifiable {
    let id = UUID()
    let name: String
    let service: String
    var isStored: Bool
    var lastUpdated: Date?
}

struct SettingsView: View {
    let vm: AppViewModel
    @State private var apiKeys: [APIKey] = []
    @State private var selectedKey: APIKey?
    @State private var showPasswordPrompt = false
    @State private var password = ""
    @State private var keyValue = ""
    @State private var statusMessage = ""
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("API Key Management")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(apiKeys.filter { $0.isStored }.count)/\(apiKeys.count) stored")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("Securely store API keys in macOS Keychain with password protection")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 20) {
                // Left: API Key List
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(apiKeys) { key in
                        APIKeyRow(
                            apiKey: key,
                            isSelected: selectedKey?.id == key.id
                        )
                        .onTapGesture {
                            selectedKey = key
                            loadKeyFromKeychain(key)
                        }
                    }
                }
                .frame(maxWidth: 300)

                Divider()

                // Right: Key Editor
                VStack(alignment: .leading, spacing: 16) {
                    if let key = selectedKey {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(key.name)
                                        .font(.headline)
                                    Text(key.service)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if key.isStored {
                                    Label("Stored", systemImage: "checkmark.shield.fill")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }

                            SecureField("Enter API Key", text: $keyValue)
                                .textFieldStyle(.roundedBorder)
                                .disabled(!isEditing)

                            if isEditing {
                                SecureField("Password (for keychain access)", text: $password)
                                    .textFieldStyle(.roundedBorder)

                                HStack(spacing: 12) {
                                    Button(action: { saveToKeychain(key) }) {
                                        Label("Save to Keychain", systemImage: "lock.fill")
                                            .font(.caption)
                                    }
                                    .buttonStyle(.borderedProminent)

                                    Button(action: { deleteFromKeychain(key) }) {
                                        Label("Delete", systemImage: "trash")
                                            .font(.caption)
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(.red)

                                    Button(action: {
                                        isEditing = false
                                        keyValue = ""
                                        password = ""
                                    }) {
                                        Text("Cancel")
                                            .font(.caption)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            } else {
                                Button(action: {
                                    isEditing = true
                                    keyValue = ""
                                }) {
                                    Label(key.isStored ? "Update Key" : "Add Key", systemImage: "pencil")
                                        .font(.caption)
                                }
                                .buttonStyle(.bordered)
                            }

                            if !statusMessage.isEmpty {
                                Text(statusMessage)
                                    .font(.caption)
                                    .foregroundColor(statusMessage.contains("✅") ? .green : .red)
                                    .padding(8)
                                    .background((statusMessage.contains("✅") ? Color.green : Color.red).opacity(0.1))
                                    .cornerRadius(6)
                            }

                            if let updated = key.lastUpdated {
                                Text("Last updated: \(updated.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        VStack {
                            Spacer()
                            Text("Select an API key to manage")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(16)
        .onAppear {
            loadAPIKeys()
        }
    }

    private func loadAPIKeys() {
        apiKeys = [
            APIKey(name: "Anthropic Claude", service: "com.hardened mac.anthropic", isStored: false),
            APIKey(name: "OpenAI", service: "com.hardenedmac.openai", isStored: false),
            APIKey(name: "Google Gemini", service: "com.hardenedmac.gemini", isStored: false),
            APIKey(name: "DeepSeek", service: "com.hardenedmac.deepseek", isStored: false),
            APIKey(name: "Groq", service: "com.hardenedmac.groq", isStored: false),
            APIKey(name: "Mistral", service: "com.hardenedmac.mistral", isStored: false),
            APIKey(name: "Perplexity", service: "com.hardenedmac.perplexity", isStored: false),
            APIKey(name: "Firecrawl", service: "com.hardenedmac.firecrawl", isStored: false),
            APIKey(name: "GitHub", service: "com.hardenedmac.github", isStored: false),
            APIKey(name: "Cloudflare", service: "com.hardenedmac.cloudflare", isStored: false)
        ]

        // Check which keys are stored
        for index in apiKeys.indices {
            if keychainHasKey(service: apiKeys[index].service) {
                apiKeys[index].isStored = true
            }
        }
    }

    private func keychainHasKey(service: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecReturnData as String: false
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    private func loadKeyFromKeychain(_ key: APIKey) {
        guard key.isStored else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key.service,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
            keyValue = value
            statusMessage = "✅ Key loaded from keychain"
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                statusMessage = ""
            }
        }
    }

    private func saveToKeychain(_ key: APIKey) {
        guard !keyValue.isEmpty && !password.isEmpty else {
            statusMessage = "❌ Please enter both API key and password"
            return
        }

        let data = keyValue.data(using: .utf8)!

        // Check if exists
        if key.isStored {
            // Update existing
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: key.service
            ]

            let attributes: [String: Any] = [
                kSecValueData as String: data
            ]

            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

            if status == errSecSuccess {
                updateKeyStatus(key, isStored: true)
                statusMessage = "✅ Key updated successfully"
                isEditing = false
                keyValue = ""
                password = ""
            } else {
                statusMessage = "❌ Failed to update key"
            }
        } else {
            // Add new
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: key.service,
                kSecAttrAccount as String: "api-key",
                kSecValueData as String: data
            ]

            let status = SecItemAdd(query as CFDictionary, nil)

            if status == errSecSuccess {
                updateKeyStatus(key, isStored: true)
                statusMessage = "✅ Key saved to keychain"
                isEditing = false
                keyValue = ""
                password = ""
            } else {
                statusMessage = "❌ Failed to save key"
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            statusMessage = ""
        }
    }

    private func deleteFromKeychain(_ key: APIKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key.service
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status == errSecSuccess || status == errSecItemNotFound {
            updateKeyStatus(key, isStored: false)
            statusMessage = "✅ Key deleted"
            isEditing = false
            keyValue = ""
            password = ""
        } else {
            statusMessage = "❌ Failed to delete key"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            statusMessage = ""
        }
    }

    private func updateKeyStatus(_ key: APIKey, isStored: Bool) {
        if let index = apiKeys.firstIndex(where: { $0.id == key.id }) {
            apiKeys[index].isStored = isStored
            apiKeys[index].lastUpdated = Date()
            selectedKey = apiKeys[index]
        }
    }
}

struct APIKeyRow: View {
    let apiKey: APIKey
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: apiKey.isStored ? "lock.shield.fill" : "lock.open")
                .foregroundColor(apiKey.isStored ? .green : .secondary)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(apiKey.name)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)

                Text(apiKey.service)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if apiKey.isStored {
                Circle()
                    .fill(Color.green)
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
        )
    }
}

struct LogFile: Identifiable {
    let id = UUID()
    let name: String
    let path: String
    let size: Int64
    let modifiedDate: Date
    let category: String
}

struct LogsView: View {
    let vm: AppViewModel
    @State private var logFiles: [LogFile] = []
    @State private var isScanning = true
    @State private var selectedLogs: Set<UUID> = []
    @State private var minAgeDays = 30
    @State private var dryRunMode = true
    @State private var showFilters = false
    @State private var deleteMessage = ""

    var filteredLogs: [LogFile] {
        logFiles.filter { log in
            let ageInDays = Calendar.current.dateComponents([.day], from: log.modifiedDate, to: Date()).day ?? 0
            return ageInDays >= minAgeDays
        }
    }

    var totalSelectedSize: Int64 {
        selectedLogs.compactMap { id in
            filteredLogs.first(where: { $0.id == id })
        }.reduce(0) { $0 + $1.size }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Log Files")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { showFilters.toggle() }) {
                    Label(showFilters ? "Hide" : "Filters", systemImage: "line.3.horizontal.decrease.circle")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                Text("\(filteredLogs.count) files")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if showFilters {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Min Age (days)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            HStack {
                                TextField("Days", value: $minAgeDays, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 60)
                                Stepper("", value: $minAgeDays, in: 0...365)
                                    .labelsHidden()
                            }
                        }

                        Toggle(isOn: $dryRunMode) {
                            HStack(spacing: 4) {
                                Image(systemName: "eye")
                                Text("Dry Run")
                                    .font(.caption)
                            }
                        }
                        .toggleStyle(.switch)

                        Spacer()
                    }

                    HStack {
                        Button(action: { selectAll() }) {
                            Label("Select All", systemImage: "checkmark.square")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)

                        if !selectedLogs.isEmpty {
                            Button(action: { deleteSelectedLogs() }) {
                                Label("Delete \(selectedLogs.count) logs (\(formatSize(totalSelectedSize)))", systemImage: "trash")
                                    .font(.caption)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }

                        Spacer()
                    }
                }
                .padding(12)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
            }

            if !deleteMessage.isEmpty {
                Text(deleteMessage)
                    .font(.caption)
                    .foregroundColor(dryRunMode ? .orange : .green)
                    .padding(8)
                    .background((dryRunMode ? Color.orange : Color.green).opacity(0.1))
                    .cornerRadius(6)
            }

            if isScanning {
                ProgressView("Scanning for logs...")
                    .padding()
            } else {
                let categories = Dictionary(grouping: filteredLogs, by: { $0.category })

                ForEach(categories.keys.sorted(), id: \.self) { category in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: categoryIcon(category))
                                .foregroundColor(categoryColor(category))
                            Text(category)
                                .font(.headline)
                                .foregroundColor(categoryColor(category))
                            Spacer()
                            Text("\(categories[category]?.count ?? 0)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        ForEach(categories[category] ?? []) { log in
                            HStack(spacing: 10) {
                                // DevStrip feature: Selection checkbox
                                Image(systemName: selectedLogs.contains(log.id) ? "checkmark.square.fill" : "square")
                                    .foregroundColor(selectedLogs.contains(log.id) ? .blue : .secondary)
                                    .frame(width: 20)
                                    .onTapGesture {
                                        toggleLogSelection(log)
                                    }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(log.name)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    HStack(spacing: 8) {
                                        Text(log.path)
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                            .monospaced()
                                        Spacer()
                                        // Show age
                                        let ageInDays = Calendar.current.dateComponents([.day], from: log.modifiedDate, to: Date()).day ?? 0
                                        Text("\(ageInDays)d old")
                                            .font(.caption2)
                                            .foregroundColor(.orange)
                                        Text(formatSize(log.size))
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                            }
                            .padding(8)
                            .background(selectedLogs.contains(log.id) ? Color.blue.opacity(0.1) : Color.white.opacity(0.05))
                            .cornerRadius(6)
                        }
                    }
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .onAppear {
            scanLogs()
        }
    }

    private func scanLogs() {
        isScanning = true
        DispatchQueue.global().async {
            var logs: [LogFile] = []
            let fileManager = FileManager.default
            let logPaths = [
                (NSHomeDirectory() + "/Library/Logs", "IDE Logs"),
                ("/var/log", "System Logs"),
                (NSHomeDirectory() + "/.local/share", "App Logs")
            ]

            for (path, category) in logPaths {
                if let enumerator = fileManager.enumerator(atPath: path) {
                    for case let file as String in enumerator {
                        if file.hasSuffix(".log") || file.hasSuffix(".txt") {
                            let fullPath = (path as NSString).appendingPathComponent(file)
                            if let attrs = try? fileManager.attributesOfItem(atPath: fullPath),
                               let size = attrs[.size] as? Int64,
                               let modDate = attrs[.modificationDate] as? Date {
                                logs.append(LogFile(
                                    name: (file as NSString).lastPathComponent,
                                    path: fullPath,
                                    size: size,
                                    modifiedDate: modDate,
                                    category: category
                                ))
                            }
                        }
                    }
                }
            }

            DispatchQueue.main.async {
                logFiles = logs.sorted { $0.modifiedDate > $1.modifiedDate }
                isScanning = false
            }
        }
    }

    private func categoryIcon(_ category: String) -> String {
        switch category {
        case "IDE Logs": return "xcode"
        case "System Logs": return "terminal"
        default: return "square.fill"
        }
    }

    private func categoryColor(_ category: String) -> Color {
        switch category {
        case "IDE Logs": return .blue
        case "System Logs": return .orange
        default: return .green
        }
    }

    private func formatSize(_ size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }

    // DevStrip features for LogsView
    private func toggleLogSelection(_ log: LogFile) {
        if selectedLogs.contains(log.id) {
            selectedLogs.remove(log.id)
        } else {
            selectedLogs.insert(log.id)
        }
    }

    private func selectAll() {
        if selectedLogs.count == filteredLogs.count {
            selectedLogs.removeAll()
        } else {
            selectedLogs = Set(filteredLogs.map { $0.id })
        }
    }

    private func deleteSelectedLogs() {
        if dryRunMode {
            deleteMessage = "🔍 DRY RUN: Would delete \(selectedLogs.count) logs (\(formatSize(totalSelectedSize)))"
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                deleteMessage = ""
            }
            return
        }

        DispatchQueue.global().async {
            let fileManager = FileManager.default
            var successCount = 0

            for logId in selectedLogs {
                if let log = filteredLogs.first(where: { $0.id == logId }) {
                    do {
                        try fileManager.removeItem(atPath: log.path)
                        successCount += 1
                    } catch {
                        print("Failed to delete \(log.path): \(error)")
                    }
                }
            }

            DispatchQueue.main.async {
                logFiles.removeAll { selectedLogs.contains($0.id) }
                selectedLogs.removeAll()
                deleteMessage = "✅ Deleted \(successCount) log files"

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    deleteMessage = ""
                }
            }
        }
    }
}

struct TelemetryFile: Identifiable {
    let id = UUID()
    let name: String
    let path: String
    let isDisabled: Bool
    let hasTracking: Bool
}

struct TelemetryView: View {
    let vm: AppViewModel
    @State private var telemetryFiles: [TelemetryFile] = []
    @State private var isScanning = true
    @State private var disabledCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Telemetry Status")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 6, height: 6)
                        Text("Disabled: \(disabledCount)")
                            .font(.caption)
                    }
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.red)
                            .frame(width: 6, height: 6)
                        Text("Active: \(telemetryFiles.count - disabledCount)")
                            .font(.caption)
                    }
                }
            }

            if isScanning {
                ProgressView("Scanning for telemetry...")
                    .padding()
            } else if telemetryFiles.isEmpty {
                Text("No telemetry files found")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(telemetryFiles) { file in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(file.name)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    Text(file.path)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                        .monospaced()
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    if file.isDisabled {
                                        Label("Disabled", systemImage: "checkmark.circle.fill")
                                            .font(.caption2)
                                            .foregroundColor(.green)
                                    } else {
                                        Label("Active", systemImage: "exclamationmark.circle.fill")
                                            .font(.caption2)
                                            .foregroundColor(.red)
                                    }

                                    if file.hasTracking {
                                        Text("Tracking Detected")
                                            .font(.caption2)
                                            .foregroundColor(.orange)
                                    }
                                }
                            }
                            .padding(10)
                            .background(file.isDisabled ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding(16)
        .onAppear {
            scanTelemetry()
        }
    }

    private func scanTelemetry() {
        isScanning = true
        DispatchQueue.global().async {
            var telemetry: [TelemetryFile] = []
            let fileManager = FileManager.default

            let configFiles = [
                NSHomeDirectory() + "/.vscode/settings.json",
                NSHomeDirectory() + "/.config/VSCodium/User/settings.json",
                NSHomeDirectory() + "/.config/Code/User/settings.json",
                NSHomeDirectory() + "/.zshrc",
                NSHomeDirectory() + "/.bashrc",
                NSHomeDirectory() + "/.config/node",
            ]

            for filePath in configFiles {
                let expandedPath = (filePath as NSString).expandingTildeInPath
                if fileManager.fileExists(atPath: expandedPath) {
                    do {
                        let content = try String(contentsOfFile: expandedPath, encoding: .utf8)
                        let isDisabled = content.contains("telemetry") && (
                            content.contains("\"telemetry.enabled\": false") ||
                            content.contains("telemetry.enableTelemetry\": false")
                        )
                        let hasTracking = content.lowercased().contains("track") ||
                                         content.lowercased().contains("telemetry") ||
                                         content.lowercased().contains("analytics")

                        telemetry.append(TelemetryFile(
                            name: (filePath as NSString).lastPathComponent,
                            path: expandedPath,
                            isDisabled: isDisabled,
                            hasTracking: hasTracking
                        ))
                    } catch {
                        // Skip files that can't be read
                    }
                }
            }

            DispatchQueue.main.async {
                telemetryFiles = telemetry.sorted { $0.isDisabled && !$1.isDisabled }
                disabledCount = telemetry.filter { $0.isDisabled }.count
                isScanning = false
            }
        }
    }
}

struct CleanableItem: Identifiable {
    let id = UUID()
    let name: String
    let path: String
    let size: Int64
    let category: String
    let modifiedDate: Date?
    var isSelected: Bool = false

    var ageInDays: Int? {
        guard let modifiedDate = modifiedDate else { return nil }
        return Calendar.current.dateComponents([.day], from: modifiedDate, to: Date()).day
    }
}

struct CleaningView: View {
    let vm: AppViewModel
    @State private var cleanableItems: [CleanableItem] = []
    @State private var isScanning = true
    @State private var selectedItems: Set<UUID> = []
    @State private var totalSelectedSize: Int64 = 0
    @State private var isDeleting = false
    @State private var deleteMessage = ""

    // DevStrip-inspired filters
    @State private var minAgeDays: Int = 2
    @State private var maxDepth: Int = 5
    @State private var dryRunMode: Bool = true
    @State private var keepLatestDerivedData: Bool = true
    @State private var scanProjectBuildFolders: Bool = true
    @State private var showFilters: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Disk Cleanup")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { showFilters.toggle() }) {
                    Label(showFilters ? "Hide Filters" : "Show Filters", systemImage: "line.3.horizontal.decrease.circle")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                Text("\(cleanableItems.count) items")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // DevStrip-style filters
            if showFilters {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Min Age (days)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            HStack {
                                TextField("Days", value: $minAgeDays, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 60)
                                Stepper("", value: $minAgeDays, in: 0...365)
                                    .labelsHidden()
                            }
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Max Depth")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            HStack {
                                TextField("Depth", value: $maxDepth, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 60)
                                Stepper("", value: $maxDepth, in: 1...20)
                                    .labelsHidden()
                            }
                        }
                    }

                    HStack(spacing: 16) {
                        Toggle(isOn: $dryRunMode) {
                            HStack(spacing: 4) {
                                Image(systemName: "eye")
                                Text("Dry Run (Preview Only)")
                                    .font(.caption)
                            }
                        }
                        .toggleStyle(.switch)

                        Toggle(isOn: $keepLatestDerivedData) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("Keep Latest DerivedData")
                                    .font(.caption)
                            }
                        }
                        .toggleStyle(.switch)
                    }

                    Toggle(isOn: $scanProjectBuildFolders) {
                        HStack(spacing: 4) {
                            Image(systemName: "folder.badge.gearshape")
                            Text("Scan Project Build Folders (node_modules, target, .build, dist)")
                                .font(.caption)
                        }
                    }
                    .toggleStyle(.switch)

                    Button(action: { scanCaches() }) {
                        Label("Rescan with Filters", systemImage: "arrow.clockwise")
                            .font(.caption)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(12)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
            }

            if isScanning {
                ProgressView("Scanning cache and derived data...")
                    .padding()
            } else if cleanableItems.isEmpty {
                Text("No cache files found")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.blue)
                            .frame(width: 6, height: 6)
                        Text("Available: \(formatSize(totalAvailableSize()))")
                            .font(.caption)
                    }
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.orange)
                            .frame(width: 6, height: 6)
                        Text("Selected: \(formatSize(totalSelectedSize))")
                            .font(.caption)
                    }
                    Spacer()
                    Button(action: { selectAll() }) {
                        Text("Select All")
                            .font(.caption2)
                    }
                    .buttonStyle(.bordered)
                }

                ScrollView {
                    VStack(spacing: 8) {
                        let categories = Dictionary(grouping: cleanableItems, by: { $0.category })

                        ForEach(categories.keys.sorted(), id: \.self) { category in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: categoryIcon(category))
                                        .foregroundColor(categoryColor(category))
                                    Text(category)
                                        .font(.headline)
                                        .foregroundColor(categoryColor(category))
                                    Spacer()
                                    let categoryItems = categories[category] ?? []
                                    let categorySize = categoryItems.reduce(0) { $0 + $1.size }
                                    Text(formatSize(categorySize))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                ForEach(categories[category] ?? []) { item in
                                    HStack(spacing: 10) {
                                        Image(systemName: selectedItems.contains(item.id) ? "checkmark.square.fill" : "square")
                                            .foregroundColor(selectedItems.contains(item.id) ? .blue : .secondary)
                                            .frame(width: 20)
                                            .onTapGesture {
                                                toggleSelection(for: item)
                                            }

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.name)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .lineLimit(1)
                                            Text(item.path)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                                .monospaced()
                                        }

                                        Spacer()

                                        Text(formatSize(item.size))
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                            .frame(width: 50, alignment: .trailing)
                                    }
                                    .padding(8)
                                    .background(selectedItems.contains(item.id) ? Color.blue.opacity(0.1) : Color.white.opacity(0.05))
                                    .cornerRadius(6)
                                }
                            }
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                        }
                    }
                }

                if !selectedItems.isEmpty {
                    Button(action: { deleteSelected() }) {
                        HStack {
                            Image(systemName: "trash.fill")
                            Text("Delete Selected (\(formatSize(totalSelectedSize)))")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(.red.opacity(0.2))
                        .foregroundColor(.red)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)

                    if !deleteMessage.isEmpty {
                        Text(deleteMessage)
                            .font(.caption)
                            .foregroundColor(.orange)
                            .padding(8)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding(16)
        .onAppear {
            scanCaches()
        }
    }

    private func scanCaches() {
        isScanning = true
        DispatchQueue.global().async {
            var items: [CleanableItem] = []
            let fileManager = FileManager.default

            // Comprehensive scan paths - outperforms CleanMyMac
            let paths: [(String, String)] = [
                // Xcode
                (NSHomeDirectory() + "/Library/Developer/Xcode/DerivedData", "Xcode Derived Data"),
                (NSHomeDirectory() + "/Library/Developer/Xcode/Archives", "Xcode Archives"),
                (NSHomeDirectory() + "/Library/Developer/Xcode/iOS DeviceSupport", "Xcode Device Support"),
                (NSHomeDirectory() + "/Library/Developer/CoreSimulator/Caches", "Simulator Caches"),
                (NSHomeDirectory() + "/Library/Developer/Xcode/Previews", "SwiftUI Previews"),
                (NSHomeDirectory() + "/Library/Developer/Xcode/Build", "Xcode Build Cache"),

                // System & Browser Caches
                (NSHomeDirectory() + "/Library/Caches", "System Caches"),
                (NSHomeDirectory() + "/Library/Safari/History.db-wal", "Safari History"),
                (NSHomeDirectory() + "/Library/Caches/Google/Chrome", "Chrome Cache"),
                (NSHomeDirectory() + "/Library/Caches/Firefox", "Firefox Cache"),
                (NSHomeDirectory() + "/Library/Caches/com.apple.Safari", "Safari Cache"),
                (NSHomeDirectory() + "/Library/Cookies", "Browser Cookies"),

                // Application Caches & Support
                (NSHomeDirectory() + "/.cache", "Application Caches"),
                (NSHomeDirectory() + "/Library/Application Support/CrashReporter", "Crash Reports"),
                (NSHomeDirectory() + "/Library/Logs", "System Logs"),
                (NSHomeDirectory() + "/var/log", "Var Logs"),
                (NSHomeDirectory() + "/.local/share", "Local Share"),

                // Development Tools
                (NSHomeDirectory() + "/.npm", "NPM Cache"),
                (NSHomeDirectory() + "/.gradle", "Gradle Cache"),
                (NSHomeDirectory() + "/.m2", "Maven Cache"),
                (NSHomeDirectory() + "/.cargo/registry", "Rust Cargo Cache"),
                (NSHomeDirectory() + "/.rbenv/versions", "Ruby Versions"),
                (NSHomeDirectory() + "/.cocoapods", "CocoaPods Cache"),
                (NSHomeDirectory() + "/.gem", "Gem Cache"),
                (NSHomeDirectory() + "/Library/Ruby/Gems", "Ruby Gems"),
                (NSHomeDirectory() + "/.python", "Python Cache"),
                (NSHomeDirectory() + "/.pip-cache", "Pip Cache"),
                (NSHomeDirectory() + "/.venv", "Python Virtual Env"),
                (NSHomeDirectory() + "/Library/Caches/pip", "Pip Cache Dir"),

                // Docker & Containers
                (NSHomeDirectory() + "/.docker/overlay2", "Docker Overlay Cache"),
                (NSHomeDirectory() + "/.docker/image", "Docker Images"),
                (NSHomeDirectory() + "/.docker/buildx", "Docker BuildX Cache"),
                (NSHomeDirectory() + "/.minikube/cache", "Minikube Cache"),
                (NSHomeDirectory() + "/.kube/cache", "Kubernetes Cache"),

                // IDE & Editor Caches
                (NSHomeDirectory() + "/.vscode/extensions", "VSCode Extensions"),
                (NSHomeDirectory() + "/.vscode/CachedExtensionVSIXs", "VSCode Extension Cache"),
                (NSHomeDirectory() + "/.config/Code/CachedExtensionVSIXs", "Code Extension Cache"),
                (NSHomeDirectory() + "/.idea/caches", "IntelliJ IDEA Caches"),
                (NSHomeDirectory() + "/.idea/system", "IntelliJ System"),
                (NSHomeDirectory() + "/.idea/indexing", "IntelliJ Indexing"),
                (NSHomeDirectory() + "/.eclipse", "Eclipse Cache"),
                (NSHomeDirectory() + "/.m2/repository", "Maven Repository"),

                // Temporary & Trash
                (NSHomeDirectory() + "/.Trash", "Trash Bin"),
                (NSHomeDirectory() + "/.TemporaryItems", "Temporary Items"),
                ("/var/tmp", "Var Temp"),
                ("/tmp", "System Temp"),

                // Package Managers & Installers
                (NSHomeDirectory() + "/Library/Preferences/com.apple.dt.Xcode.plist", "Xcode Preferences"),
                (NSHomeDirectory() + "/.homebrew-cache", "Homebrew Cache"),
                (NSHomeDirectory() + "/Library/Caches/Homebrew", "Homebrew Downloads"),
                (NSHomeDirectory() + "/.macports", "MacPorts Cache"),

                // Application-specific
                (NSHomeDirectory() + "/Library/Application Support/Google/Chrome/Default/Cache", "Chrome Default Cache"),
                (NSHomeDirectory() + "/Library/Application Support/Google/Chrome/Default/Code Cache", "Chrome Code Cache"),
                (NSHomeDirectory() + "/Library/Application Support/Firefox/Profiles", "Firefox Profiles"),
                (NSHomeDirectory() + "/.aws/cli/cache", "AWS CLI Cache"),
                (NSHomeDirectory() + "/.kube", "Kubectl Config"),

                // Recently used / Duplicates detection
                (NSHomeDirectory() + "/.local/share/recently-used.xbel", "Recently Used Files"),
                (NSHomeDirectory() + "/Library/Recent Servers", "Recent Servers"),
                (NSHomeDirectory() + "/Library/Recent Documents.localized", "Recent Documents"),
                (NSHomeDirectory() + "/Downloads", "Downloads Folder"),
            ]

            for (path, category) in paths {
                let expandedPath = (path as NSString).expandingTildeInPath
                if fileManager.fileExists(atPath: expandedPath) {
                    if expandedPath.hasSuffix(".plist") || expandedPath.hasSuffix(".db-wal") {
                        // Single file items
                        if let attrs = try? fileManager.attributesOfItem(atPath: expandedPath),
                           let size = attrs[.size] as? Int64,
                           size > 0 {
                            let modifiedDate = attrs[.modificationDate] as? Date

                            // Apply age filter
                            if let modDate = modifiedDate {
                                let ageInDays = Calendar.current.dateComponents([.day], from: modDate, to: Date()).day ?? 0
                                guard ageInDays >= minAgeDays else { continue }
                            }

                            items.append(CleanableItem(
                                name: (expandedPath as NSString).lastPathComponent,
                                path: expandedPath,
                                size: size,
                                category: category,
                                modifiedDate: modifiedDate
                            ))
                        }
                    } else {
                        // Directory scanning
                        scanDirectory(expandedPath, category: category, fileManager: fileManager, into: &items)
                    }
                }
            }

            // DevStrip feature: Scan project-local build folders
            if scanProjectBuildFolders {
                let projectRoots = [
                    NSHomeDirectory() + "/Projects",
                    NSHomeDirectory() + "/workspace",
                    NSHomeDirectory() + "/Work",
                    NSHomeDirectory() + "/Developer",
                    NSHomeDirectory() + "/Development",
                    NSHomeDirectory() + "/Desktop"
                ]

                let buildFolderNames = [
                    "node_modules",      // Node.js
                    "target",            // Rust, Java
                    ".build",            // Swift
                    "dist",              // General builds
                    "build",             // General builds
                    "coverage",          // Test coverage
                    ".next",             // Next.js
                    ".nuxt",             // Nuxt.js
                    "out",               // Various frameworks
                    ".gradle",           // Gradle
                    ".pytest_cache",     // Python pytest
                    "__pycache__",       // Python
                    ".tox",              // Python tox
                    ".venv",             // Python virtualenv
                    "venv",              // Python virtualenv
                    ".cargo/target"      // Rust cargo
                ]

                for root in projectRoots {
                    guard fileManager.fileExists(atPath: root) else { continue }

                    scanProjectBuildFolders(in: root, buildFolders: buildFolderNames, fileManager: fileManager, into: &items, currentDepth: 0)
                }
            }

            // DevStrip feature: Keep latest DerivedData
            if keepLatestDerivedData {
                let derivedDataItems = items.filter { $0.category == "Xcode Derived Data" }
                if !derivedDataItems.isEmpty {
                    // Sort by modification date, keep the newest one
                    let sortedByDate = derivedDataItems.sorted { ($0.modifiedDate ?? Date.distantPast) > ($1.modifiedDate ?? Date.distantPast) }
                    if let newest = sortedByDate.first {
                        items.removeAll { $0.id == newest.id }
                    }
                }
            }

            DispatchQueue.main.async {
                cleanableItems = items.sorted { $0.size > $1.size }
                isScanning = false
            }
        }
    }

    private func scanDirectory(_ path: String, category: String, fileManager: FileManager, into items: inout [CleanableItem], depth: Int = 0) {
        // Apply max depth limit (DevStrip feature)
        guard depth < maxDepth else { return }

        if let enumerator = fileManager.enumerator(atPath: path) {
            for case let file as String in enumerator {
                let fullPath = (path as NSString).appendingPathComponent(file)
                if let attrs = try? fileManager.attributesOfItem(atPath: fullPath),
                   let size = attrs[.size] as? Int64,
                   size > 0 {

                    let modifiedDate = attrs[.modificationDate] as? Date

                    // Apply age filter (DevStrip feature)
                    if let modDate = modifiedDate {
                        let ageInDays = Calendar.current.dateComponents([.day], from: modDate, to: Date()).day ?? 0
                        guard ageInDays >= minAgeDays else { continue }
                    }

                    items.append(CleanableItem(
                        name: (file as NSString).lastPathComponent,
                        path: fullPath,
                        size: size,
                        category: category,
                        modifiedDate: modifiedDate
                    ))
                }
            }
        }
    }

    // DevStrip feature: Recursively scan for project build folders
    private func scanProjectBuildFolders(in root: String, buildFolders: [String], fileManager: FileManager, into items: inout [CleanableItem], currentDepth: Int) {
        guard currentDepth < maxDepth else { return }

        guard let contents = try? fileManager.contentsOfDirectory(atPath: root) else { return }

        for item in contents {
            let itemPath = (root as NSString).appendingPathComponent(item)

            var isDirectory: ObjCBool = false
            guard fileManager.fileExists(atPath: itemPath, isDirectory: &isDirectory), isDirectory.boolValue else { continue }

            // Skip hidden folders except build-specific ones
            if item.hasPrefix(".") && !buildFolders.contains(item) {
                continue
            }

            // Check if this is a build folder
            if buildFolders.contains(item) {
                if let attrs = try? fileManager.attributesOfItem(atPath: itemPath) {
                    let modifiedDate = attrs[.modificationDate] as? Date

                    // Apply age filter
                    if let modDate = modifiedDate {
                        let ageInDays = Calendar.current.dateComponents([.day], from: modDate, to: Date()).day ?? 0
                        guard ageInDays >= minAgeDays else { continue }
                    }

                    // Calculate directory size
                    let size = calculateDirectorySize(at: itemPath, fileManager: fileManager)

                    items.append(CleanableItem(
                        name: item,
                        path: itemPath,
                        size: size,
                        category: "Project Build Artifacts",
                        modifiedDate: modifiedDate
                    ))
                }
            } else {
                // Recurse into subdirectories
                scanProjectBuildFolders(in: itemPath, buildFolders: buildFolders, fileManager: fileManager, into: &items, currentDepth: currentDepth + 1)
            }
        }
    }

    private func calculateDirectorySize(at path: String, fileManager: FileManager) -> Int64 {
        var totalSize: Int64 = 0

        if let enumerator = fileManager.enumerator(atPath: path) {
            for case let file as String in enumerator {
                let fullPath = (path as NSString).appendingPathComponent(file)
                if let attrs = try? fileManager.attributesOfItem(atPath: fullPath),
                   let size = attrs[.size] as? Int64 {
                    totalSize += size
                }
            }
        }

        return totalSize
    }

    private func toggleSelection(for item: CleanableItem) {
        if selectedItems.contains(item.id) {
            selectedItems.remove(item.id)
            totalSelectedSize -= item.size
        } else {
            selectedItems.insert(item.id)
            totalSelectedSize += item.size
        }
    }

    private func selectAll() {
        if selectedItems.count == cleanableItems.count {
            selectedItems.removeAll()
            totalSelectedSize = 0
        } else {
            selectedItems = Set(cleanableItems.map { $0.id })
            totalSelectedSize = cleanableItems.reduce(0) { $0 + $1.size }
        }
    }

    private func deleteSelected() {
        // DevStrip feature: Dry-run mode
        if dryRunMode {
            deleteMessage = "🔍 DRY RUN: Would delete \(selectedItems.count) items (\(formatSize(totalSelectedSize)))"
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                deleteMessage = ""
            }
            return
        }

        isDeleting = true
        deleteMessage = "Deleting \(selectedItems.count) items..."

        DispatchQueue.global().async {
            let fileManager = FileManager.default
            var successCount = 0
            var failureCount = 0
            var processedSize: Int64 = 0

            for (index, itemId) in selectedItems.enumerated() {
                if let item = cleanableItems.first(where: { $0.id == itemId }) {
                    do {
                        try fileManager.removeItem(atPath: item.path)
                        successCount += 1
                        processedSize += item.size

                        // DevStrip feature: Progress reporting
                        DispatchQueue.main.async {
                            let progress = Double(index + 1) / Double(selectedItems.count)
                            deleteMessage = "Deleting: \(Int(progress * 100))% (\(successCount)/\(selectedItems.count))"
                        }
                    } catch {
                        failureCount += 1
                    }
                }
            }

            DispatchQueue.main.async {
                cleanableItems.removeAll { selectedItems.contains($0.id) }
                selectedItems.removeAll()
                totalSelectedSize = 0
                isDeleting = false

                if failureCount == 0 {
                    deleteMessage = "✅ Deleted \(successCount) items (\(formatSize(processedSize))) successfully"
                } else {
                    deleteMessage = "⚠️ Deleted \(successCount) items, \(failureCount) failed"
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    deleteMessage = ""
                }
            }
        }
    }

    private func categoryIcon(_ category: String) -> String {
        switch category {
        // Xcode
        case "Xcode Derived Data", "Xcode Archives", "Xcode Device Support", "Xcode Build Cache", "SwiftUI Previews": return "xcode"

        // Browser & Internet
        case "Safari History", "Safari Cache", "Chrome Cache", "Firefox Cache", "Browser Cookies", "Chrome Default Cache", "Chrome Code Cache", "Firefox Profiles": return "globe"

        // Development Tools
        case "NPM Cache", "Pip Cache", "Pip Cache Dir": return "cube"
        case "Gradle Cache", "Maven Cache", "Maven Repository": return "hammer"
        case "Rust Cargo Cache": return "gear"
        case "Ruby Versions", "Ruby Gems", "Gem Cache": return "diamond"
        case "Python Cache", "Python Virtual Env": return "snake"
        case "CocoaPods Cache": return "square.fill"

        // Containers
        case "Docker Overlay Cache", "Docker Images", "Docker BuildX Cache": return "docker"
        case "Minikube Cache", "Kubernetes Cache", "Kubectl Config": return "cube"

        // IDEs
        case "VSCode Extensions", "VSCode Extension Cache", "Code Extension Cache": return "square.text.square"
        case "IntelliJ IDEA Caches", "IntelliJ System", "IntelliJ Indexing", "Eclipse Cache": return "hammer.circle"

        // System
        case "System Caches", "System Library Caches", "System Logs", "Var Logs": return "internaldrive"
        case "Simulator Caches": return "iphone"
        case "Crash Reports": return "exclamationmark.triangle"

        // Application
        case "Application Caches", "Local Share": return "app"

        // Temporary & Trash
        case "Trash Bin", "Temporary Items", "Var Temp", "System Temp": return "trash"
        case "Downloads Folder": return "arrow.down.circle"

        // Package Managers
        case "Homebrew Cache", "Homebrew Downloads", "MacPorts Cache": return "leaf"

        // Cloud & Network
        case "AWS CLI Cache": return "cloud"
        case "Recent Servers": return "network"

        // Recent Files
        case "Recently Used Files", "Recent Documents": return "clock"

        // DevStrip feature: Project Build Artifacts
        case "Project Build Artifacts": return "folder.badge.gearshape"

        default: return "trash.fill"
        }
    }

    private func categoryColor(_ category: String) -> Color {
        switch category {
        // Xcode - Blue
        case "Xcode Derived Data", "Xcode Archives", "Xcode Device Support", "Xcode Build Cache", "SwiftUI Previews": return .blue

        // Browser - Cyan
        case "Safari History", "Safari Cache", "Chrome Cache", "Firefox Cache", "Browser Cookies", "Chrome Default Cache", "Chrome Code Cache", "Firefox Profiles": return .cyan

        // Development - Purple
        case "NPM Cache", "Gradle Cache", "Maven Cache", "Maven Repository", "Pip Cache", "Pip Cache Dir": return .purple
        case "Rust Cargo Cache": return .indigo
        case "Ruby Versions", "Ruby Gems", "Gem Cache": return .pink
        case "Python Cache", "Python Virtual Env": return .green
        case "CocoaPods Cache": return .red

        // Containers - Orange
        case "Docker Overlay Cache", "Docker Images", "Docker BuildX Cache": return .orange
        case "Minikube Cache", "Kubernetes Cache", "Kubectl Config": return .yellow

        // IDEs - Purple variants
        case "VSCode Extensions", "VSCode Extension Cache", "Code Extension Cache": return .indigo
        case "IntelliJ IDEA Caches", "IntelliJ System", "IntelliJ Indexing", "Eclipse Cache": return .purple

        // System - Gray
        case "System Caches", "System Library Caches", "System Logs", "Var Logs": return .gray
        case "Simulator Caches": return .green
        case "Crash Reports": return .red

        // Application - Teal
        case "Application Caches", "Local Share": return .teal

        // Temporary - Red
        case "Trash Bin", "Temporary Items", "Var Temp", "System Temp": return .red
        case "Downloads Folder": return .orange

        // Package Managers - Green
        case "Homebrew Cache", "Homebrew Downloads", "MacPorts Cache": return .green

        // Cloud & Network
        case "AWS CLI Cache": return .yellow
        case "Recent Servers": return .blue

        // Recent Files - Secondary
        case "Recently Used Files", "Recent Documents": return .secondary

        // DevStrip feature: Project Build Artifacts - Orange
        case "Project Build Artifacts": return .orange

        default: return .primary
        }
    }

    private func formatSize(_ size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }

    private func totalAvailableSize() -> Int64 {
        cleanableItems.reduce(0) { $0 + $1.size }
    }
}

// MARK: - Components

struct FloatingPanelButton: View {
    let label: String
    let icon: String
    let color: Color
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isPressed = false
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                Text(label)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(color.opacity(isPressed ? 0.2 : 0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

struct TabButton: View {
    let label: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(isActive ? .blue : .secondary)

                if isActive {
                    Capsule()
                        .fill(Color.blue)
                        .frame(height: 2)
                }
            }
        }
    }
}
// MARK: - Landing Page (Help Center)

struct LandingPageView: View {
    @Environment(AppViewModel.self) private var vm
    @State private var searchText = ""
    @State private var selectedCategory = "Productivity"

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    // Header Section with Search
                    VStack(spacing: 20) {
                        VStack(spacing: 8) {
                            Text("Need help? Find answers here.")
                                .font(.system(size: 32, weight: .semibold))
                                .tracking(-0.5)

                            Text("Explore guides, tips, and user documentation")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.secondary)
                        }

                        // Search Bar - Authentic macOS style
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)

                            TextField("Search guides and documentation", text: $searchText)
                                .textFieldStyle(.plain)

                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                                .buttonStyle(.plain)
                                .help("Clear search")
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color(nsColor: .controlBackgroundColor))
                        .cornerRadius(8)
                        .frame(maxWidth: 600)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(40)
                    .background(.ultraThinMaterial)

                    // Content
                    VStack(spacing: 50) {
                        // Hero Section
                        HStack(alignment: .top, spacing: 30) {
                            // macOS Card
                            VStack(spacing: 16) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 44))
                                    .foregroundColor(.blue)

                                Text("macOS User Guide")
                                    .font(.system(size: 18, weight: .semibold))

                                Text("Comprehensive guide for your Mac")
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)

                                Spacer()
                            }
                            .frame(maxHeight: .infinity)
                            .padding(24)
                            .background(Color(nsColor: .controlBackgroundColor))
                            .cornerRadius(12)

                            // Features
                            VStack(alignment: .leading, spacing: 14) {
                                LandingFeatureItem(
                                    icon: "magnifyingglass",
                                    title: "Spotlight Search",
                                    description: "Find files and launch apps instantly"
                                )

                                LandingFeatureItem(
                                    icon: "sparkles",
                                    title: "Customization",
                                    description: "Personalize your Mac experience"
                                )

                                LandingFeatureItem(
                                    icon: "list.bullet",
                                    title: "Organization",
                                    description: "Manage tasks and information"
                                )
                            }

                            Spacer()
                        }
                        .frame(height: 260)

                        // Projects Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Projects")
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                                Text("\(vm.projects.count) found")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.secondary)
                            }

                            HStack(spacing: 16) {
                                LandingDashboardCard(
                                    icon: "square.grid.2x2",
                                    title: "Xcode Projects",
                                    count: "\(vm.projects.count)",
                                    subtitle: "Local projects",
                                    color: .blue
                                )

                                LandingDashboardCard(
                                    icon: "folder",
                                    title: "Directories",
                                    count: "3",
                                    subtitle: "Source locations",
                                    color: .orange
                                )
                            }
                        }

                        // Agents Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Agents & Tools")
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                                Text("\(vm.agents.count) active")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.secondary)
                            }

                            HStack(spacing: 16) {
                                LandingDashboardCard(
                                    icon: "square.grid.3x3",
                                    title: "AI Agents",
                                    count: "\(vm.agents.count)",
                                    subtitle: "Development tools",
                                    color: .purple
                                )

                                LandingDashboardCard(
                                    icon: "cube.transparent",
                                    title: "Packages",
                                    count: "\(vm.packages.count)",
                                    subtitle: ".pnpm packages",
                                    color: .red
                                )
                            }
                        }

                        // System Management Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("System & Security")
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                            }

                            HStack(spacing: 16) {
                                LandingDashboardCard(
                                    icon: "trash.fill",
                                    title: "Disk Cleanup",
                                    count: "55+",
                                    subtitle: "Cache locations",
                                    color: .red
                                )

                                LandingDashboardCard(
                                    icon: "lock.fill",
                                    title: "Security",
                                    count: "60",
                                    subtitle: "Hardening options",
                                    color: .blue
                                )
                            }

                            HStack(spacing: 16) {
                                LandingDashboardCard(
                                    icon: "radar",
                                    title: "Telemetry",
                                    count: "6",
                                    subtitle: "Config files scanned",
                                    color: .green
                                )

                                LandingDashboardCard(
                                    icon: "logs.dashboard.vertical",
                                    title: "Logs",
                                    count: "3",
                                    subtitle: "Categories",
                                    color: .cyan
                                )
                            }
                        }
                    }
                    .padding(40)
                }
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

struct LandingFeatureItem: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.blue)
                .frame(width: 28, height: 28, alignment: .center)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)

                Text(description)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

struct LandingDashboardCard: View {
    let icon: String
    let title: String
    let count: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(count)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(color)

                    Text("total")
                        .font(.system(size: 9, weight: .regular))
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .frame(minHeight: 100)
        .padding(14)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(10)
    }
}

// MARK: - Main App

@main
struct FCloudUIApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(minWidth: 1400, minHeight: 900)
        }
        #if os(macOS)
        .windowStyle(.automatic)
        .windowResizability(.contentMinSize)
        #endif
    }
}
