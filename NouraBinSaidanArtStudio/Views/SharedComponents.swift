import SwiftUI

// MARK: - Section Header

struct SectionHeader<Trailing: View>: View {
    let title: String
    var subtitle: String? = nil
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.headingFont)
                    .foregroundStyle(Palette.ink)
                if let subtitle {
                    Text(subtitle)
                        .font(AppTheme.captionFont)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            trailing()
        }
    }
}

extension SectionHeader where Trailing == EmptyView {
    init(_ title: String, subtitle: String? = nil) {
        self.init(title: title, subtitle: subtitle) { EmptyView() }
    }
}

// MARK: - Art Image (loads from Asset Catalog, falls back to generative placeholder)

/// Displays a bundled artwork image when available; otherwise renders a generative Najdi placeholder.
/// This lets the team drop real licensed photos into Assets.xcassets later without code changes.
struct ArtImage: View {
    let assetName: String
    var fallbackColor: Color = Palette.bourbon
    var title: String? = nil
    var contentMode: ContentMode = .fill

    var body: some View {
        Group {
            if let uiImage = UIImage(named: assetName), !assetName.isEmpty {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                MuralPlaceholder(baseColor: fallbackColor, title: title)
            }
        }
        .clipped()
    }
}

// MARK: - Artwork Placeholder (original generative art, no copyright)

/// A generative, on-device placeholder evoking Najdi mural motifs (flower + arches). 100% original code art.
struct MuralPlaceholder: View {
    let baseColor: Color
    var title: String? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [baseColor, baseColor.opacity(0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Najdi-flower inspired generative motif
            Canvas { context, size in
                let cx = size.width / 2
                let cy = size.height / 2
                let r = min(size.width, size.height) * 0.22
                var path = Path()
                let petals = 8
                for i in 0..<petals {
                    let angle = (Double(i) / Double(petals)) * 2 * .pi
                    let x = cx + cos(angle) * r
                    let y = cy + sin(angle) * r
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
                path.closeSubpath()
                context.stroke(path, with: .color(.white.opacity(0.35)), lineWidth: 2)
                context.fill(
                    Circle().path(in: CGRect(x: cx - r*0.4, y: cy - r*0.4, width: r*0.8, height: r*0.8)),
                    with: .color(.white.opacity(0.18))
                )
            }
            .opacity(0.7)

            // Arch silhouette
            ArcShape()
                .stroke(.white.opacity(0.25), lineWidth: 3)
                .padding(28)

            if let title {
                VStack {
                    Spacer()
                    Text(title)
                        .font(AppTheme.captionFont.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(8)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(10)
                }
            }
        }
        .clipped()
    }
}

private struct ArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let inset: CGFloat = 0
        let w = rect.width - inset*2
        let h = rect.height - inset*2
        let x = rect.minX + inset
        let y = rect.minY + inset
        p.move(to: CGPoint(x: x, y: rect.maxY - inset))
        p.addLine(to: CGPoint(x: x, y: y + h*0.5))
        p.addQuadCurve(to: CGPoint(x: x + w, y: y + h*0.5),
                       control: CGPoint(x: x + w/2, y: y - h*0.05))
        p.addLine(to: CGPoint(x: x + w, y: rect.maxY - inset))
        return p
    }
}

// MARK: - Pill Button

struct PillButton: View {
    let title: String
    let systemImage: String
    var gradient: LinearGradient = AppTheme.goldGradient
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(gradient, in: Capsule())
            .shadow(color: Palette.cocoa.opacity(0.25), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Info Row

struct InfoRow: View {
    let systemImage: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .foregroundStyle(Palette.gold)
                .frame(width: 22)
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(AppTheme.captionFont).foregroundStyle(.secondary)
                Text(value).font(.subheadline.weight(.medium)).foregroundStyle(Palette.ink)
            }
        }
    }
}

// MARK: - Empty State

struct EmptyStateView: View {
    let systemImage: String
    let message: String
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(30)
    }
}

// MARK: - Mini Stat

struct MiniStat: View {
    let title: String
    let value: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppTheme.titleFont)
                .foregroundStyle(Palette.gold)
            Text(title)
                .font(AppTheme.captionFont)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }
}
