// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    // Alamofire como framework dinámico: así sus recursos (PrivacyInfo) van dentro
    // del framework y Tuist no genera el target "Alamofire_Alamofire" (bundle),
    // que heredaba el iOS 12.0 del Package.swift de Alamofire.
    productTypes: [
        "Alamofire": .framework,
    ],

    baseSettings: .settings(
        base: [
            "IPHONEOS_DEPLOYMENT_TARGET": "15.0"
        ]
    ),

    // targetSettings se aplica a nivel target y sobrescribe el deployment target
    // que Tuist toma de los `platforms` de cada paquete (Alamofire iOS 12, Moya iOS 10).
    targetSettings: [
        "Alamofire": .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "15.0"]),
        "Moya": .settings(base: ["IPHONEOS_DEPLOYMENT_TARGET": "15.0"]),
    ]
)
#endif

let package = Package(
    name: "ApplaudoChallenge",
    dependencies: [
        .package(
            url: "https://github.com/Moya/Moya",
            from: "15.0.0"
        ),
    ]
)
