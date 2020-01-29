// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SearchSuggestions",
    platforms: [
      .iOS(.v13)
    ],
    products: [
        .library(
            name: "SearchSuggestions",
            targets: ["SearchSuggestions"]),
    ],
    dependencies: [
      .package(url: "https://github.com/algolia/instantsearch-ios", .branch("develop")),
      .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.5.2")
    ],
    targets: [
        .target(
            name: "SearchSuggestions",
            dependencies: ["InstantSearch", "SDWebImage"]),
        .testTarget(
            name: "SearchSuggestionsTests",
            dependencies: ["SearchSuggestions", "InstantSearch", "SDWebImage"]),
    ]
)
