
import UIKit
import SnapKit

final class WeatherViewController: UIViewController {
    
    var presenter: WeatherPresenterProtocol?
    
    private let weatherView = CurrentWeatherView()
    private let hourlyView = HourlyForecastView()
    private let dailyView = DailyForecastView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        configure()
        setupConstraints()
        
//        presenter?.fetchWeather()
    }
}

extension WeatherViewController {
    private func setupView() {
        view.backgroundColor = .blue.withAlphaComponent(0.6)
        view.addSubview(weatherView)
        view.addSubview(hourlyView)
        view.addSubview(dailyView)
    }
    
    private func configure() {}
    
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

extension WeatherViewController: WeatherProtocol {
    func success(currentWeather: CurrentWeatherModel, forecast: [DailyWeatherModel]) {
        self.weatherView.configure(model: currentWeather)
        
        let dataHour = forecast[0]
        var array = [HourlyForecast]()
        for i in 12...20 {
            let forecastData =
            HourlyForecast(time: dataHour.hour?[i].time ?? "00",
                           icon: UIImage(systemName: "sun.max.fill"),
                           temperature: "\(dataHour.hour?[i].temp_c ?? 10)",
                           precipitation: "\(dataHour.hour?[i].chance_of_rain ?? 50)")
            array.append(forecastData)
        }
        
        
        let dataWeek = forecast
        var weekArray = [DailyForecast]()
        for i in 0...2 {
            let data = DailyForecast(day: dataWeek[i].date,
                                     icon: UIImage(systemName: "cloud.sun.fill"),
                                     temperatureMax: dataWeek[i].day.maxtemp_c,
                                     temperatureMin: dataWeek[i].day.mintemp_c,
                                     willRain: false)
            weekArray.append(data)
        }
        self.hourlyView.configure(with: array)
        self.dailyView.configure(with: weekArray)
    }
    
    func error(error: Error) {
        print("Error", error.localizedDescription)
    }
}
