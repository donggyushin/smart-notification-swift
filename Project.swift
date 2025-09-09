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
            dependencies: [
                .target(name: "Service"),
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseMessaging")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "YV58Q28W8Z"
                ]
            )
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
        .target(
            name: "Service",
            destinations: .iOS,
            product: .framework,
            bundleId: "dev.tuist.Service",
            infoPlist: .default,
            buildableFolders: [
                "Service/Sources"
            ],
            dependencies: [.target(name: "Domain")]
        ),
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "dev.tuist.Domain",
            infoPlist: .default,
            buildableFolders: [
                "Domain/Sources"
            ],
            dependencies: [.target(name: "ThirdPartyLibrary")]
        ),
        .target(
            name: "ThirdPartyLibrary",
            destinations: .iOS,
            product: .framework,
            bundleId: "dev.tuist.ThirdPartyLibrary",
            infoPlist: .default,
            buildableFolders: [
                "ThirdPartyLibrary/Sources"
            ],
            dependencies: [
                
            ]
        ),
    ]
)
