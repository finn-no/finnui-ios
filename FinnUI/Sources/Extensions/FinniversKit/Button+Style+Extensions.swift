import FinniversKit

extension Button.Style {
    func override(using buttonStyle: CompanyProfile.ButtonStyle?) -> Button.Style {
        guard let buttonStyle = buttonStyle else { return self }

        return overrideStyle(
            bodyColor: buttonStyle.backgroundColor,
            borderColor: buttonStyle.borderColor,
            textColor: buttonStyle.textColor,
            highlightedBodyColor: buttonStyle.backgroundActiveColor
        )
    }
}
