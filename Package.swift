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
                "ggml/src/ggml.c",
                "ggml/src/ggml-alloc.c",
                "ggml/src/ggml-backend.cpp",
                "ggml/src/ggml-quants.c",
                "ggml/src/ggml-threading.cpp",
                "src/whisper.cpp"
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("include"),
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .headerSearchPath("src"),
                .define("GGML_USE_ACCELERATE"),
                .define("WHISPER_USE_COREML"),
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3"])
            ],
            cxxSettings: [
                .headerSearchPath("."),
                .headerSearchPath("include"),
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .headerSearchPath("src"),
                .define("GGML_USE_ACCELERATE"),
                .define("WHISPER_USE_COREML"),
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3"])
            ],
            linkerSettings: [
                .linkedFramework("Accelerate"),
                .linkedFramework("CoreML"),
                .linkedFramework("Metal")
            ]
        ),
        .target(
            name: "SwiftWhisper",
            dependencies: ["whisper_cpp"],
            path: "Sources/SwiftWhisper"
        ),
        .testTarget(
            name: "WhisperTests",
            dependencies: ["SwiftWhisper"]
        ),
    ],
    cxxLanguageStandard: .cxx11
)

