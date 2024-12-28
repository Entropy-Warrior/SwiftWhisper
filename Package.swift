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
            path: "Sources/whisper_cpp",
            exclude: [
                "ggml/src/ggml-cuda",
                "ggml/src/ggml-vulkan",
                "ggml/src/ggml-opencl",
                "ggml/src/ggml-kompute",
                "ggml/src/ggml-sycl",
                "ggml/src/ggml-blas",
                "ggml/src/ggml-metal/ggml-metal.metal"
            ],
            sources: [
                ".",
                "ggml/src"
            ],
            resources: [
                .copy("ggml/src/ggml-metal/ggml-metal.metal")
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .headerSearchPath("ggml/src/ggml-cpu"),
                .headerSearchPath("ggml/src/ggml-metal"),
                .define("GGML_USE_ACCELERATE"),
                .define("WHISPER_USE_COREML"),
                .define("GGML_USE_METAL"),
                .define("GGML_METAL_NDEBUG"),
                .define("GGML_USE_METAL_UNIFIED_MEMORY"),
                .define("GGML_USE_K_QUANTS"),
                .define("GGML_USE_METAL_MPS"),
                .define("GGML_USE_AMX"),
                .define("GGML_USE_SYSCTL"),
                .unsafeFlags([
                    "-Wno-shorten-64-to-32",
                    "-Wno-unused-variable",
                    "-Wno-unused-function",
                    "-O3",
                    "-fno-objc-arc",
                    "-march=native"
                ])
            ],
            cxxSettings: [
                .headerSearchPath("."),
                .headerSearchPath("ggml/include"),
                .headerSearchPath("ggml/src"),
                .headerSearchPath("ggml/src/ggml-cpu"),
                .headerSearchPath("ggml/src/ggml-metal"),
                .define("GGML_USE_ACCELERATE"),
                .define("WHISPER_USE_COREML"),
                .define("GGML_USE_METAL"),
                .define("GGML_METAL_NDEBUG"),
                .define("GGML_USE_METAL_UNIFIED_MEMORY"),
                .define("GGML_USE_K_QUANTS"),
                .define("GGML_USE_METAL_MPS"),
                .define("GGML_USE_AMX"),
                .define("GGML_USE_SYSCTL"),
                .unsafeFlags([
                    "-Wno-shorten-64-to-32",
                    "-Wno-unused-variable",
                    "-Wno-unused-function",
                    "-O3",
                    "-march=native"
                ])
            ],
            linkerSettings: [
                .linkedFramework("Accelerate"),
                .linkedFramework("CoreML"),
                .linkedFramework("Metal"),
                .linkedFramework("MetalKit"),
                .linkedFramework("MetalPerformanceShaders"),
                .unsafeFlags(["-fno-objc-arc"])
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

