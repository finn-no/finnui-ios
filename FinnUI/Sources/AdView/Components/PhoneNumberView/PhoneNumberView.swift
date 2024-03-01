//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

struct PhoneNumberView: View {
    let viewModel: PhoneNumberViewModel
    @SwiftUI.State var showPhoneNumber: Bool = false
    var contact: (() -> Void) = {}

    var buttonTitle: String {
        showPhoneNumber ? viewModel.phoneNumber : viewModel.revealTitle
    }

    var body: some View {
        HStack {
            Text(viewModel.sectionTitle)
                .finnFont(.body)
                .foregroundColor(.textSecondary)

            Spacer()

            Button(buttonTitle, action: togglePhoneNumber)
                .buttonStyle(InlineFlatStyle())
        }
        .padding(.vertical, .spacingS)
    }

    private func togglePhoneNumber() {
        if showPhoneNumber {
            contact()
        } else {
            showPhoneNumber = true
        }
    }
}

//swiftlint:disable:next type_name superfluous_disable_command
struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhoneNumberView(viewModel: .sampleData)

            PhoneNumberView(viewModel: .sampleData, showPhoneNumber: true)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
