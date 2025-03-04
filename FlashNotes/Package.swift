// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "FlashNotes",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "FlashNotes", targets: ["FlashNotes"])
    ],
    dependencies: [
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.0.0")
    ],
    targets: [
        .executableTarget(
            name: "FlashNotes",
            dependencies: [
                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ]
        ),
        .testTarget(
            name: "FlashNotesTests",
            dependencies: ["FlashNotes"]
        )
    ]
)
