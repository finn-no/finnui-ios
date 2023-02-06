import SwiftUI
import FinniversKit

struct SavedSearchView: View {
    @ObservedObject var savedSearch: SavedSearchViewModel
    var overflowButtonAction: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(savedSearch.title)
                    .finnFont(.bodyStrong)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                Text(savedSearch.text)
                    .finnFont(textStyle)
                    .foregroundColor(textColor)
                    .lineLimit(1)
            }
            .padding(.spacingM)

            Spacer()

            Button {
                overflowButtonAction()
            } label: {
                Image(uiImage: UIImage(named: .overflowMenuHorizontal))
                    .frame(width: .minimumTargetSize, height: .minimumTargetSize)
            }
            .padding([.trailing], .spacingS)
        }
        .background(Color.bgPrimary)
    }

    private var textStyle: FinniversKit.Label.Style {
        switch savedSearch.textStyle {
        case .active: return .detailStrong
        case .inactive: return .detail
        }
    }

    private var textColor: Color {
        switch savedSearch.textStyle {
        case .active: return .btnAction
        case .inactive: return .textSecondary
        }
    }
}

struct SavedSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchView(savedSearch: .init(title: "iPod classic", text: "På FINN.no, E-post og Push-varsling", textStyle: .active), overflowButtonAction: {})
    }
}
