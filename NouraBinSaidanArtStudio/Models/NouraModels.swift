import Foundation

// MARK: - Profile

struct ProfileData: Codable {
    let profile: Profile
}

struct Profile: Codable, Identifiable {
    let id: String
    let nameAr: String
    let nameEn: String
    let taglineAr: String
    let taglineEn: String
    let shortBioAr: String
    let shortBioEn: String
    let specialtiesAr: [String]
    let specialtiesEn: [String]
    let educationAr: String
    let educationEn: String
    let rolesAr: [String]
    let rolesEn: [String]
    let locationAr: String
    let locationEn: String
    let email: String
    let mediaLicense: String
    let legalRepresentativeAr: String
    let legalRepresentativeEn: String
    let studio: Studio

    enum CodingKeys: String, CodingKey {
        case id
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case taglineAr = "tagline_ar"
        case taglineEn = "tagline_en"
        case shortBioAr = "short_bio_ar"
        case shortBioEn = "short_bio_en"
        case specialtiesAr = "specialties_ar"
        case specialtiesEn = "specialties_en"
        case educationAr = "education_ar"
        case educationEn = "education_en"
        case rolesAr = "roles_ar"
        case rolesEn = "roles_en"
        case locationAr = "location_ar"
        case locationEn = "location_en"
        case email
        case mediaLicense = "media_license"
        case legalRepresentativeAr = "legal_representative_ar"
        case legalRepresentativeEn = "legal_representative_en"
        case studio
    }

    func name(for lang: AppLanguage) -> String { lang == .arabic ? nameAr : nameEn }
    func tagline(for lang: AppLanguage) -> String { lang == .arabic ? taglineAr : taglineEn }
    func shortBio(for lang: AppLanguage) -> String { lang == .arabic ? shortBioAr : shortBioEn }
    func specialties(for lang: AppLanguage) -> [String] { lang == .arabic ? specialtiesAr : specialtiesEn }
    func roles(for lang: AppLanguage) -> [String] { lang == .arabic ? rolesAr : rolesEn }
    func education(for lang: AppLanguage) -> String { lang == .arabic ? educationAr : educationEn }
    func location(for lang: AppLanguage) -> String { lang == .arabic ? locationAr : locationEn }
    func legalRepresentative(for lang: AppLanguage) -> String { lang == .arabic ? legalRepresentativeAr : legalRepresentativeEn }
}

struct Studio: Codable {
    let nameAr: String
    let nameEn: String
    let districtAr: String
    let districtEn: String
    let building: String
    let cityAr: String
    let cityEn: String
    let visionAr: String
    let visionEn: String
    let activitiesAr: [String]
    let activitiesEn: [String]

    enum CodingKeys: String, CodingKey {
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case districtAr = "district_ar"
        case districtEn = "district_en"
        case building
        case cityAr = "city_ar"
        case cityEn = "city_en"
        case visionAr = "vision_ar"
        case visionEn = "vision_en"
        case activitiesAr = "activities_ar"
        case activitiesEn = "activities_en"
    }

    func name(for lang: AppLanguage) -> String { lang == .arabic ? nameAr : nameEn }
    func district(for lang: AppLanguage) -> String { lang == .arabic ? districtAr : districtEn }
    func city(for lang: AppLanguage) -> String { lang == .arabic ? cityAr : cityEn }
    func vision(for lang: AppLanguage) -> String { lang == .arabic ? visionAr : visionEn }
    func activities(for lang: AppLanguage) -> [String] { lang == .arabic ? activitiesAr : activitiesEn }
}

// MARK: - Timeline

struct TimelineData: Codable {
    let timeline: [TimelineItem]
}

struct TimelineItem: Codable, Identifiable, Hashable {
    let id: String
    let year: String
    let dateIso: String?
    let titleAr: String
    let titleEn: String
    let descriptionAr: String
    let descriptionEn: String
    let category: String
    let sourceId: String
    let verified: Bool
    let featured: Bool?

    enum CodingKeys: String, CodingKey {
        case id, year, category, verified, featured
        case dateIso = "date_iso"
        case titleAr = "title_ar"
        case titleEn = "title_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case sourceId = "source_id"
    }

    func title(for lang: AppLanguage) -> String { lang == .arabic ? titleAr : titleEn }
    func description(for lang: AppLanguage) -> String { lang == .arabic ? descriptionAr : descriptionEn }
    func sortKey() -> String { dateIso ?? "0000" }
}

// MARK: - Awards

struct AwardsData: Codable {
    let awards: [Award]
}

struct Award: Codable, Identifiable, Hashable {
    let id: String
    let titleAr: String
    let titleEn: String
    let subtitleAr: String?
    let subtitleEn: String?
    let year: String
    let dateIso: String?
    let descriptionAr: String
    let descriptionEn: String
    let grantedByAr: String
    let grantedByEn: String
    let presentedByAr: String?
    let presentedByEn: String?
    let locationAr: String?
    let locationEn: String?
    let sourceId: String
    let verified: Bool
    let featured: Bool?
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, year, verified, featured, icon, sourceId = "source_id"
        case dateIso = "date_iso"
        case titleAr = "title_ar", titleEn = "title_en"
        case subtitleAr = "subtitle_ar", subtitleEn = "subtitle_en"
        case descriptionAr = "description_ar", descriptionEn = "description_en"
        case grantedByAr = "granted_by_ar", grantedByEn = "granted_by_en"
        case presentedByAr = "presented_by_ar", presentedByEn = "presented_by_en"
        case locationAr = "location_ar", locationEn = "location_en"
    }

    func title(for lang: AppLanguage) -> String { lang == .arabic ? titleAr : titleEn }
    func subtitle(for lang: AppLanguage) -> String? { lang == .arabic ? subtitleAr : subtitleEn }
    func description(for lang: AppLanguage) -> String { lang == .arabic ? descriptionAr : descriptionEn }
    func grantedBy(for lang: AppLanguage) -> String { lang == .arabic ? grantedByAr : grantedByEn }
    func presentedBy(for lang: AppLanguage) -> String? { lang == .arabic ? presentedByAr : presentedByEn }
    func location(for lang: AppLanguage) -> String? { lang == .arabic ? locationAr : locationEn }
}

