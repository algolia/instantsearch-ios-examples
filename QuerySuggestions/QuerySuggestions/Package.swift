// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuerySuggestions",
    platforms: [
      .iOS(.v13)
    ],
    products: [
        .library(
            name: "QuerySuggestions",
            targets: ["QuerySuggestions"]),
    ],
    dependencies: [
      .package(url: "https://github.com/algolia/instantsearch-ios", from: "7.0.0"),
      .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.8.0")
    ],
    targets: [
        .target(
            name: "QuerySuggestions",
            dependencies: ["InstantSearch", "SDWebImage"]),
        .testTarget(
            name: "QuerySuggestionsTests",
            dependencies: ["QuerySuggestions", "InstantSearch", "SDWebImage"]),
    ]
)
