import SwiftUI

struct TimelineView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }
    private var items: [TimelineItem] { vm.timeline }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if items.isEmpty {
                    EmptyStateView(systemImage: "clock.arrow.circlepath",
                                   message: L("timeline.empty"))
                        .padding(.top, 60)
                } else {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        timelineRow(item, isLast: index == items.count - 1)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("timeline.title"))
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private func timelineRow(_ item: TimelineItem, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 14) {
            // Marker column
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Palette.gold)
                        .frame(width: 16, height: 16)
                    if item.featured == true {
                        Circle()
                            .stroke(Palette.gold.opacity(0.4), lineWidth: 4)
                            .frame(width: 26, height: 26)
                    }
                }
                if !isLast {
                    Rectangle()
                        .fill(LinearGradient(colors: [Palette.gold.opacity(0.6), Palette.gold.opacity(0.15)],
                                             startPoint: .top, endPoint: .bottom))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 26)

            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.year.isEmpty ? "—" : item.year)
                        .font(AppTheme.monoCaption)
                        .foregroundStyle(Palette.gold)
                    if item.featured == true {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Palette.gold)
                    }
                    if item.verified {
                        VerifiedBadge()
                    }
                }
                Text(item.title(for: lang))
                    .font(AppTheme.headingFont)
                    .foregroundStyle(Palette.ink)
                Text(item.description(for: lang))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineSpacing(4)
                SourceChip(source: vm.source(for: item.sourceId), lang: lang)
                    .padding(.top, 2)
            }
            .padding(.bottom, 22)
        }
    }
}
