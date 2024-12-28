// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SwiftWhisper",
    platforms: [
        .macOS(.v12),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftWhisper",
            targets: ["SwiftWhisper"]
        ),
    ],
    targets: [
        .target(
            name: "whisper_cpp",
            path: "whisper.cpp",
            exclude: ["bindings", "examples", "models", "samples", "tests"],
            sources: [
                "src/whisper.cpp",
                "ggml/src/ggml.c",
                "ggml/src/ggml-alloc.c",
                "ggml/src/ggml-backend.cpp",
                "ggml/src/ggml-quants.c",
                "ggml/src/ggml-threading.cpp"
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("src"),
                .headerSearchPath("include"),
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .define("GGML_USE_ACCELERATE", .when(platforms: [.macOS, .iOS])),
                .define("WHISPER_USE_COREML", .when(platforms: [.macOS, .iOS])),
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3"])
            ],
            cxxSettings: [
                .headerSearchPath("."),
                .headerSearchPath("src"),
                .headerSearchPath("include"),
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .define("GGML_USE_ACCELERATE", .when(platforms: [.macOS, .iOS])),
                .define("WHISPER_USE_COREML", .when(platforms: [.macOS, .iOS])),
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3"])
            ],
            linkerSettings: [
                .linkedFramework("Accelerate"),
                .linkedFramework("CoreML", .when(platforms: [.macOS, .iOS])),
                .linkedFramework("Metal", .when(platforms: [.macOS, .iOS]))
            ]
        ),
        .target(
            name: "SwiftWhisper",
            dependencies: ["whisper_cpp"]
        ),
        .testTarget(
            name: "WhisperTests",
            dependencies: ["SwiftWhisper"]
        ),
    ],
    cxxLanguageStandard: .cxx11
)

