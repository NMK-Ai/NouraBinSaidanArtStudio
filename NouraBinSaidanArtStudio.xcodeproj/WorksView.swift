import SwiftUI

struct WorksView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager
    
    private var lang: LocalizationManager.Language {
        loc.language
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                
                // MARK: - Featured Artworks Carousel
                if let artworksData = vm.artworks,
                   let featuredArtworks = artworksData.artworks.filter({ $0.featured }) as [Artwork]?,
                   !featuredArtworks.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(featuredArtworks) { artwork in
                                ArtworkCard(artwork: artwork, lang: lang, source: vm.source(for: artwork.sourceId))
                                    .frame(width: 280)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                
                // MARK: - Categorized Artworks Grid
                if let artworksData = vm.artworks {
                    VStack(spacing: 24) {
                        ForEach(categoriesOrder(from: artworksData), id: \.self) { category in
                            let artworksInCategory = artworks(in: artworksData, for: category)
                            if !artworksInCategory.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text(loc.L("works.category.\(category)"))
                                        .font(AppTheme.headingFont)
                                        .foregroundColor(Palette.ink)
                                        .padding(.horizontal, 16)
                                    
                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                        ForEach(artworksInCategory) { artwork in
                                            ArtworkCard(artwork: artwork, lang: lang, source: vm.source(for: artwork.sourceId))
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                }
                
                // MARK: - Timeline Section
                if let timeline = vm.timeline, !timeline.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 6) {
                            Image(systemName: "clock.arrow.circlepath")
                                .foregroundColor(Palette.gold)
                            Text(loc.L("works.timeline.title"))
                                .font(AppTheme.headingFont)
                                .foregroundColor(Palette.ink)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                        
                        let grouped = Dictionary(grouping: timeline, by: { $0.year })
                        let sortedYears = grouped.keys.sorted(by: { (year1, year2) in
                            let s1 = timeline.first(where: { $0.year == year1 })?.sortKey ?? 0
                            let s2 = timeline.first(where: { $0.year == year2 })?.sortKey ?? 0
                            return s1 < s2
                        })
                        
                        VStack(spacing: 16) {
                            ForEach(sortedYears, id: \.self) { year in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("\(year)")
                                        .font(AppTheme.headingFont)
                                        .foregroundColor(Palette.bourbon)
                                        .padding(.horizontal, 16)
                                    
                                    ForEach(grouped[year] ?? []) { event in
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(event.title?[lang.rawValue] ?? "")
                                                .font(AppTheme.captionFont.bold())
                                                .foregroundColor(Palette.ink)
                                            if let desc = event.description?[lang.rawValue], !desc.isEmpty {
                                                Text(desc)
                                                    .font(AppTheme.captionFont)
                                                    .foregroundColor(Palette.ink.opacity(0.75))
                                            }
                                            if let sourceId = event.sourceId,
                                               let source = vm.source(for: sourceId) {
                                                Button {
                                                    LinkOpener.open(source.url)
                                                } label: {
                                                    Label(source.name, systemImage: "link")
                                                        .font(AppTheme.captionFont)
                                                        .foregroundColor(Palette.gold)
                                                }
                                                .accessibilityLabel(Text(loc.L("source.open", source.name)))
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // MARK: - News Section
                VStack(spacing: 8) {
                    NavigationLink(destination: NewsMediaView()) {
                        Text(loc.L("news.title"))
                            .font(AppTheme.headingFont)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Palette.gold)
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
                    }
                    .accessibilityIdentifier("newsNavigationLink")
                }
                .padding(.vertical, 16)
            }
            .padding(.vertical, 24)
        }
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(loc.L("works.title"))
    }
    
    
    // MARK: - Helpers
    
    func categoriesOrder(from data: ArtworksData) -> [String] {
        let preferredOrder = ["mural", "installation", "tunnel", "collaboration", "international"]
        return preferredOrder.filter { category in
            data.categories.contains(where: { $0.label == category })
        }
    }
    
    func artworks(in data: ArtworksData, for category: String) -> [Artwork] {
        data.artworks.filter { $0.category == category }
    }
}


private struct ArtworkCard: View {
    let artwork: Artwork
    let lang: LocalizationManager.Language
    let source: Source?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                ArtImage(assetName: artwork.image ?? "", fallbackColor: Palette.placeholder(named: artwork.placeholderColor))
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .clipped()
                    .cornerRadius(12)
                
                if let category = artwork.category {
                    Text(LocalizationManager.shared.L("works.category.\(category)"))
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Capsule())
                        .padding(8)
                        .accessibilityLabel(Text(LocalizationManager.shared.L("works.category.\(category)")))
                }
            }
            
            Text(artwork.title?[lang.rawValue] ?? "")
                .font(AppTheme.headingFont)
                .foregroundColor(Palette.ink)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            if let desc = artwork.description?[lang.rawValue], !desc.isEmpty {
                Text(desc)
                    .font(AppTheme.captionFont)
                    .foregroundColor(Palette.ink.opacity(0.75))
                    .lineLimit(2)
            }
            
            if let source = source {
                Button {
                    LinkOpener.open(source.url)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right.square")
                        Text(source.name)
                    }
                    .font(AppTheme.captionFont)
                    .foregroundColor(Palette.gold)
                }
                .accessibilityLabel(Text(LocalizationManager.shared.L("source.open", source.name)))
                .padding(.top, 2)
            }
            
        }
    }
}


/// #Preview
/*
#Preview {
    WorksView()
        .environmentObject(ContentViewModel.stub)
        .environmentObject(LocalizationManager())
}
*/
