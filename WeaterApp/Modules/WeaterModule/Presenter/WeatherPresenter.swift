
import Foundation

protocol WeatherProtocol: AnyObject {
    func success(currentWeather: CurrentWeatherModel, forecast: [DailyWeatherModel], hourArray: [DailyWeatherModel.Hour])
    func error(error: Error)
}

protocol WeatherPresenterProtocol: AnyObject {
    var currentWeather: CurrentWeatherModel? { get set }
    var forecastWeather: [DailyWeatherModel]? { get set }
    var hourArrayWeather: [DailyWeatherModel.Hour]? { get set }
    func fetchWeather()
    init(view: WeatherProtocol, network: WeatherManager, location: LocationManager)
}

class WeatherPresenter: WeatherPresenterProtocol {
    
    weak var view: WeatherProtocol?
    var currentWeather: CurrentWeatherModel?
    var forecastWeather: [DailyWeatherModel]?
    var hourArrayWeather: [DailyWeatherModel.Hour]?
    let network: WeatherManager?
    let location: LocationManager?
    
    required init(view: WeatherProtocol, network: WeatherManager, location: LocationManager) {
        self.view = view
        self.network = network
        self.location = location
        self.location?.delegate = self
    }
    
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
            }
        }
    }
    
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

extension WeatherPresenter: LocationManagerDelegate {
    func didUpdateLocation() {
        fetchWeather()
    }
}
