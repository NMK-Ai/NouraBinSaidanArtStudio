import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }
    private var profile: Profile? { vm.profile }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                heroSection
                quickLinksSection
                featuredAwardsSection
                featuredWorksSection
                studioTeaser
            }
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Hero
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            ArtImage(assetName: "boulevard_mural", fallbackColor: Palette.bourbon)
                .frame(height: 300)
                .overlay(
                    LinearGradient(colors: [.clear, Palette.cocoa.opacity(0.85)],
                                   startPoint: .center, endPoint: .bottom)
                )
                .overlay(alignment: .topTrailing) {
                    Text(L("home.boulevard_badge"))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(12)
                }

            VStack(alignment: .leading, spacing: 8) {
                Text(profile?.name(for: lang) ?? L("app.title"))
                    .font(AppTheme.displayFont)
                    .foregroundStyle(.white)
                Text(profile?.tagline(for: lang) ?? L("app.subtitle"))
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Palette.gold)
                if let bio = profile?.shortBio(for: lang) {
                    Text(bio)
                        .font(AppTheme.captionFont)
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(3)
                        .padding(.top, 2)
                }
            }
            .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous))
        .padding(.horizontal)
    }

    // MARK: Quick links
    private var quickLinksSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            QuickLinkCard(icon: "person.crop.circle.badge.questionmark", titleKey: "home.about", color: Palette.terracotta, route: .about)
            QuickLinkCard(icon: "clock.arrow.circlepath", titleKey: "home.timeline", color: Palette.olive, route: .timeline)
            QuickLinkCard(icon: "rosette", titleKey: "home.awards", color: Palette.gold, route: .awards)
            QuickLinkCard(icon: "paintbrush.pointed", titleKey: "home.works", color: Palette.cocoa, route: .gallery)
            QuickLinkCard(icon: "storefront", titleKey: "home.products", color: Palette.indigo, route: .products)
            QuickLinkCard(icon: "graduationcap.fill", titleKey: "home.services", color: Palette.sage, route: .services)
        }
        .padding(.horizontal)
    }

    // MARK: Featured awards
    @ViewBuilder
    private var featuredAwardsSection: some View {
        if !vm.featuredAwards.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(L("home.featured"), subtitle: L("home.awards"))
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(vm.featuredAwards) { award in
                            NavigationLink(value: AppRoute.awards) {
                                FeaturedAwardCard(award: award)
                            }
                            .buttonStyle(.plain)
                            .frame(width: 280)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    // MARK: Featured works
    @ViewBuilder
    private var featuredWorksSection: some View {
        if !vm.featuredArtworks.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    SectionHeader(L("home.featured"), subtitle: L("home.works"))
                    Spacer()
                    NavigationLink(value: AppRoute.gallery) {
                        Text(L("common.viewAll"))
                            .font(AppTheme.captionFont.weight(.semibold))
                            .foregroundStyle(Palette.gold)
                    }
                }
                .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(vm.featuredArtworks) { art in
                            NavigationLink(value: AppRoute.gallery) {
                                VStack(alignment: .leading, spacing: 8) {
                                    ArtImage(assetName: art.image ?? "", fallbackColor: Palette.placeholder(named: art.placeholderColor), title: art.title(for: lang))
                                        .frame(width: 220, height: 150)
                                    Text(art.title(for: lang))
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(Palette.ink)
                                        .lineLimit(2)
                                        .frame(width: 220, alignment: .leading)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    // MARK: Studio teaser
    @ViewBuilder
    private var studioTeaser: some View {
        if let studio = profile?.studio {
            NavigationLink(value: AppRoute.studio) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundStyle(Palette.gold)
                        Text(L("home.studio"))
                            .font(AppTheme.headingFont)
                            .foregroundStyle(Palette.ink)
                        Spacer()
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.secondary)
                            .scaleEffect(x: loc.isRTL ? 1 : -1, y: 1, anchor: .center)
                    }
                    Text(studio.vision(for: lang))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                    InfoRow(systemImage: "mappin.and.ellipse",
                            label: L("studio.location"),
                            value: "\(studio.district(for: lang)) — \(studio.city(for: lang))")
                }
                .premiumCard()
                .padding(.horizontal)
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Quick Link Card

struct QuickLinkCard: View {
    let icon: String
    let titleKey: String
    let color: Color
    let route: AppRoute
    @EnvironmentObject private var loc: LocalizationManager

    var body: some View {
        NavigationLink(value: route) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(color, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                Text(L(titleKey))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.ink)
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Featured Award Card

struct FeaturedAwardCard: View {
    let award: Award
    @EnvironmentObject private var loc: LocalizationManager
    private var lang: AppLanguage { loc.language }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: award.icon == "apple.logo" ? "apple.logo" : award.icon)
                    .font(.title2)
                    .foregroundStyle(Palette.gold)
                Spacer()
                VerifiedBadge()
            }
            Text(award.title(for: lang))
                .font(AppTheme.headingFont)
                .foregroundStyle(Palette.ink)
                .lineLimit(2)
            Text(award.description(for: lang))
                .font(AppTheme.captionFont)
                .foregroundStyle(.secondary)
                .lineLimit(3)
            HStack {
                Text(award.year.isEmpty ? "—" : award.year)
                    .font(AppTheme.monoCaption)
                    .foregroundStyle(Palette.gold)
                Spacer()
            }
        }
        .padding(16)
        .frame(width: 280, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cardCornerRadius, style: .continuous)
                .strokeBorder(Palette.gold.opacity(0.2), lineWidth: 1)
        )
    }
}
