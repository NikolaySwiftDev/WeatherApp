
import UIKit
import SnapKit

final class WeatherViewController: UIViewController {
    
    private let weatherView = CurrentWeatherView()
    private let hourlyView = HourlyForecastView()
    private let dailyView = DailyForecastView()

    override func viewDidLoad() {
        super.viewDidLoad()

        WeatherManager.shared.fetchFullWeather(lat: 59.9375, lon: 30.3086) { result in
            switch result {
            case .success(let (current, forecast)):
                self.weatherView.configure(model: current)
                let data = forecast[0]
                var array = [HourlyForecast]()
                for i in 12...20 {
                
                    let forecastData =
                        HourlyForecast(time: data.hour?[i].time ?? "00",
                                       icon: UIImage(systemName: "sun.max.fill"),
                                       temperature: "\(data.hour?[i].temp_c ?? 10)",
                                       precipitation: "\(data.hour?[i].chance_of_rain ?? 50)")
                    array.append(forecastData)
                }
                self.hourlyView.configure(with: array)
                print("Завтра: \(forecast[1].day.maxtemp_c)°C / \(forecast[1].day.mintemp_c)°C")
            case .failure(let error):
                print("Ошибка получения погоды: \(error)")
            }
        }

        setupView()
        configure()
        setupConstraints()
    }
}

extension WeatherViewController {
    private func setupView() {
        view.backgroundColor = .blue.withAlphaComponent(0.6)
        view.addSubview(weatherView)
        view.addSubview(hourlyView)
        view.addSubview(dailyView)
    }
    
    private func configure() {
 
        let data = [
            DailyForecast(day: "Пн", icon: UIImage(systemName: "cloud.sun.fill"), temperature: "+17° / +25°", willRain: false),
            DailyForecast(day: "Вт", icon: UIImage(systemName: "cloud.rain.fill"), temperature: "+16° / +22°", willRain: true),
            DailyForecast(day: "Ср", icon: UIImage(systemName: "cloud.sun.fill"), temperature: "+17° / +25°", willRain: false),
            DailyForecast(day: "Чт", icon: UIImage(systemName: "cloud.rain.fill"), temperature: "+16° / +22°", willRain: true),
            DailyForecast(day: "Пт", icon: UIImage(systemName: "cloud.sun.fill"), temperature: "+17° / +25°", willRain: false),
            DailyForecast(day: "Сб", icon: UIImage(systemName: "cloud.rain.fill"), temperature: "+16° / +22°", willRain: true),
            DailyForecast(day: "Вс", icon: UIImage(systemName: "cloud.rain.fill"), temperature: "+16° / +22°", willRain: true),
        ]
        
        dailyView.configure(with: data)
    }
    
    private func setupConstraints() {
        weatherView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(220)
        }
        
        hourlyView.snp.makeConstraints { make in
            make.top.equalTo(weatherView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(150)
        }
        
        dailyView.snp.makeConstraints { make in
            make.top.equalTo(hourlyView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
