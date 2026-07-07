import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }
    @State private var selectedCategory: String = "all"
    @State private var selectedArtwork: Artwork?

    private var categories: [(id: String, label: String)] {
        var arr: [(String, String)] = [("all", L("gallery.all"))]
        let map = lang == .arabic ? vm.artworks?.categoriesAr : vm.artworks?.categoriesEn
        if let map {
            arr.append(contentsOf: map.map { ($0.key, $0.value) })
        }
        return arr
    }

    private var filtered: [Artwork] {
        let all = vm.artworks?.artworks ?? []
        return selectedCategory == "all" ? all : all.filter { $0.category == selectedCategory }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                categoryBar
                if filtered.isEmpty {
                    EmptyStateView(systemImage: "paintbrush.pointed",
                                   message: L("gallery.empty"))
                        .padding(.top, 40)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(filtered) { art in
                            Button { selectedArtwork = art } label: {
                                artworkTile(art)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("gallery.title"))
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedArtwork) { art in
            ArtworkDetailView(artwork: art)
                .environmentObject(vm)
                .environmentObject(loc)
                .presentationDetents([.large])
        }
    }

    private var categoryBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.id) { cat in
                    Button {
                        withAnimation(.easeInOut) { selectedCategory = cat.id }
                    } label: {
                        Text(cat.label)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(selectedCategory == cat.id ? .white : Palette.cocoa)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(selectedCategory == cat.id ? AnyShapeStyle(Palette.bourbon) : AnyShapeStyle(Palette.gold.opacity(0.14)))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func artworkTile(_ art: Artwork) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ArtImage(assetName: art.image ?? "", fallbackColor: Palette.placeholder(named: art.placeholderColor), title: art.title(for: lang))
                .frame(height: 160)
            VStack(alignment: .leading, spacing: 4) {
                Text(art.title(for: lang))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.ink)
                    .lineLimit(2)
                if !art.year.isEmpty {
                    Text(art.year)
                        .font(AppTheme.monoCaption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct ArtworkDetailView: View {
    let artwork: Artwork
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ArtImage(assetName: artwork.image ?? "", fallbackColor: Palette.placeholder(named: artwork.placeholderColor), title: artwork.title(for: lang))
                        .frame(height: 280)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(artwork.title(for: lang))
                            .font(AppTheme.titleFont)
                            .foregroundStyle(Palette.ink)
                        if !artwork.year.isEmpty {
                            Text(artwork.year)
                                .font(AppTheme.monoCaption)
                                .foregroundStyle(.secondary)
                        }
                        Text(artwork.description(for: lang))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineSpacing(4)
                        SourceChip(source: vm.source(for: artwork.sourceId), lang: lang)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle(L("gallery.detail"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) { Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary) }
                }
            }
        }
    }
}
