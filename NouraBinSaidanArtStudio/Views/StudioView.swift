import SwiftUI

struct StudioView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }
    private var studio: Studio? { vm.profile?.studio }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                if let s = studio {
                    headerCard(s)
                    visionCard(s)
                    activitiesCard(s)
                    locationCard(s)
                    contactCTA
                } else {
                    EmptyStateView(systemImage: "building.2", message: L("common.loading"))
                        .padding(.top, 60)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("studio.title"))
        .navigationBarTitleDisplayMode(.large)
    }

    private func headerCard(_ s: Studio) -> some View {
        ZStack(alignment: .bottomLeading) {
            ArtImage(assetName: "studio_interior", fallbackColor: Palette.indigo)
                .frame(height: 220)
                .overlay(LinearGradient(colors: [.clear, Palette.cocoa.opacity(0.8)],
                                        startPoint: .center, endPoint: .bottom))
                .overlay(alignment: .topTrailing) {
                    Button {
                        LinkOpener.open("https://www.instagram.com/p/DIyw8g2tz1B/")
                    } label: {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                    .padding(12)
                    .accessibilityLabel(Text("Instagram"))
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(s.name(for: lang))
                    .font(AppTheme.titleFont)
                    .foregroundStyle(.white)
                Text(s.district(for: lang))
                    .font(.subheadline)
                    .foregroundStyle(Palette.gold)
            }
            .padding(16)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
    }

    private func visionCard(_ s: Studio) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(L("studio.vision"))
            Text(s.vision(for: lang))
                .font(.subheadline)
                .foregroundStyle(Palette.ink)
                .lineSpacing(5)
        }
        .premiumCard()
    }

    private func activitiesCard(_ s: Studio) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(L("studio.activities"))
            VStack(alignment: .leading, spacing: 10) {
                ForEach(s.activities(for: lang), id: \.self) { activity in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "sparkles")
                            .foregroundStyle(Palette.gold)
                        Text(activity)
                            .font(.subheadline)
                            .foregroundStyle(Palette.ink)
                    }
                }
            }
        }
        .premiumCard()
    }

    private func locationCard(_ s: Studio) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(L("studio.location"))

            // Location image with address overlay
            ZStack(alignment: .bottomLeading) {
                ArtImage(assetName: "studio_location", fallbackColor: Palette.indigo)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        LinearGradient(colors: [.clear, Palette.cocoa.opacity(0.8)],
                                       startPoint: .center, endPoint: .bottom)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    )
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(Palette.gold)
                    Text("\(s.district(for: lang)) — \(s.city(for: lang))")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                }
                .padding(12)
            }

            InfoRow(systemImage: "number.circle",
                    label: L("common.building"),
                    value: s.building)

            Button {
                let q = "Noura Bin Saidan Studio JAX District Diriyah Riyadh"
                if let encoded = q.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let url = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encoded)") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Label(L("contact.openMap"), systemImage: "map.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppTheme.goldGradient, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .premiumCard()
    }

    private var contactCTA: some View {
        NavigationLink(value: AppRoute.contact) {
            HStack {
                Image(systemName: "envelope.fill").foregroundStyle(Palette.gold)
                Text(L("home.contact")).font(.subheadline.weight(.semibold)).foregroundStyle(Palette.ink)
                Spacer()
                Image(systemName: "chevron.left").foregroundStyle(.secondary).scaleEffect(x: loc.isRTL ? 1 : -1, y: 1)
            }
            .padding(14)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
