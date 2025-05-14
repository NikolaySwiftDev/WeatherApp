
import Foundation
import UIKit

//MARK: - Router Main
protocol RouterMain {
    var navigationController: UINavigationController { get set }
    var builder: BuilderProtocol? { get set }
}

//MARK: - Router Main Protocol
protocol RouterMainProtocol: RouterMain {
    func initialViewController()
    func showErrorAlert(error: String, complition: @escaping()->())
}

class Router: RouterMainProtocol {
    //MARK: -
    var navigationController: UINavigationController
    var builder: BuilderProtocol?
    
    //MARK: - v
    init(navigationController: UINavigationController, builder: BuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    //MARK: - Initial View Controller
    func initialViewController() {
        guard let mainVC = builder?.createWeatherVC(router: self) else { return }
        navigationController.setViewControllers([mainVC], animated: true)
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Show alert
    func showErrorAlert(error: String, complition: @escaping () -> ()) {
        let alert = UIAlertController(title: error,
                                      message: nil,
                                      preferredStyle: .alert)
        let repeatAction = UIAlertAction(title: "Repeat",
                                         style: .default) { _ in
            complition()
        }
        alert.addAction(repeatAction)
        navigationController.present(alert, animated: true)
    }
}
