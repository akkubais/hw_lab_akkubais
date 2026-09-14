// swift-tools-version: 5.9
import PackageDescription

// Runs the same model and view-model tests on macOS without an iOS Simulator.
// The iOS app and its SwiftUI views are built with RailsCards.xcodeproj.
let package = Package(
    name: "RailsCardsLogic",
    platforms: [.macOS(.v14)],
    products: [.library(name: "RailsCards", targets: ["RailsCards"])],
    targets: [
        .target(
            name: "RailsCards",
            path: "RailsCards",
            exclude: ["RailsCardsApp.swift", "Views"],
            sources: ["Models", "ViewModels"]
        ),
        .testTarget(
            name: "RailsCardsTests",
            dependencies: ["RailsCards"],
            path: "RailsCardsTests"
        )
    ]
)
