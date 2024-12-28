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
                "ggml/src/ggml-backend-reg.cpp",
                "ggml/src/ggml-quants.c",
                "ggml/src/ggml-threading.cpp",
                "ggml/src/ggml-opt.cpp",
                "ggml/src/ggml-cpu/ggml-cpu.c",
                "ggml/src/ggml-cpu/ggml-cpu-quants.c",
                "ggml/src/ggml-cpu/ggml-cpu.cpp",
                "ggml/src/ggml-cpu/ggml-cpu-traits.cpp",
                "ggml/src/ggml-cpu/ggml-cpu-aarch64.cpp"
            ],
            publicHeadersPath: "spm-headers",
            cSettings: [
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .headerSearchPath("include"),
                .headerSearchPath("src"),
                .define("GGML_USE_ACCELERATE"),
                .define("WHISPER_USE_COREML"),
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3"])
            ],
            cxxSettings: [
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .headerSearchPath("include"),
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

