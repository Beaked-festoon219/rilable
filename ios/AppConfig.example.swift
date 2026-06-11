import Foundation

/// TEMPLATE — copy this file to `ios/Sources/AppConfig.swift` (which is
/// gitignored) and fill in your own values before building the app.
enum AppConfig {
    /// Your Convex deployment URL (CONVEX_URL in backend/.env.local after
    /// running `npx convex dev --once`). Looks like
    /// "https://your-deployment-123.convex.cloud".
    static let convexDeploymentURL = "https://YOUR-DEPLOYMENT.convex.cloud"

    /// Shown in the home-screen greeting: "Got an idea, <name>?"
    static let userName = "Builder"
}
