import UIKit

@MainActor
class AsyncAlertPresenter<T> {
    private let alertModel: AlertModel<T>
    private typealias AlertCheckedContinuation = CheckedContinuation<T, Never>
    private var alertCheckedThrowingContinuation: AlertCheckedContinuation?

    init(alertModel: AlertModel<T>) {
        self.alertModel = alertModel
    }

    func presentAlert(from viewController: UIViewController) async -> T {
        return await withCheckedContinuation { [weak self] (continuation: AlertCheckedContinuation) in
            guard let self = self else {
                return
            }

            self.alertCheckedThrowingContinuation = continuation

            let alertController = UIAlertController(
                title: alertModel.title,
                message: alertModel.message,
                preferredStyle: alertModel.prefferedStyle
            )
            alertModel.actionModels.forEach { action in
                alertController.addAction(
                    UIAlertAction(
                        title: action.title,
                        style: action.style,
                        handler: { currentAction in
                            self.alertCheckedThrowingContinuation?.resume(returning: action.value)
                            self.alertCheckedThrowingContinuation = nil
                        }
                    )
                )
            }
            viewController.present(alertController, animated: true)
        }
    }
}

