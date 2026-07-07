import SwiftUI

// MARK: - Routing

enum AppRoute: Hashable {
    case about
    case timeline
    case awards
    case gallery
    case studio
    case products
    case services
    case news
    case contact
}

// MARK: - Root

struct RootView: View {
    @EnvironmentObject private var loc: LocalizationManager

    var body: some View {
        TabView {
            homeTab
                .tabItem {
                    Label(L("nav.home"), systemImage: "house.fill")
                }
            galleryTab
                .tabItem {
                    Label(L("nav.gallery"), systemImage: "paintbrush.pointed.fill")
                }
            shopTab
                .tabItem {
                    Label(L("nav.shop"), systemImage: "storefront.fill")
                }
            moreTab
                .tabItem {
                    Label(L("nav.more"), systemImage: "rectangle.grid.2x2.fill")
                }
        }
        .tint(Palette.bourbon)
    }

    private var homeTab: some View {
        NavigationStack {
            HomeView()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            loc.toggle()
                        } label: {
                            Image(systemName: "globe")
                                .foregroundStyle(Palette.gold)
                        }
                    }
                }
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    private var galleryTab: some View {
        NavigationStack { GalleryView() }
    }

    private var shopTab: some View {
        NavigationStack {
            ProductsView()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { loc.toggle() } label: {
                            Image(systemName: "globe").foregroundStyle(Palette.gold)
                        }
                    }
                }
        }
    }

    private var moreTab: some View {
        NavigationStack {
            MoreMenuView()
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .about: AboutView()
        case .timeline: TimelineView()
        case .awards: AwardsView()
        case .gallery: GalleryView()
        case .studio: StudioView()
        case .products: ProductsView()
        case .services: ServicesView()
        case .news: NewsMediaView()
        case .contact: ContactView()
        }
    }
}

// MARK: - More Menu

struct MoreMenuView: View {
    @EnvironmentObject private var loc: LocalizationManager
    @EnvironmentObject private var theme: ThemeManager

    private let items: [(AppRoute, String, String, Color)] = [
        (.about, "home.about", "person.crop.circle.badge.questionmark", Palette.terracotta),
        (.timeline, "home.timeline", "clock.arrow.circlepath", Palette.olive),
        (.awards, "home.awards", "rosette", Palette.gold),
        (.studio, "home.studio", "building.2.fill", Palette.indigo),
        (.services, "home.services", "graduationcap.fill", Palette.sage),
        (.news, "home.news", "newspaper.fill", Palette.cocoa),
        (.contact, "home.contact", "envelope.fill", Palette.bourbon)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(items, id: \.0) { item in
                    NavigationLink(value: item.0) {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(item.3.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                Image(systemName: item.2).foregroundStyle(item.3)
                            }
                            Text(L(item.1))
                                .font(.headline)
                                .foregroundStyle(Palette.ink)
                            Spacer()
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.secondary)
                                .scaleEffect(x: loc.isRTL ? 1 : -1, y: 1, anchor: .center)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }

                languageToggle
                themeToggle
                attributionCard
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("nav.more"))
        .navigationBarTitleDisplayMode(.large)
    }

    private var languageToggle: some View {
        Button { loc.toggle() } label: {
            HStack {
                Image(systemName: "globe").foregroundStyle(Palette.gold)
                Text(L("common.language"))
                    .font(.headline).foregroundStyle(Palette.ink)
                Spacer()
                Text(loc.language == .arabic ? L("common.arabic_lang") : L("common.english_lang"))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.gold)
                Image(systemName: "arrow.triangle.2.circlepath").foregroundStyle(Palette.gold)
            }
            .padding(14)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var themeToggle: some View {
        Button { theme.cycle() } label: {
            HStack {
                Image(systemName: theme.mode.icon).foregroundStyle(Palette.gold)
                Text(L("common.appearance"))
                    .font(.headline).foregroundStyle(Palette.ink)
                Spacer()
                Text(theme.label(for: loc.language))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.gold)
                Image(systemName: "arrow.triangle.2.circlepath").foregroundStyle(Palette.gold)
            }
            .padding(14)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var attributionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L("app.title"))
                .font(AppTheme.captionFont.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(loc.language == .arabic
                 ? "كل المعلومات موثّقة من مصادر رسمية. صور الأعمال المعروضة توليدية مكانية لاحترام حقوق الصور."
                 : "All facts are verified from official sources. Artwork visuals are generative placeholders respecting image rights.")
                .font(.system(size: 11))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Palette.gold.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
