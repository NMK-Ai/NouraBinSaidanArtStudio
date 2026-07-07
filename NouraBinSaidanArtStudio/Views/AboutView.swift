import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let p = vm.profile {
                    portraitHeader(p)
                    bioCard(p)
                    specialtiesCard(p)
                    educationCard(p)
                    rolesCard(p)
                    missionCard(p)
                } else {
                    EmptyStateView(systemImage: "person.crop.circle.badge.exclamationmark",
                                   message: L("common.loading"))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("about.title"))
        .navigationBarTitleDisplayMode(.large)
    }

    private func portraitHeader(_ p: Profile) -> some View {
        VStack(spacing: 12) {
            ArtImage(assetName: "noura_portrait", fallbackColor: Palette.terracotta)
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
            Text(p.name(for: lang))
                .font(AppTheme.displayFont)
                .foregroundStyle(Palette.ink)
            Text(p.tagline(for: lang))
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Palette.gold)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 8)
    }

    private func bioCard(_ p: Profile) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(L("about.bio"))
            Text(p.shortBio(for: lang))
                .font(.subheadline)
                .foregroundStyle(Palette.ink)
                .lineSpacing(5)
        }
        .premiumCard()
    }

    private func specialtiesCard(_ p: Profile) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(L("about.specialties"))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(p.specialties(for: lang), id: \.self) { specialty in
                    HStack(spacing: 10) {
                        Image(systemName: "paintbrush.pointed.fill")
                            .font(.callout)
                            .foregroundStyle(Palette.gold)
                            .frame(width: 28, height: 28)
                            .background(Palette.gold.opacity(0.12), in: Circle())
                        Text(specialty)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(Palette.ink)
                            .lineLimit(2)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.tertiarySystemBackground))
                    )
                }
            }
        }
        .premiumCard()
    }

    private func educationCard(_ p: Profile) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(L("about.education"))
            InfoRow(systemImage: "graduationcap.fill",
                    label: L("about.education"),
                    value: p.education(for: lang))
        }
        .premiumCard()
    }

    private func rolesCard(_ p: Profile) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(L("about.roles"))
            VStack(alignment: .leading, spacing: 8) {
                ForEach(p.roles(for: lang), id: \.self) { role in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Palette.olive)
                        Text(role).font(.subheadline).foregroundStyle(Palette.ink)
                    }
                }
            }
        }
        .premiumCard()
    }

    private func missionCard(_ p: Profile) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(L("about.mission"))
            Text(p.shortBio(for: lang))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(5)
        }
        .premiumCard()
    }
}

// MARK: - Flow Chips (removed — replaced by specialties grid)