// MARK: - Artworks

struct ArtworksData: Codable {
    let categoriesAr: [String: String]
    let categoriesEn: [String: String]
    let artworks: [Artwork]
}

struct Artwork: Codable, Identifiable, Hashable {
    let id: String
    let titleAr: String
    let titleEn: String
    let category: String
    let year: String
    let descriptionAr: String
    let descriptionEn: String
    let image: String?
    let sourceId: String
    let featured: Bool
    let placeholderColor: String

    enum CodingKeys: String, CodingKey {
        case id, category, year, image, featured
        case titleAr = "title_ar"
        case titleEn = "title_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case sourceId = "source_id"
        case placeholderColor = "placeholder_color"
    }

    func title(for lang: AppLanguage) -> String { lang == .arabic ? titleAr : titleEn }
    func description(for lang: AppLanguage) -> String { lang == .arabic ? descriptionAr : descriptionEn }
    func categoryLabel(for lang: AppLanguage, in data: ArtworksData) -> String {
        let map = lang == .arabic ? data.categoriesAr : data.categoriesEn
        return map[category] ?? category
    }
}

// MARK: - Products

struct ProductsData: Codable {
    let storeUrl: String
    let currency: String
    let noteAr: String
    let noteEn: String
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case storeUrl = "store_url"
        case currency
        case noteAr = "note_ar"
        case noteEn = "note_en"
        case products
    }

    func note(for lang: AppLanguage) -> String { lang == .arabic ? noteAr : noteEn }
}

struct Product: Codable, Identifiable, Hashable {
    let id: String
    let nameAr: String
    let nameEn: String
    let descriptionAr: String
    let descriptionEn: String
    let price: Double
    let type: String
    let image: String?
    let available: Bool
    let buyUrl: String
    let placeholderColor: String

    enum CodingKeys: String, CodingKey {
        case id, price, type, image, available
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case buyUrl = "buy_url"
        case placeholderColor = "placeholder_color"
    }

    func name(for lang: AppLanguage) -> String { lang == .arabic ? nameAr : nameEn }
    func description(for lang: AppLanguage) -> String { lang == .arabic ? descriptionAr : descriptionEn }

    /// Localized, human-readable product type label (e.g. "ورشة" / "Workshop").
    var localizedTypeLabel: String {
        L("type.\(type)")
    }
}

// MARK: - Services

struct ServicesData: Codable {
    let whatsapp: String
    let whatsappDisplayAr: String
    let whatsappDisplayEn: String
    let services: [ServiceItem]

    enum CodingKeys: String, CodingKey {
        case whatsapp, services
        case whatsappDisplayAr = "whatsapp_display_ar"
        case whatsappDisplayEn = "whatsapp_display_en"
    }

    func whatsappDisplay(for lang: AppLanguage) -> String { lang == .arabic ? whatsappDisplayAr : whatsappDisplayEn }
}

struct ServiceItem: Codable, Identifiable, Hashable {
    let id: String
    let nameAr: String
    let nameEn: String
    let descriptionAr: String
    let descriptionEn: String
    let icon: String
    let sourceId: String

    enum CodingKeys: String, CodingKey {
        case id, icon
        case nameAr = "name_ar"
        case nameEn = "name_en"
        case descriptionAr = "description_ar"
        case descriptionEn = "description_en"
        case sourceId = "source_id"
    }

    func name(for lang: AppLanguage) -> String { lang == .arabic ? nameAr : nameEn }
    func description(for lang: AppLanguage) -> String { lang == .arabic ? descriptionAr : descriptionEn }
}

// MARK: - Social Links

struct SocialLinksData: Codable {
    let accounts: [SocialAccount]
}

struct SocialAccount: Codable, Identifiable, Hashable {
    let id: String
    let platform: String
    let handle: String
    let labelAr: String
    let labelEn: String
    let url: String
    let icon: String
    let category: String
    let verified: Bool

    enum CodingKeys: String, CodingKey {
        case id, platform, handle, url, icon, category, verified
        case labelAr = "label_ar"
        case labelEn = "label_en"
    }

    func label(for lang: AppLanguage) -> String { lang == .arabic ? labelAr : labelEn }
}

// MARK: - Sources

struct SourcesData: Codable {
    let sources: [SourceRef]
}

struct SourceRef: Codable, Identifiable, Hashable {
    let id: String
    let labelAr: String
    let labelEn: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case id, url
        case labelAr = "label_ar"
        case labelEn = "label_en"
    }

    func label(for lang: AppLanguage) -> String { lang == .arabic ? labelAr : labelEn }
}

// MARK: - App Language Helper

enum AppLanguage: String, CaseIterable, Codable {
    case arabic = "ar"
    case english = "en"

    var locale: Locale { Locale(identifier: rawValue) }
    var direction: String { rawValue }
}
