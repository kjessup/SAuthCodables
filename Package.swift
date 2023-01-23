// swift-tools-version:5.1
// Generated automatically by Perfect Assistant 2
// Date: 2018-03-02 17:48:07 +0000
import PackageDescription

let package = Package(
	name: "SAuthCodables",
	platforms: [
		.macOS(.v10_15)
	],
	products: [
		.library(name: "SAuthCodables", targets: ["SAuthCodables"])
	],
	dependencies: [
		//.package(url: "https://github.com/PerfectlySoft/Perfect-NIO.git", .branch("master")),
		
		.package(url: "https://github.com/PerfectlySoft/Perfect-MIME.git", from: "1.0.0"),
	],
	targets: [
		.target(name: "SAuthCodables", dependencies: ["PerfectMIME",/*"PerfectNIO"*/])
	]
)
