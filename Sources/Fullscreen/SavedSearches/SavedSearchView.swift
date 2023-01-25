import SwiftUI

struct SavedSearchView: View {
    @ObservedObject var savedSearch: SavedSearchViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(savedSearch.title)
                Text(savedSearch.text)
            }
            Spacer()
            Image(uiImage: UIImage(named: .overflowMenuHorizontal))
        }
    }
}

struct SavedSearchView_Previews: PreviewProvider {
    static var previews: some View {
        SavedSearchView(savedSearch: .init(title: "iPod classic", text: "På FINN.no, E-post og Push-varsling"))
    }
}
