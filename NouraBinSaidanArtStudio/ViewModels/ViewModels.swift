import Foundation
import Combine

// MARK: - Content View Model

/// Central read-only content holder. Loads everything once on init (local JSON) and exposes typed data.
@MainActor
final class ContentViewModel: ObservableObject {
    @Published var profile: Profile?
    @Published var timeline: [TimelineItem] = []
    @Published var awards: [Award] = []
    @Published var artworks: ArtworksData?
    @Published var products: ProductsData?
    @Published var services: ServicesData?
    @Published var social: [SocialAccount] = []
    @Published var sources: [SourceRef] = []
    @Published var loadError: String?

    private let data = DataService.shared

    init() {
        loadAll()
    }

    func loadAll() {
        profile = data.loadProfile()
        timeline = data.loadTimeline()
        awards = data.loadAwards()
        artworks = data.loadArtworks()
        products = data.loadProducts()
        services = data.loadServices()
        social = data.loadSocialLinks()
        sources = data.loadSources()
    }

    func source(for id: String) -> SourceRef? {
        sources.first(where: { $0.id == id })
    }

    var featuredArtworks: [Artwork] {
        (artworks?.artworks ?? []).filter { $0.featured }
    }

    var featuredAwards: [Award] {
        awards.filter { $0.featured == true }
    }
}
