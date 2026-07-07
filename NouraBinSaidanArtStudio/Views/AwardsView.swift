import SwiftUI

struct AwardsView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                ForEach(vm.awards) { award in
                    AwardCard(award: award, source: vm.source(for: award.sourceId))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("awards.title"))
        .navigationBarTitleDisplayMode(.large)
    }
}

struct AwardCard: View {
    let award: Award
    @EnvironmentObject private var loc: LocalizationManager
    let source: SourceRef?
    private var lang: AppLanguage { loc.language }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(Palette.gold.opacity(0.15))
                        .frame(width: 52, height: 52)
                    Image(systemName: award.icon == "apple.logo" ? "apple.logo" : award.icon)
                        .font(.title2)
                        .foregroundStyle(Palette.gold)
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(award.title(for: lang))
                            .font(AppTheme.titleFont)
                            .foregroundStyle(Palette.ink)
                        if award.featured == true {
                            Image(systemName: "star.fill")
                                .foregroundStyle(Palette.gold)
                        }
                    }
                    if let sub = award.subtitle(for: lang) {
                        Text(sub)
                            .font(AppTheme.captionFont)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                if award.verified { VerifiedBadge() }
            }

            if !award.description(for: lang).isEmpty {
                Text(award.description(for: lang))
                    .font(.subheadline)
                    .foregroundStyle(Palette.ink)
                    .lineSpacing(4)
            }

            VStack(alignment: .leading, spacing: 6) {
                if !award.year.isEmpty {
                    InfoRow(systemImage: "calendar",
                            label: L("common.year"),
                            value: award.year)
                }
                if let granted = award.grantedBy(for: lang).isEmpty ? nil : award.grantedBy(for: lang) {
                    InfoRow(systemImage: "scroll.fill",
                            label: L("awards.granted"),
                            value: granted)
                }
                if let presented = award.presentedBy(for: lang), !presented.isEmpty {
                    InfoRow(systemImage: "person.fill.checkmark",
                            label: L("awards.presented"),
                            value: presented)
                }
                if let loc = award.location(for: lang), !loc.isEmpty {
                    InfoRow(systemImage: "mappin.and.ellipse",
                            label: L("awards.location"),
                            value: loc)
                }
            }

            SourceChip(source: source, lang: lang)
        }
        .premiumCard()
    }
}
