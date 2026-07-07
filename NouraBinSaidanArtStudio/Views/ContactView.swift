import SwiftUI

struct ContactView: View {
    @EnvironmentObject private var vm: ContentViewModel
    @EnvironmentObject private var loc: LocalizationManager

    private var lang: AppLanguage { loc.language }
    @State private var name: String = ""
    @State private var message: String = ""

    private var personalAccounts: [SocialAccount] {
        vm.social.filter { $0.category == "personal" || $0.category == "studio" }
    }
    private var storeAccounts: [SocialAccount] {
        vm.social.filter { $0.category == "store" }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                accountsCard
                formCard
                legalCard
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .scrollIndicators(.hidden)
        .background(Palette.sand.opacity(0.25).ignoresSafeArea())
        .navigationTitle(L("contact.title"))
        .navigationBarTitleDisplayMode(.large)
    }

    private var accountsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(L("contact.accounts"))
            VStack(spacing: 10) {
                ForEach(personalAccounts) { acc in
                    Button { LinkOpener.open(acc.url) } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Palette.gold.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                Image(systemName: acc.icon).foregroundStyle(Palette.gold)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(acc.label(for: lang)).font(.subheadline.weight(.semibold)).foregroundStyle(Palette.ink)
                                Text(acc.handle).font(AppTheme.monoCaption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.left").foregroundStyle(.secondary).scaleEffect(x: loc.isRTL ? 1 : -1, y: 1)
                        }
                        .padding(10)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            if !storeAccounts.isEmpty {
                Divider().padding(.vertical, 4)
                ForEach(storeAccounts) { acc in
                    Button { LinkOpener.open(acc.url) } label: {
                        HStack(spacing: 12) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Palette.bourbon.opacity(0.15))
                                    .frame(width: 40, height: 40)
                                Image(systemName: acc.icon).foregroundStyle(Palette.bourbon)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text(acc.label(for: lang)).font(.subheadline.weight(.semibold)).foregroundStyle(Palette.ink)
                                Text(acc.handle).font(AppTheme.monoCaption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "arrow.up.right.square.fill").foregroundStyle(Palette.bourbon)
                        }
                        .padding(10)
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .premiumCard()
    }

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(L("contact.form"), subtitle: L("contact.formHint"))
            VStack(alignment: .leading, spacing: 10) {
                TextField(L("contact.name"), text: $name)
                    .textFieldStyle(.roundedBorder)
                TextEditor(text: $message)
                    .frame(minHeight: 90)
                    .padding(6)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        Group {
                            if message.isEmpty {
                                Text(L("contact.message"))
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 12).padding(.vertical, 12)
                                    .allowsHitTesting(false)
                            }
                        }
                    )
                    .font(.subheadline)
                Button { sendEmail() } label: {
                    Label(L("contact.send"), systemImage: "paperplane.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(AppTheme.goldGradient, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(!canSend)
                .opacity(canSend ? 1 : 0.5)
            }
        }
        .premiumCard()
    }

    private var legalCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let p = vm.profile {
                InfoRow(systemImage: "envelope.fill", label: L("contact.email"), value: p.email)
                InfoRow(systemImage: "doc.text.fill", label: L("common.media_license"), value: p.mediaLicense)
                InfoRow(systemImage: "scale.3d", label: L("common.legal"), value: p.legalRepresentative(for: lang))
            }
        }
        .premiumCard()
    }

    private var canSend: Bool {
        !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func sendEmail() {
        guard let p = vm.profile else { return }
        let subject = "Noura Bin Saidan Studio — App Inquiry"
        let body = "\(name)\n\n\(message)"
        let encoded = "mailto:\(p.email)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        if let url = URL(string: encoded) { UIApplication.shared.open(url) }
    }
}
