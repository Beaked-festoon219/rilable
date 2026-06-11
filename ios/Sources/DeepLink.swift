import Combine
import Foundation

enum ProjectTab: String {
    case agent
    case preview
    case code
}

/// Routes forge:// deep links and in-app navigation requests:
///   forge://home                          -> pop to the home screen
///   forge://project/<id>                  -> open a project chat
///   forge://project/<id>?tab=preview      -> open chat + full-screen preview
///   forge://project/<id>?tab=code         -> open chat + details sheet
@MainActor
final class DeepLinkRouter: ObservableObject {
    static let shared = DeepLinkRouter()
    @Published var requestedTab: ProjectTab?
    @Published var pendingProjectId: String?
    @Published var pendingHome = false

    private init() {}

    func openProject(_ id: String, tab: ProjectTab? = nil) {
        requestedTab = tab
        pendingProjectId = id
    }

    func goHome() {
        pendingHome = true
    }

    func consumeTab() -> ProjectTab? {
        let tab = requestedTab
        if tab != nil {
            DispatchQueue.main.async { [weak self] in
                if self?.requestedTab == tab { self?.requestedTab = nil }
            }
        }
        return tab
    }

    func clearPendingProject() {
        DispatchQueue.main.async { [weak self] in
            self?.pendingProjectId = nil
        }
    }

    func clearPendingHome() {
        DispatchQueue.main.async { [weak self] in
            self?.pendingHome = false
        }
    }

    static func tab(from raw: String) -> ProjectTab? {
        ProjectTab(rawValue: raw.lowercased())
    }
}
