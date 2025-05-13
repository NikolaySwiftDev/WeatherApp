import Foundation

//"https://api.weatherapi.com/v1/current.json?key=fa8b3df74d4042b9aa7135114252304&q=59.9375,30.3086"

class WeatherManager {
    
    static let shared = WeatherManager()
    
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"
//    private let apiKey = "8c84bfc0b5ec42c3ab0142721251305"
    private let session = URLSession.shared

    // MARK: - 1. Только текущая погода
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

    // MARK: - 2. Только прогноз (включает и по часам, и на 7 дней)
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

    // MARK: - 3. Общий метод (текущая + прогноз)
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
