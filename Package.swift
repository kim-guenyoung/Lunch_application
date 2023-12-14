// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "NavigationController",
    platforms: [
        .iOS(.v14),
    ],
    dependencies: [
        .package(url: "https://github.com/pvieito/PythonKit.git", from: "0.0.0"),
        // Add other dependencies if needed
    ],
    targets: [
        .target(
            name: "restaurant_ViewController",
            dependencies: ["PythonKit"]),
        // Add other targets if needed
    ]
)
