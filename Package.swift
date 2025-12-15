// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
// MODIFIED: Changed mlx-swift-examples to mlx-swift-lm to fix swift-transformers version conflict

import PackageDescription

let package = Package(
    name: "MLXStructured",
    platforms: [.macOS(.v15), .iOS(.v18)],
    products: [
        .library(name: "MLXStructured", targets: ["MLXStructured"]),
    ],
    dependencies: [
        // Use mlx-swift-lm instead of mlx-swift-examples to avoid swift-transformers conflict
        .package(url: "https://github.com/ml-explore/mlx-swift-lm", revision: "74f85d9505032ec3403c94ba159472244fe78767"),
        .package(url: "https://github.com/kevinhermawan/swift-json-schema", from: "2.0.1"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.4.0"),
    ],
    targets: [
        // C package
        .target(
            name: "CMLXStructured",
            exclude: [
                "xgrammar/web",
                "xgrammar/tests",
                "xgrammar/3rdparty/cpptrace",
                "xgrammar/3rdparty/googletest",
                "xgrammar/3rdparty/dlpack/contrib",
                "xgrammar/3rdparty/picojson",
                "xgrammar/cpp/nanobind",
            ],
            cSettings: [
                .headerSearchPath("xgrammar/include"),
                .headerSearchPath("xgrammar/3rdparty/dlpack/include"),
                .headerSearchPath("xgrammar/3rdparty/picojson"),
            ],
            cxxSettings: [
                .headerSearchPath("xgrammar/include"),
                .headerSearchPath("xgrammar/3rdparty/dlpack/include"),
                .headerSearchPath("xgrammar/3rdparty/picojson"),
            ]
        ),
        // Main package
        .target(
            name: "MLXStructured",
            dependencies: [
                .target(name: "CMLXStructured"),
                .product(name: "MLXLMCommon", package: "mlx-swift-lm"),
                .product(name: "JSONSchema", package: "swift-json-schema")
            ]
        ),
        // CLI for testing
        .executableTarget(
            name: "MLXStructuredCLI",
            dependencies: [
                .target(name: "MLXStructured"),
                .product(name: "MLXLLM", package: "mlx-swift-lm"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
        ),
        // Unit tests
        .testTarget(
            name: "MLXStructuredTests",
            dependencies: [
                .target(name: "MLXStructured"),
                .product(name: "MLXLLM", package: "mlx-swift-lm"),
            ],
        ),
    ],
    cxxLanguageStandard: .gnucxx17
)
