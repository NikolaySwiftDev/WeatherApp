import UIKit

protocol BuilderProtocol: AnyObject {
    func createWeatherVC(router: RouterMainProtocol) -> UIViewController
}

class Builder: BuilderProtocol {
    
    //MARK: - Create Weather VC
    func createWeatherVC(router: RouterMainProtocol) -> UIViewController {
        let view = WeatherViewController()
        let network = WeatherManager()
        let location = LocationManager()
        let presenter = WeatherPresenter(view: view, network: network, location: location, router: router)
        view.presenter = presenter
        return view
    }
}

