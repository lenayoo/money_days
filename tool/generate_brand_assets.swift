#!/usr/bin/swift

import AppKit
import Foundation

struct AppIconContents: Decodable {
    struct ImageEntry: Decodable {
        let size: String?
        let filename: String?
        let scale: String?
    }

    let images: [ImageEntry]
}

let fileManager = FileManager.default
let rootURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
let sourceIconURL = rootURL.appendingPathComponent("assets/imgs/appIcon.png")
let assetsDirectoryURL = rootURL.appendingPathComponent("assets/imgs")
let iosAppIconContentsURL = rootURL.appendingPathComponent("ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json")

struct LogoSpec {
    let fileName: String
    let size: CGFloat
}

let logoSpecs = [
    LogoSpec(fileName: "logo_1024.png", size: 1024),
    LogoSpec(fileName: "logo_500.png", size: 500),
]

let androidIcons: [(path: String, size: Int)] = [
    ("android/app/src/main/res/mipmap-mdpi/ic_launcher.png", 48),
    ("android/app/src/main/res/mipmap-hdpi/ic_launcher.png", 72),
    ("android/app/src/main/res/mipmap-xhdpi/ic_launcher.png", 96),
    ("android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png", 144),
    ("android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png", 192),
]

enum BrandAssetError: Error, CustomStringConvertible {
    case missingSourceIcon(String)
    case failedToLoadImage(String)
    case invalidIconContents(String)
    case failedToEncodePNG(String)

    var description: String {
        switch self {
        case let .missingSourceIcon(path):
            return "Source icon not found at \(path)"
        case let .failedToLoadImage(path):
            return "Failed to load image at \(path)"
        case let .invalidIconContents(path):
            return "Failed to parse iOS app icon contents at \(path)"
        case let .failedToEncodePNG(path):
            return "Failed to encode PNG at \(path)"
        }
    }
}

func makeColor(hex: UInt32, alpha: CGFloat = 1.0) -> NSColor {
    let red = CGFloat((hex >> 16) & 0xff) / 255
    let green = CGFloat((hex >> 8) & 0xff) / 255
    let blue = CGFloat(hex & 0xff) / 255
    return NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
}

func pngData(from bitmap: NSBitmapImageRep) throws -> Data {
    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw BrandAssetError.failedToEncodePNG("bitmap")
    }
    return data
}

func writePNG(
    size: CGSize,
    destinationURL: URL,
    drawBlock: () -> Void
) throws {
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(size.width),
        pixelsHigh: Int(size.height),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        throw BrandAssetError.failedToEncodePNG(destinationURL.path)
    }

    bitmap.size = size

    guard let context = NSGraphicsContext(bitmapImageRep: bitmap) else {
        throw BrandAssetError.failedToEncodePNG(destinationURL.path)
    }

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context

    context.imageInterpolation = .high
    context.shouldAntialias = true

    NSColor.clear.setFill()
    NSBezierPath(rect: CGRect(origin: .zero, size: size)).fill()

    drawBlock()

    NSGraphicsContext.restoreGraphicsState()

    let data = try pngData(from: bitmap)
    try data.write(to: destinationURL)
}

func resize(image: NSImage, to targetSize: CGFloat, destinationURL: URL) throws {
    try writePNG(
        size: CGSize(width: targetSize, height: targetSize),
        destinationURL: destinationURL
    ) {
        image.draw(
            in: CGRect(x: 0, y: 0, width: targetSize, height: targetSize),
            from: CGRect(origin: .zero, size: image.size),
            operation: .copy,
            fraction: 1
        )
    }
}

func makeParagraphStyle() -> NSMutableParagraphStyle {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    style.lineBreakMode = .byWordWrapping
    return style
}

func drawText(_ text: String, attributes: [NSAttributedString.Key: Any], rect: CGRect) {
    let attributed = NSAttributedString(string: text, attributes: attributes)
    let textRect = attributed.boundingRect(
        with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
        options: [.usesLineFragmentOrigin, .usesFontLeading]
    )

    let drawRect = CGRect(
        x: rect.minX,
        y: rect.minY + (rect.height - ceil(textRect.height)) / 2,
        width: rect.width,
        height: ceil(textRect.height)
    )

    attributed.draw(with: drawRect, options: [.usesLineFragmentOrigin, .usesFontLeading])
}

