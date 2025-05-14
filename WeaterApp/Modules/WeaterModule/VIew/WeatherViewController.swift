
import UIKit
import SnapKit

final class WeatherViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: WeatherPresenterProtocol?
    private lazy var weatherView = CurrentWeatherView()
    private lazy var hourlyView = HourlyForecastView()
    private lazy var dailyView = DailyForecastView()
    private let backView = LottieView(animationName: "loading")
        
    //MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure()
        setupConstraints()
    }
}

//MARK: - Weather Protocol
extension WeatherViewController: WeatherProtocol {
    func success(currentWeather: CurrentWeatherModel, forecast: [DailyWeatherModel], hourArray: [DailyWeatherModel.Hour] ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.weatherView.configure(model: currentWeather)
            self.hourlyView.configure(with: hourArray)
            self.dailyView.configure(with: forecast) 
            self.backView.stop()
            self.backView.removeFromSuperview()
        }
    }
    
    func error(error: Error) {
        print("Error", error.localizedDescription)
    }
}

extension WeatherViewController {
    
    //MARK: - Setup View
    private func setupView() {
        view.addSubview(weatherView)
        view.addSubview(hourlyView)
        view.addSubview(dailyView)
        view.addSubview(backView)
    }
    
    //MARK: - Configure
    private func configure() {
        view.backgroundColor = .blue.withAlphaComponent(0.6)
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(300)
        }

        weatherView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(250)
        }
        
        hourlyView.snp.makeConstraints { make in
            make.top.equalTo(weatherView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(130)
        }
        
        dailyView.snp.makeConstraints { make in
            make.top.equalTo(hourlyView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(260)
        }
    }
}
