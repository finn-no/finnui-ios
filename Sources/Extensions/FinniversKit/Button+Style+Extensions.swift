import FinniversKit

extension Button.Style {
    func override(using styling: RealestateSoldStateModel.Styling.ButtonStyle, isHighlighted: Bool) -> Button.Style {
        let backgroundColor = isHighlighted ? styling.backgroundActiveColor : styling.backgroundColor

        return overrideStyle(
            bodyColor: backgroundColor,
            borderColor: styling.borderColor,
            textColor: styling.textColor
        )
    }
}