func generateLogo(from icon: NSImage, spec: LogoSpec) throws {
    let size = spec.size
    let backgroundColor = makeColor(hex: 0xFCF9F5)
    let titleColor = makeColor(hex: 0xD96E48)
    let subtitleColor = makeColor(hex: 0x8F857E)

    let iconWidth = size * 0.54
    let iconHeight = iconWidth
    let topPadding = size * 0.105
    let titleTop = size * 0.69
    let titleHeight = size * 0.11
    let subtitleTop = size * 0.81
    let subtitleHeight = size * 0.055
    let horizontalPadding = size * 0.11

    let iconY = size - topPadding - iconHeight
    let titleY = size - titleTop - titleHeight
    let subtitleY = size - subtitleTop - subtitleHeight

    let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: size * 0.078, weight: .semibold),
        .foregroundColor: titleColor,
        .paragraphStyle: makeParagraphStyle(),
    ]

    let subtitleAttributes: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: size * 0.032, weight: .regular),
        .foregroundColor: subtitleColor,
        .paragraphStyle: makeParagraphStyle(),
    ]

    let destinationURL = assetsDirectoryURL.appendingPathComponent(spec.fileName)

    try writePNG(
        size: CGSize(width: size, height: size),
        destinationURL: destinationURL
    ) {
        backgroundColor.setFill()
        NSBezierPath(rect: CGRect(x: 0, y: 0, width: size, height: size)).fill()

        icon.draw(
            in: CGRect(
                x: (size - iconWidth) / 2,
                y: iconY,
                width: iconWidth,
                height: iconHeight
            ),
            from: CGRect(origin: .zero, size: icon.size),
            operation: .sourceOver,
            fraction: 1
        )

        drawText(
            "Money Days",
            attributes: titleAttributes,
            rect: CGRect(
                x: horizontalPadding,
                y: titleY,
                width: size - (horizontalPadding * 2),
                height: titleHeight
            )
        )

        drawText(
            "Daily Budget Tracker",
            attributes: subtitleAttributes,
            rect: CGRect(
                x: horizontalPadding,
                y: subtitleY,
                width: size - (horizontalPadding * 2),
                height: subtitleHeight
            )
        )
    }
}

func pixelSize(from entry: AppIconContents.ImageEntry) -> Int? {
    guard
        let size = entry.size,
        let scale = entry.scale,
        let base = Double(size.split(separator: "x").first ?? ""),
        let multiplier = Double(scale.replacingOccurrences(of: "x", with: ""))
    else {
        return nil
    }

    return Int((base * multiplier).rounded())
}

do {
    guard fileManager.fileExists(atPath: sourceIconURL.path) else {
        throw BrandAssetError.missingSourceIcon(sourceIconURL.path)
    }

    guard let icon = NSImage(contentsOf: sourceIconURL) else {
        throw BrandAssetError.failedToLoadImage(sourceIconURL.path)
    }

    for spec in logoSpecs {
        try generateLogo(from: icon, spec: spec)
    }

    for androidIcon in androidIcons {
        let destinationURL = rootURL.appendingPathComponent(androidIcon.path)
        try resize(image: icon, to: CGFloat(androidIcon.size), destinationURL: destinationURL)
    }

    let contentsData = try Data(contentsOf: iosAppIconContentsURL)
    let decoder = JSONDecoder()
    let contents: AppIconContents

    do {
        contents = try decoder.decode(AppIconContents.self, from: contentsData)
    } catch {
        throw BrandAssetError.invalidIconContents(iosAppIconContentsURL.path)
    }

    let iosDirectoryURL = iosAppIconContentsURL.deletingLastPathComponent()

    for entry in contents.images {
        guard let filename = entry.filename, let size = pixelSize(from: entry) else {
            continue
        }

        let destinationURL = iosDirectoryURL.appendingPathComponent(filename)
        try resize(image: icon, to: CGFloat(size), destinationURL: destinationURL)
    }

    print("Generated logos and launcher icons from assets/imgs/appIcon.png")
} catch {
    fputs("\(error)\n", stderr)
    exit(1)
}
