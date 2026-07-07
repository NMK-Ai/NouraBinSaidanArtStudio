import SwiftUI

struct ProductsView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }
    private var data: ProductsData? { vm.products }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let data {
                    noteBanner(data.note(for: lang))
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                        ForEach(data.products) { p in
                            ProductCard(product: p, currency: data.currency)
                        }
                    }
                    visitStoreButton(url: data.storeUrl)
                } else {
                    EmptyStateView(systemImage: "storefront", message: L("common.loading"))
                        .padding(.top, 60)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("products.title"))
        .navigationBarTitleDisplayMode(.large)
    }

    private func noteBanner(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "info.circle.fill").foregroundStyle(Palette.gold)
            Text(text).font(AppTheme.captionFont).foregroundStyle(.secondary)
            Spacer()
        }
        .padding(12)
        .background(Palette.gold.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func visitStoreButton(url: String) -> some View {
        Button { LinkOpener.open(url) } label: {
            Label(L("products.buy"), systemImage: "cart.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(AppTheme.goldGradient, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

struct ProductCard: View {
    let product: Product
    let currency: String
    @EnvironmentObject private var loc: LocalizationManager
    private var lang: AppLanguage { loc.language }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                ArtImage(assetName: product.image ?? "", fallbackColor: Palette.placeholder(named: product.placeholderColor))
                    .frame(height: 150)
                if !product.available {
                    Text(L("products.soldout"))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Capsule().fill(Palette.cocoa))
                        .padding(8)
                }
                Text(product.localizedTypeLabel)
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Capsule().fill(.black.opacity(0.35)))
                    .padding(8)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name(for: lang))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Palette.ink)
                    .lineLimit(2)
                Text(product.description(for: lang))
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                HStack {
                    Text(formattedPrice)
                        .font(.headline)
                        .foregroundStyle(Palette.gold)
                    Spacer()
                    Button { LinkOpener.open(product.buyUrl) } label: {
                        Image(systemName: "arrow.up.right.square.fill")
                            .font(.title3)
                            .foregroundStyle(Palette.bourbon)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text(L("common.openLink")))
                }
                .padding(.top, 2)
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var formattedPrice: String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = lang == .arabic ? Locale(identifier: "ar_SA") : Locale(identifier: "en_US")
        nf.maximumFractionDigits = 0
        let symbol = L("products.sar")
        let value = nf.string(from: NSNumber(value: product.price)) ?? "\(Int(product.price))"
        return "\(value) \(symbol)"
    }
}
