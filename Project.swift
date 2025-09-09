import ProjectDescription

let project = Project(
    name: "smart-notification-swift",
    targets: [
        .target(
            name: "smart-notification-swift",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.smart-notification-swift",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "smart-notification-swift/Sources",
                "smart-notification-swift/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "smart-notification-swiftTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.smart-notification-swiftTests",
            infoPlist: .default,
            buildableFolders: [
                "smart-notification-swift/Tests"
            ],
            dependencies: [.target(name: "smart-notification-swift")]
        ),
    ]
)
