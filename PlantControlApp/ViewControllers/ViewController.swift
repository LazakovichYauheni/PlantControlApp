import UIKit

final class ViewController: UIViewController {
    // MARK: - Private Properties
    
    private let startView = StartView()
    private let childViewController = ModalViewController()
    private let presenter = Presenter()
    
    // MARK: - UIViewController
    
    override func loadView() {
        startView.configure(with: .init(
            rows: presenter.createModels(selectedIndex: .zero, isNewPlant: false),
            data: presenter.getSelectedModel(),
            isInitialState: true
        ))
        view = startView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startView.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func presentActivityIndicator() {
        let activityIndicatorController = ActivityIndicatorViewController()
        activityIndicatorController.modalPresentationStyle = .overFullScreen
        present(activityIndicatorController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            activityIndicatorController.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - StartViewEventsRespondable

extension ViewController: StartViewEventsRespondable {
    func didPlantChanged(index: Int) {
        presenter.isExpanded.toggle()
        startView.configure(with: .init(
            rows: presenter.createModels(selectedIndex: index, isNewPlant: false),
            data: presenter.getSelectedModel(),
            isInitialState: false
        ))
    }
    
    func didAddButtonTapped() {
        childViewController.delegate = self
        childViewController.modalPresentationStyle = .pageSheet
        childViewController.wifiPlants = presenter.initModalArray()
        present(childViewController, animated: true)
    }
}

// MARK: - ModaViewControllerEvents

extension ViewController: ModalViewControllerEvents {
    func didCellTapped(name: String) {
        childViewController.dismiss(animated: true, completion: nil)
        
        presenter.createNewPlant(name: name)
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.startView.configure(with: .init(
                rows: self.presenter.createModels(selectedIndex: .zero, isNewPlant: true),
                data: self.presenter.getSelectedModel(),
                isInitialState: false
            ))
        }
        
        presentActivityIndicator()
    }
}
