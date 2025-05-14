
import Foundation

//MARK: - Weather Protocol
protocol WeatherProtocol: AnyObject {
    func success(currentWeather: CurrentWeatherModel, forecast: [DailyWeatherModel], hourArray: [DailyWeatherModel.Hour])
    func error(error: Error)
}

//MARK: - Weather Presenter Protocol
protocol WeatherPresenterProtocol: AnyObject {
    var currentWeather: CurrentWeatherModel? { get set }
    var forecastWeather: [DailyWeatherModel]? { get set }
    var hourArrayWeather: [DailyWeatherModel.Hour]? { get set }
    func fetchWeather()
    init(view: WeatherProtocol, network: WeatherManager, location: LocationManager, router: RouterMainProtocol)
}

class WeatherPresenter: WeatherPresenterProtocol {
    
    //MARK: - Properties
    weak var view: WeatherProtocol?
    var currentWeather: CurrentWeatherModel?
    var forecastWeather: [DailyWeatherModel]?
    var hourArrayWeather: [DailyWeatherModel.Hour]?
    let network: WeatherManager?
    let location: LocationManager?
    let router: RouterMainProtocol?
    
    //MARK: - Init
    required init(view: WeatherProtocol, network: WeatherManager, location: LocationManager, router: RouterMainProtocol) {
        self.view = view
        self.network = network
        self.location = location
        self.router = router
        self.location?.delegate = self
    }
    
    //MARK: - Fetch Full Weather
    func fetchWeather() {
        guard let lat = location?.latitude, let lon = location?.longitude else { return }
        network?.fetchFullWeather(lat: lat, lon: lon) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let (current, forecast)):
                currentWeather = current
                forecastWeather = forecast
                hourArrayWeather = getDailyWeatherHour(forecast: forecast)
                view?.success(currentWeather: current, forecast: forecast, hourArray: getDailyWeatherHour(forecast: forecast))
            case .failure(let failure):
                view?.error(error: failure)
                router?.showErrorAlert(error: failure.localizedDescription) { [weak self] in
                    guard let self = self else { return }
                    self.didUpdateLocation()
                }
            }
        }
    }
    
    //MARK: - Get Daily Weather Hour Array
    func getDailyWeatherHour(forecast: [DailyWeatherModel]) -> [DailyWeatherModel.Hour] {
        var result: [DailyWeatherModel.Hour] = []

        let currentHour = Calendar.current.component(.hour, from: Date())
        guard forecast.count >= 2,
              let todayHours = forecast[0].hour,
              let tomorrowHours = forecast[1].hour else {
            return []
        }

        let todayRemainingHours = todayHours.filter { hourEntry in
            guard let hourString = hourEntry.time.split(separator: " ").last,
                  let hourComponent = Int(hourString.prefix(2)) else {
                return false
            }
            return hourComponent >= currentHour + 1
        }

        result.append(contentsOf: todayRemainingHours)
        result.append(contentsOf: tomorrowHours)

        
        return result
    }
    
    deinit {
        location?.delegate = nil
    }
}

//MARK: - Location Manager Delegate (update persmission)
extension WeatherPresenter: LocationManagerDelegate {
    func didUpdateLocation() {
        fetchWeather()
    }
}
