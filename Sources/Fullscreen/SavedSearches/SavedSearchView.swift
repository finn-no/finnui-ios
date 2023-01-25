import SwiftUI

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
                    .finnFont(.detailStrong)
                    .foregroundColor(.btnAction)
                    .lineLimit(1)
            }
            .padding(.spacingM)

            Spacer()

            Button {
                overflowButtonAction()
            } label: {
                Image(uiImage: UIImage(named: .overflowMenuHorizontal))
            }
            .padding([.trailing], .spacingM)
        }
        .background(Color.bgPrimary)
    }
}

struct SavedSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchView(savedSearch: .init(title: "iPod classic", text: "På FINN.no, E-post og Push-varsling"), overflowButtonAction: {})
    }
}
