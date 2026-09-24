import SwiftUI

struct AppCard: View {

    let title: String
    var subtitle: String = ""
    var imageSystemName: String = "photo"
    var showChevron: Bool = true
    var subtitleLineLimit: Int?
    /// Remote image shown instead of `imageSystemName` once it loads.
    var imageURL: URL?

    private static let thumbnailSize: CGFloat = 50

    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            // Image
            thumbnail
                .frame(width: Self.thumbnailSize, height: Self.thumbnailSize)
                .background(AppTheme.Colors.primary.opacity(0.1))
                .clipShape(Circle())

            // Text Content
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(AppTheme.Fonts.caption)
                        .foregroundColor(AppTheme.Colors.textSecondary)
                        .lineLimit(subtitleLineLimit)
                        .multilineTextAlignment(.leading)
                }
            }

            Spacer()

            // Chevron
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Thumbnail

    @ViewBuilder
    private var thumbnail: some View {
        if let imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .empty:
                    ProgressView()
                default:
                    placeholderIcon
                }
            }
        } else {
            placeholderIcon
        }
    }

    private var placeholderIcon: some View {
        Image(systemName: imageSystemName)
            .font(.title2)
            .foregroundColor(AppTheme.Colors.primary)
    }
}

// MARK: - Preview

#Preview("App Card") {
    VStack(spacing: AppTheme.Spacing.md) {
        AppCard(
            title: "Persian",
            subtitle: "Calm and affectionate breed",
            imageSystemName: "cat"
        )

        AppCard(
            title: "Siamese",
            subtitle: "Vocal and social breed",
            imageSystemName: "cat.fill"
        )

        AppCard(
            title: "No Arrow",
            subtitle: "Card without chevron",
            imageSystemName: "pawprint.fill",
            showChevron: false
        )
    }
    .padding(AppTheme.Spacing.lg)
}
