
import UIKit

struct HourlyForecast {
    let time: String
    let icon: UIImage?
    let temperature: String
    let precipitation: String
}

struct DailyForecast {
    let day: String
    let icon: UIImage?
    let temperatureMax: Double
    let temperatureMin: Double
    let willRain: Bool
}
