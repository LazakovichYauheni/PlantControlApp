import Foundation
import UIKit

protocol ModalViewControllerEvents: NSObject {
    func didCellTapped(name: String)
}

final class ModalViewController: UIViewController {
    // MARK: - Public Properties
    
    weak var delegate: ModalViewControllerEvents?
    let backingView = ModalView()
    var wifiPlants: [String] = []
    
    // MARK: - UIViewController
    
    override func loadView() {
        backingView.delegate = self
        backingView.configure(with: wifiPlants)
        view = backingView
    }
}

// MARK: - ModalViewEventsRespondable

extension ModalViewController: ModalViewEventsRespondable {
    func didCellTapped(name: String) {
        delegate?.didCellTapped(name: name)
    }
}
