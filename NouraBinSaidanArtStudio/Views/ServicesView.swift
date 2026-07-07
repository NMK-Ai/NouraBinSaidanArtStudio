import SwiftUI

struct ServicesView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }
    private var data: ServicesData? { vm.services }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let data {
                    ForEach(data.services) { svc in
                        serviceCard(svc)
                    }
                    bookingCard(data)
                } else {
                    EmptyStateView(systemImage: "graduationcap.fill", message: L("common.loading"))
                        .padding(.top, 60)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("services.title"))
        .navigationBarTitleDisplayMode(.large)
    }

    private func serviceCard(_ svc: ServiceItem) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Palette.gold.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: svc.icon)
                        .font(.title3)
                        .foregroundStyle(Palette.gold)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(svc.name(for: lang))
                        .font(AppTheme.headingFont)
                        .foregroundStyle(Palette.ink)
                    Text(svc.description(for: lang))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineSpacing(3)
                }
                Spacer()
            }
            SourceChip(source: vm.source(for: svc.sourceId), lang: lang)
        }
        .premiumCard()
    }

    private func bookingCard(_ data: ServicesData) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.plus").foregroundStyle(Palette.gold)
                Text(data.whatsappDisplay(for: lang))
                    .font(AppTheme.headingFont)
                    .foregroundStyle(Palette.ink)
            }
            Text(L("services.bookHint"))
                .font(AppTheme.captionFont)
                .foregroundStyle(.secondary)
            Button { openWhatsApp(data.whatsapp) } label: {
                Label(L("services.book"), systemImage: "bubble.left.and.bubble.right.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.goldGradient, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .premiumCard()
    }

    private func openWhatsApp(_ number: String) {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        let intl = cleaned.hasPrefix("966") ? cleaned : "966\(cleaned)"
        if let url = URL(string: "https://wa.me/\(intl)") {
            UIApplication.shared.open(url)
        }
    }
}
