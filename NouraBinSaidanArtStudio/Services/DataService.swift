import Foundation
import SwiftUI

/// Loads local JSON data files from the app bundle with caching and graceful error handling.
final class DataService {
    static let shared = DataService()

    private var cache: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.noura.data.cache", attributes: .concurrent)

    private init() {}

    // MARK: - Public loaders

    func loadProfile() -> Profile? {
        loadProfileData()?.profile
    }

    func loadProfileData() -> ProfileData? {
        decode("noura_profile")
    }

    func loadTimeline() -> [TimelineItem] {
        (decode("timeline") as TimelineData?)?.timeline.sorted(by: { $0.sortKey() < $1.sortKey() }) ?? []
    }

    func loadAwards() -> [Award] {
        (decode("awards") as AwardsData?)?.awards ?? []
    }

    func loadArtworks() -> ArtworksData? {
        decode("artworks")
    }

    func loadProducts() -> ProductsData? {
        decode("products")
    }

    func loadServices() -> ServicesData? {
        decode("services")
    }

    func loadSocialLinks() -> [SocialAccount] {
        (decode("social_links") as SocialLinksData?)?.accounts ?? []
    }

    func loadSources() -> [SourceRef] {
        (decode("sources") as SourcesData?)?.sources ?? []
    }

    func source(for id: String) -> SourceRef? {
        loadSources().first(where: { $0.id == id })
    }

    // MARK: - Generic decode with caching

    private func decode<T: Decodable>(_ name: String) -> T? {
        if let cached = readCache(name) as? T { return cached }
        guard let data = loadDataFile(name) else { return nil }
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            writeCache(name, value: decoded)
            return decoded
        } catch {
            #if DEBUG
            print("⚠️ Decode error for \(name): \(error)")
            #endif
            return nil
        }
    }

    private func loadDataFile(_ name: String) -> Data? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            #if DEBUG
            print("⚠️ Missing JSON: \(name).json")
            #endif
            return nil
        }
        return try? Data(contentsOf: url)
    }

    // MARK: - Thread-safe cache

    private func readCache(_ key: String) -> Any? {
        queue.sync { cache[key] }
    }

    private func writeCache(_ key: String, value: Any) {
        queue.async(flags: .barrier) { [weak self] in
            self?.cache[key] = value
        }
    }
}

// MARK: - Localization Manager

/// Observable app language + direction. Persists user choice and mirrors it into the environment.
/// Provides instant runtime string lookup via a bundled dictionary so the UI flips immediately
/// when the language changes (without an app restart).
final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()

    @AppStorage("app_language") private var storedLang: String = AppLanguage.arabic.rawValue

    @Published var language: AppLanguage {
        didSet {
            storedLang = language.rawValue
            applyLanguage()
        }
    }

    /// Loaded ".strings" dictionaries per language, used by `string(for:)` for instant lookups.
    private(set) var dictionaries: [AppLanguage: [String: String]] = [:]

    private init() {
        let stored = UserDefaults.standard.string(forKey: "app_language") ?? AppLanguage.arabic.rawValue
        language = AppLanguage(rawValue: stored) ?? .arabic
        loadStrings()
        applyLanguage()
    }

    var isRTL: Bool { language == .arabic }

    func toggle() {
        language = (language == .arabic) ? .english : .arabic
    }

    /// Instant localized string for a key, live-switching with `language`.
    func string(for key: String) -> String {
        if let value = dictionaries[language]?[key] { return value }
        return NSLocalizedString(key, comment: "")
    }

    /// Loads the ar/en `.strings` files into dictionaries for O(1) runtime lookup.
    private func loadStrings() {
        for lang in [AppLanguage.arabic, AppLanguage.english] {
            dictionaries[lang] = Self.loadStringsDict(for: lang)
        }
    }

    private static func loadStringsDict(for lang: AppLanguage) -> [String: String] {
        // Prefer the localization-aware lookup
        if let url = Bundle.main.url(forResource: "Localizable", withExtension: "strings", subdirectory: nil, localization: lang.rawValue),
           let data = try? Data(contentsOf: url),
           let parsed = (try? PropertyListSerialization.propertyList(from: data, options: [], format: nil)) as? [String: String] {
            return parsed
        }
        // Fallback: lproj folder bundle
        if let lprojURL = Bundle.main.url(forResource: lang.rawValue, withExtension: "lproj"),
           let bundle = Bundle(url: lprojURL) {
            // Read via NSDictionary for a full table
            if let path = bundle.path(forResource: "Localizable", ofType: "strings"),
               let dict = NSDictionary(contentsOfFile: path) as? [String: String] {
                return dict
            }
        }
        return [:]
    }

    private func applyLanguage() {
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}

/// Global convenience accessor for live localized strings — drop-in replacement for NSLocalizedString.
/// Usage: `L("home.story")` instead of `NSLocalizedString("home.story", comment: "")`.
func L(_ key: String) -> String {
    LocalizationManager.shared.string(for: key)
}

// MARK: - Theme Manager (Day / Night)

/// Observable appearance manager: system, light, or dark. Persists user choice.
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()

    enum Mode: String, CaseIterable {
        case light, dark, system
        var colorScheme: ColorScheme? {
            switch self {
            case .light: return .light
            case .dark: return .dark
            case .system: return nil
            }
        }
        var labelAr: String {
            switch self {
            case .light: return "نهاري"
            case .dark: return "ليلي"
            case .system: return "تلقائي"
            }
        }
        var labelEn: String {
            switch self {
            case .light: return "Light"
            case .dark: return "Dark"
            case .system: return "Auto"
            }
        }
        var icon: String {
            switch self {
            case .light: return "sun.max.fill"
            case .dark: return "moon.stars.fill"
            case .system: return "circle.lefthalf.filled"
            }
        }
    }

    @AppStorage("app_theme") private var storedRaw: String = Mode.system.rawValue

    @Published var mode: Mode {
        didSet { storedRaw = mode.rawValue }
    }

    private init() {
        let raw = UserDefaults.standard.string(forKey: "app_theme") ?? Mode.system.rawValue
        mode = Mode(rawValue: raw) ?? .system
    }

    func cycle() {
        switch mode {
        case .system: mode = .light
        case .light: mode = .dark
        case .dark: mode = .system
        }
    }

    func label(for lang: AppLanguage) -> String {
        lang == .arabic ? mode.labelAr : mode.labelEn
    }
}

// MARK: - Link Opener

enum LinkOpener {
    @MainActor
    @discardableResult
    static func open(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString),
              let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https" || scheme == "whatsapp" || scheme == "mailto" || scheme == "tel"
        else { return false }
        #if canImport(UIKit)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return true
        #else
        return false
        #endif
    }
}
