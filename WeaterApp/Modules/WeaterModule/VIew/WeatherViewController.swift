
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
            make.height.equalTo(250)
        }
        
        hourlyView.snp.makeConstraints { make in
            make.top.equalTo(weatherView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(150)
        }
        
        dailyView.snp.makeConstraints { make in
            make.top.equalTo(hourlyView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(260)
        }
    }
}

extension WeatherViewController: WeatherProtocol {
    func success(currentWeather: CurrentWeatherModel, forecast: [DailyWeatherModel], hourArray: [DailyWeatherModel.Hour] ) {
        self.weatherView.configure(model: currentWeather)
        self.hourlyView.configure(with: hourArray)
        self.dailyView.configure(with: forecast)
    }
    
    func error(error: Error) {
        print("Error", error.localizedDescription)
    }
}
