import SwiftUI

@main
struct NouraBinSaidanApp: App {
    @StateObject private var loc = LocalizationManager.shared
    @StateObject private var theme = ThemeManager.shared
    @StateObject private var vm = ContentViewModel()
    @State private var splashDone = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                    .environmentObject(loc)
                    .environmentObject(theme)
                    .environmentObject(vm)
                    .environment(\.layoutDirection, loc.isRTL ? .rightToLeft : .leftToRight)
                    .environment(\.locale, loc.language.locale)
                    .preferredColorScheme(theme.mode.colorScheme)

                if !splashDone {
                    SplashView(hasAppeared: $splashDone)
                        .environmentObject(loc)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
    }
}
