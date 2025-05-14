
import Foundation

struct CurrentWeatherModel: Decodable {
    let location: Location
    let current: Current

    struct Location: Decodable {
        let name: String
        let region: String
        let country: String
        let lat: Double
        let lon: Double
        let tz_id: String
        let localtime: String
    }

    struct Current: Decodable {
        let temp_c: Double
        let pressure_mb: Double
        let feelslike_c: Double
        let humidity: Int
        let wind_kph: Double
        let condition: Condition
    }

    struct Condition: Decodable {
        let text: String
        let icon: String
    }
}


struct ForecastWeatherWrapper: Decodable {
    let forecast: ForecastContainer
}

struct ForecastContainer: Decodable {
    let forecastday: [DailyWeatherModel]
}

struct DailyWeatherModel: Decodable {
    let date: String
    let day: Day
    let hour: [Hour]?

    struct Day: Decodable {
        let maxtemp_c: Double
        let mintemp_c: Double
        let condition: CurrentWeatherModel.Condition
        let daily_chance_of_rain: Int
    }

    struct Hour: Decodable {
        let time: String
        let temp_c: Double
        let chance_of_rain: Int
        let condition: CurrentWeatherModel.Condition
    }
}
