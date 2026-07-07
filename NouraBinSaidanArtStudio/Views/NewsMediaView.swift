import SwiftUI

struct NewsMediaView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }

    /// Curated, verified news/media items. Each links to its verifiable source.
    private var newsItems: [NewsItem] {
        [
            NewsItem(
                id: "news-timcook",
                titleAr: "تيم كوك يزور جدارية نورة في حي جاكس",
                titleEn: "Tim Cook visits Noura's mural at JAX District",
                dateAr: "ديسمبر 2024",
                dateEn: "December 2024",
                summaryAr: "الرئيس التنفيذي لشركة Apple يزور جداريتها بالدرعية ويتحدث عن استخدام أدوات Apple في الفن.",
                summaryEn: "Apple's CEO visits her mural in Diriyah and discusses using Apple tools in art.",
                sourceId: "src-timcook",
                icon: "apple.logo"
            ),
            NewsItem(
                id: "news-medal",
                titleAr: "تكريم بوسام الفنون والآداب الفرنسي برتبة فارس",
                titleEn: "Knighted with the French Order of Arts and Letters",
                dateAr: "يوليو 2024",
                dateEn: "July 2024",
                summaryAr: "منحها الرئيس ماكرون الوسام في السفارة الفرنسية بالرياض، ووصفت بأنها أول رسامة غرافيتي سعودية تناله.",
                summaryEn: "President Macron awarded her the medal at the French Embassy in Riyadh; described as the first Saudi graffiti artist to receive it.",
                sourceId: "src-spa",
                icon: "rosette"
            ),
            NewsItem(
                id: "news-arabnews",
                titleAr: "Arab News: انطباع عالمي لفنانة الشارع السعودية",
                titleEn: "Arab News: Saudi street artist making an international impression",
                dateAr: "تقرير",
                dateEn: "Feature",
                summaryAr: "ملف عن رحلتها الإبداعية ودافعها لتوثيق التراث السعودي عبر الجداريات.",
                summaryEn: "A feature on her creative journey and drive to document Saudi heritage through murals.",
                sourceId: "src-arabnews",
                icon: "newspaper.fill"
            ),
            NewsItem(
                id: "news-boulevard",
                titleAr: "اندبندنت عربية: 16 جدارية في بوليفارد الرياض",
                titleEn: "Independent Arabia: 16 murals at Riyadh Boulevard",
                dateAr: "تقرير",
                dateEn: "Feature",
                summaryAr: "تقرير عن جدارياتها الواسعة لشخصيات فنية بارزة ضمن موسم الرياض.",
                summaryEn: "A report on her large-scale murals of prominent artists during Riyadh Season.",
                sourceId: "src-independent",
                icon: "paintbrush.pointed"
            ),
            NewsItem(
                id: "news-grazia",
                titleAr: "Grazia ME: أول فنانة جداريات سعودية",
                titleEn: "Grazia ME: First Saudi female mural artist",
                dateAr: "ملف",
                dateEn: "Profile",
                summaryAr: "ملف صحفي يتناول مسيرتها وتعاونها مع Adidas.",
                summaryEn: "A press profile covering her journey and Adidas collaboration.",
                sourceId: "src-grazia",
                icon: "person.fill.viewfinder"
            )
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(L("news.intro"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                ForEach(newsItems) { item in
                    newsCard(item)
                }
            }
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("news.title"))
        .navigationBarTitleDisplayMode(.large)
    }

    private func newsCard(_ item: NewsItem) -> some View {
        let source = vm.source(for: item.sourceId)
        return Button { if let s = source { LinkOpener.open(s.url) } } label: {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Palette.gold.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: item.icon == "apple.logo" ? "apple.logo" : item.icon)
                        .foregroundStyle(Palette.gold)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(lang == .arabic ? item.titleAr : item.titleEn)
                        .font(AppTheme.headingFont)
                        .foregroundStyle(Palette.ink)
                        .multilineTextAlignment(.leading)
                    Text(lang == .arabic ? item.dateAr : item.dateEn)
                        .font(AppTheme.monoCaption)
                        .foregroundStyle(Palette.gold)
                    Text(lang == .arabic ? item.summaryAr : item.summaryEn)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineSpacing(3)
                        .multilineTextAlignment(.leading)
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.right.square.fill").font(.system(size: 11))
                        Text(source?.label(for: lang) ?? L("common.source"))
                            .font(AppTheme.captionFont.weight(.medium))
                    }
                    .foregroundStyle(Palette.bourbon)
                    .padding(.top, 2)
                }
                Spacer()
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

private struct NewsItem: Identifiable {
    let id: String
    let titleAr: String
    let titleEn: String
    let dateAr: String
    let dateEn: String
    let summaryAr: String
    let summaryEn: String
    let sourceId: String
    let icon: String
}
