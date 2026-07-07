import SwiftUI

struct SplashView: View {
    @Binding var hasAppeared: Bool
    @EnvironmentObject private var loc: LocalizationManager

    @State private var animateIn = false
    @State private var showFlower = false

    var body: some View {
        ZStack {
            AppTheme.heroGradient.ignoresSafeArea()

            // Soft mural glow
            RadialGradient(
                colors: [Palette.gold.opacity(0.35), .clear],
                center: .center,
                startRadius: 10,
                endRadius: 320
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Generative Najdi-flower emblem (original code art)
                ZStack {
                    Circle()
                        .stroke(Palette.gold.opacity(0.5), lineWidth: 2)
                        .frame(width: 150, height: 150)
                        .scaleEffect(showFlower ? 1 : 0.6)
                        .opacity(showFlower ? 1 : 0)

                    SplashFlower()
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(showFlower ? 0 : -90))
                        .opacity(showFlower ? 1 : 0)
                }

                VStack(spacing: 8) {
                    Text(loc.language == .arabic ? "نورة بن سعيدان" : "Noura Bin Saidan")
                        .font(AppTheme.displayFont)
                        .foregroundStyle(.white)
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 12)

                    Text(loc.language == .arabic ? "استوديو نورة بن سعيدان للفنون" : "Noura Bin Saidan Art Studio")
                        .font(AppTheme.headingFont)
                        .foregroundStyle(Palette.gold)
                        .opacity(animateIn ? 1 : 0)
                        .offset(y: animateIn ? 0 : 12)

                    Text(L("splash.tagline"))
                        .font(AppTheme.captionFont)
                        .foregroundStyle(.white.opacity(0.75))
                        .padding(.top, 4)
                        .opacity(animateIn ? 1 : 0)
                }

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) { showFlower = true }
            withAnimation(.easeOut(duration: 0.7).delay(0.4)) { animateIn = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    hasAppeared = true
                }
            }
        }
    }
}

private struct SplashFlower: View {
    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2
            let petals = 12
            let r = min(size.width, size.height) * 0.42
            for i in 0..<petals {
                let angle = (Double(i) / Double(petals)) * 2 * .pi
                let x = cx + cos(angle) * r
                let y = cy + sin(angle) * r
                var petal = Path()
                petal.addEllipse(in: CGRect(x: x - r*0.18, y: y - r*0.28, width: r*0.36, height: r*0.56))
                context.fill(petal, with: .color(Palette.gold.opacity(0.35)))
            }
            context.fill(
                Circle().path(in: CGRect(x: cx - r*0.18, y: cy - r*0.18, width: r*0.36, height: r*0.36)),
                with: .color(.white.opacity(0.8))
            )
        }
    }
}
