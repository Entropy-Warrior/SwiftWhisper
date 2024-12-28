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
            name: "whisper_metal",
            path: "Sources/whisper_cpp/ggml/src/ggml-metal",
            exclude: ["CMakeLists.txt"],
            sources: ["ggml-metal.m"],
            resources: [
                .process("ggml-metal.metal")
            ],
            cSettings: [
                .headerSearchPath("../.."),
                .headerSearchPath("../../include"),
                .define("GGML_USE_METAL"),
                .define("GGML_METAL_NDEBUG"),
                .unsafeFlags(["-fno-objc-arc"])
            ],
            linkerSettings: [
                .linkedFramework("Metal"),
                .linkedFramework("MetalKit"),
                .linkedFramework("MetalPerformanceShaders")
            ]
        ),
        .target(
            name: "whisper_cpp",
            dependencies: ["whisper_metal"],
            path: "Sources/whisper_cpp",
            exclude: [
                "ggml/src/ggml-cuda",
                "ggml/src/ggml-vulkan",
                "ggml/src/ggml-opencl",
                "ggml/src/ggml-kompute",
                "ggml/src/ggml-sycl",
                "ggml/src/ggml-blas",
                "ggml/src/ggml-cann",
                "ggml/src/ggml-hip",
                "ggml/src/ggml-musa",
                "ggml/src/ggml-rpc",
                "ggml/CMakeLists.txt",
                "ggml/src/CMakeLists.txt",
                "ggml/src/ggml-metal/CMakeLists.txt",
                "ggml/src/ggml-cpu/CMakeLists.txt",
                "ggml/src/ggml-cpu/cmake",
                "ggml/src/ggml-metal/ggml-metal.metal",
                "ggml/src/ggml-metal/ggml-metal.m",
                "ggml/src/ggml-backend.cpp",
                "ggml/src/ggml-backend-reg.cpp",
                "ggml/src/ggml-cpu/ggml-cpu.cpp",
                "ggml/src/ggml-cpu/ggml-cpu-traits.cpp",
                "ggml/src/ggml-cpu/ggml-cpu-aarch64.cpp",
                "include/ggml-cpp.h"
            ],
            sources: [
                "ggml.c",
                "whisper.cpp",
                "ggml/src/ggml-alloc.c",
                "ggml/src/ggml-quants.c",
                "ggml/src/ggml-threading.cpp",
                "ggml/src/ggml-opt.cpp",
                "ggml/src/ggml-cpu/ggml-cpu.c",
                "ggml/src/ggml-cpu/ggml-cpu-quants.c"
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
                .unsafeFlags(["-O3", "-fno-objc-arc"])
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
            name: "whisper_cpp_backend",
            path: "Sources/whisper_cpp_backend",
            sources: [
                "ggml-backend.cpp",
                "ggml-backend-reg.cpp",
                "ggml-cpu.cpp",
                "ggml-cpu-traits.cpp",
                "ggml-cpu-aarch64.cpp"
            ],
            publicHeadersPath: "include",
            cxxSettings: [
                .headerSearchPath("../whisper_cpp"),
                .headerSearchPath("../whisper_cpp/ggml/include"),
                .headerSearchPath("../whisper_cpp/ggml/src"),
                .headerSearchPath("../whisper_cpp/ggml/src/ggml-cpu"),
                .headerSearchPath("../whisper_cpp/ggml/src/ggml-metal"),
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
                    "-O3",
                    "-std=c++17",
                    "-stdlib=libc++"
                ])
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
            dependencies: ["whisper_cpp", "whisper_cpp_backend"],
            path: "Sources/SwiftWhisper"
        ),
        .testTarget(
            name: "WhisperTests",
            dependencies: ["SwiftWhisper"]
        ),
    ],
    cxxLanguageStandard: .cxx17
)

