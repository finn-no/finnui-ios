import FinniversKit

extension Button.Style {
    func override(using styling: RealestateSoldStateModel.Styling.ButtonStyle) -> Button.Style {
        overrideStyle(
            bodyColor: styling.backgroundColor,
            borderColor: styling.borderColor,
            textColor: styling.textColor,
            highlightedBodyColor: styling.backgroundActiveColor
        )
    }
}
