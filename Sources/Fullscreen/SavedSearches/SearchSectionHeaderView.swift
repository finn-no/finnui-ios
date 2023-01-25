import SwiftUI

struct SearchSectionHeaderView: View {
    let text: String

    var body: some View {
        Text(text)
            .foregroundColor(.textSecondary)
            .finnFont(.detailStrong)
            .padding([.leading], .spacingM)
            .padding([.bottom], .spacingS)

    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SearchSectionHeaderView(text: "EIENDOM")
    }
}
