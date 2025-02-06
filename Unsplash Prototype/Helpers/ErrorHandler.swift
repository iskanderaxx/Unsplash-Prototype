
import UIKit

func handleError(_ error: ErrorModel, in viewController: UIViewController) {
    let alert = UIAlertController(title: "Error", message: showErrorMessage(for: error), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default))
    viewController.present(alert, animated: true)
}

private func showErrorMessage(for error: ErrorModel) -> String {
    switch error {
    case .invalidUrl:
        return "Invalid URL. Please check URL data."
    case .noData:
        return "No data. Please enter another query."
    case .fetchingFailure:
        return "Failed to upload images. Please try again."
    case .decodingFailure:
        return "Data processing error. Please try again."
    case .directoryNotFound:
        return "Directory not found. Please contact our Support Team."
    case .savingError:
        return "Error saving data. Please try again."
    }
}
