import SwiftUI

/// Premium art-studio palette inspired by Najdi murals, terracotta clay, gold leaf and contemporary Saudi identity.
enum Palette {
    // Primary — deep bourbon / clay (mural walls)
    static let bourbon = Color(hex: 0x7A4332)
    static let terracotta = Color(hex: 0xC46A4A)
    // Accent — gold leaf
    static let gold = Color(hex: 0xD4A24E)
    // Supporting
    static let olive = Color(hex: 0x6B7142)
    static let sage = Color(hex: 0x9CA88E)
    static let cocoa = Color(hex: 0x4A3B31)
    static let indigo = Color(hex: 0x3B4A6B)

    // Surfaces — adaptive to light/dark
    static var sand: Color { Color.uiColor(light: 0xF5EFE6, dark: 0x1A1410) }   // warm light bg → near-black warm
    static var ink: Color { Color.uiColor(light: 0x2A2018, dark: 0xF5EFE6) }      // near-black text → warm light

    static func placeholder(named name: String) -> Color {
        switch name {
        case "Bourbon": return bourbon
        case "Terracotta": return terracotta
        case "Olive": return olive
        case "Sage": return sage
        case "Cocoa": return cocoa
        case "Indigo": return indigo
        default: return bourbon
        }
    }
}

extension Color {
    /// Initializes a color from a hex integer (0xRRGGBB). Adapts to light/dark automatically via dynamic provider.
    init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
    }

    /// Dynamic color that adapts between light and dark modes (0xRRGGBB values).
    static func uiColor(light: UInt32, dark: UInt32) -> Color {
        Color(UIColor { traits in
            let resolved = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((resolved >> 16) & 0xFF) / 255.0,
                green: CGFloat((resolved >> 8) & 0xFF) / 255.0,
                blue: CGFloat(resolved & 0xFF) / 255.0,
                alpha: 1.0
            )
        })
    }
}

enum AppTheme {
    // Gradients
    static let heroGradient = LinearGradient(
        colors: [Palette.bourbon, Palette.cocoa],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let goldGradient = LinearGradient(
        colors: [Palette.gold, Palette.terracotta],
        startPoint: .leading,
        endPoint: .trailing
    )

    static let cardBackground = LinearGradient(
        colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
        startPoint: .top,
        endPoint: .bottom
    )

    // Typography
    static let displayFont = Font.system(.largeTitle, design: .serif).weight(.bold)
    static let titleFont = Font.system(.title2, design: .serif).weight(.semibold)
    static let headingFont = Font.system(.headline, design: .serif).weight(.semibold)
    static let bodyFont = Font.system(.body)
    static let captionFont = Font.system(.caption)
    static let monoCaption = Font.system(.caption2, design: .monospaced)

    // Spacing
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 18
    static let cardCornerRadius: CGFloat = 22
}

// MARK: - Reusable View Modifiers

struct PremiumCard: ViewModifier {
    var padding: CGFloat = AppTheme.padding
    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                    .fill(AppTheme.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                    .strokeBorder(Palette.gold.opacity(0.18), lineWidth: 1)
            )
            .shadow(color: Palette.cocoa.opacity(0.10), radius: 10, x: 0, y: 6)
    }
}

extension View {
    func premiumCard(padding: CGFloat = AppTheme.padding) -> some View {
        modifier(PremiumCard(padding: padding))
    }
}

// MARK: - Source Citation Chip

struct SourceChip: View {
    let source: SourceRef?
    let lang: AppLanguage

    var body: some View {
        if let source {
            Button {
                LinkOpener.open(source.url)
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "link.circle.fill")
                        .font(.system(size: 11))
                    Text(source.label(for: lang))
                        .font(AppTheme.captionFont.weight(.medium))
                        .lineLimit(1)
                }
                .foregroundStyle(Palette.gold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule().fill(Palette.gold.opacity(0.12))
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text("Source: \(source.label(for: lang))"))
        }
    }
}

// MARK: - Verified Badge

struct VerifiedBadge: View {
    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 10))
            Text("verified")
                .font(.system(size: 10, weight: .semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Capsule().fill(Palette.olive))
    }
}
