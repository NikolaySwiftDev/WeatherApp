
import UIKit
import SnapKit

final class WeatherViewController: UIViewController {
    
    var presenter: WeatherPresenterProtocol?
    
    private let weatherView = CurrentWeatherView()
    private let hourlyView = HourlyForecastView()
    private let dailyView = DailyForecastView()
    
    private let backView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loader = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure()
        setupConstraints()
    }
}

extension WeatherViewController {
    private func setupView() {
        view.addSubview(weatherView)
        view.addSubview(hourlyView)
        view.addSubview(dailyView)
        view.addSubview(backView)
        view.addSubview(loader)
    }
    
    private func configure() {
        view.backgroundColor = .blue.withAlphaComponent(0.6)
        loader.startAnimating()
    }
    
    private func setupConstraints() {
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
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

extension WeatherViewController: WeatherProtocol {
    func success(currentWeather: CurrentWeatherModel, forecast: [DailyWeatherModel], hourArray: [DailyWeatherModel.Hour] ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.weatherView.configure(model: currentWeather)
            self.hourlyView.configure(with: hourArray)
            self.dailyView.configure(with: forecast)
            
            self.loader.stopAnimating()
            self.loader.removeFromSuperview()
            self.backView.removeFromSuperview()
        }
    }
    
    func error(error: Error) {
        print("Error", error.localizedDescription)
    }
}
