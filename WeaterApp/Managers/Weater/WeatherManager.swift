import Foundation

// MARK: - Protocol
protocol WeatherManagerProtocol: AnyObject {
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<CurrentWeatherModel, Error>) -> Void)
    func fetchDailyForecast(lat: Double, lon: Double, completion: @escaping (Result<[DailyWeatherModel], Error>) -> Void)
    func fetchFullWeather(lat: Double, lon: Double, completion: @escaping (Result<(CurrentWeatherModel, [DailyWeatherModel]), Error>) -> Void)
}

class WeatherManager: WeatherManagerProtocol {
    
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"
    private let session = URLSession.shared

    // MARK: - Fetch Current Weather
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<CurrentWeatherModel, Error>) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(lat),\(lon)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }

        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 1)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Fetch Daily Forecast (hour, 7 days (Free api get only 3 days))
    func fetchDailyForecast(lat: Double, lon: Double, completion: @escaping (Result<[DailyWeatherModel], Error>) -> Void) {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=7"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }

        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 2)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(ForecastWeatherWrapper.self, from: data)
                completion(.success(decoded.forecast.forecastday))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Fetch Full Weather
    func fetchFullWeather(lat: Double, lon: Double, completion: @escaping (Result<(CurrentWeatherModel, [DailyWeatherModel]), Error>) -> Void) {

        let group = DispatchGroup()
        
        var currentResult: CurrentWeatherModel?
        var forecastResult: [DailyWeatherModel]?
        var errorResult: Error?

        group.enter()
        fetchCurrentWeather(lat: lat, lon: lon) { result in
            switch result {
            case .success(let current): currentResult = current
            case .failure(let error): errorResult = error
            }
            group.leave()
        }

        group.enter()
        fetchDailyForecast(lat: lat, lon: lon) { result in
            switch result {
            case .success(let forecast): forecastResult = forecast
            case .failure(let error): errorResult = error
            }
            group.leave()
        }

        group.notify(queue: .main) {
            if let error = errorResult {
                completion(.failure(error))
            } else if let current = currentResult, let forecast = forecastResult {
                completion(.success((current, forecast)))
            } else {
                completion(.failure(NSError(domain: "UnknownError", code: 999)))
            }
        }
    }
}
