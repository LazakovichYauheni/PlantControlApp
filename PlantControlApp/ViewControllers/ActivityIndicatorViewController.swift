import Foundation
import UIKit

final class ActivityIndicatorViewController: UIViewController {
    // MARK: - Private Properties
    
    private let activityView = ActivityIndicatorView()
    
    // MARK: - UIViewController
    
    override func loadView() {
        view = activityView
    }
}
