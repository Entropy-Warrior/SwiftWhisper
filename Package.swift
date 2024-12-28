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
                "ggml/src/ggml-metal/ggml-metal.m",
                "ggml/src/ggml-metal/ggml-metal.metal",
                "ggml/src/ggml-cpu/ggml-cpu.c",
                "ggml/src/ggml-cpu/ggml-cpu-quants.c",
                "ggml/src/ggml-cpu/ggml-cpu.cpp",
                "ggml/src/ggml-cpu/ggml-cpu-traits.cpp",
                "ggml/src/ggml-cpu/ggml-cpu-aarch64.cpp"
            ],
            resources: [
                .copy("ggml/src/ggml-metal/ggml-metal.metal")
            ],
            publicHeadersPath: "spm-headers",
            cSettings: [
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .headerSearchPath("ggml/src/ggml-cpu"),
                .headerSearchPath("ggml/src/ggml-cpu/amx"),
                .headerSearchPath("ggml/src/ggml-metal"),
                .headerSearchPath("include"),
                .headerSearchPath("src"),
                .define("GGML_USE_ACCELERATE"),
                .define("WHISPER_USE_COREML"),
                .define("GGML_USE_METAL"),
                .define("GGML_METAL_NDEBUG"),
                .define("GGML_USE_METAL_UNIFIED_MEMORY"),
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3", "-fno-objc-arc"])
            ],
            cxxSettings: [
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .headerSearchPath("ggml/src/ggml-cpu"),
                .headerSearchPath("ggml/src/ggml-cpu/amx"),
                .headerSearchPath("ggml/src/ggml-metal"),
                .headerSearchPath("include"),
                .headerSearchPath("src"),
                .define("GGML_USE_ACCELERATE"),
                .define("WHISPER_USE_COREML"),
                .define("GGML_USE_METAL"),
                .define("GGML_METAL_NDEBUG"),
                .define("GGML_USE_METAL_UNIFIED_MEMORY"),
                .unsafeFlags(["-Wno-shorten-64-to-32", "-O3"])
            ],
            linkerSettings: [
                .linkedFramework("Accelerate"),
                .linkedFramework("CoreML"),
                .linkedFramework("Metal"),
                .linkedFramework("MetalKit"),
                .linkedFramework("MetalPerformanceShaders")
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

