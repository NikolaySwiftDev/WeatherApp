import UIKit

protocol BuilderProtocol: AnyObject {
    func createWeatherVC() -> UIViewController
}

class Builder: BuilderProtocol {
    func createWeatherVC() -> UIViewController {
        let view = WeatherViewController()
        let network = WeatherManager()
        let location = LocationManager()
        let presenter = WeatherPresenter(view: view, network: network, location: location)
        view.presenter = presenter
        return view
    }
}

