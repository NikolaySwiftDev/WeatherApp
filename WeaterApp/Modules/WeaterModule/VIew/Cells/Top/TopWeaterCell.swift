
import UIKit

class CurrentWeatherView: UIView {
    
    // MARK: - UI Elements
    
    private let cityLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let feelsLikeLabel = UILabel()
    
    private let weatherIconView = UIImageView()
    
    private let humidityLabel = UILabel()
    private let windLabel = UILabel()
    private let pressureLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        backgroundColor = UIColor.systemBlue
        layer.cornerRadius = 20
        clipsToBounds = true
        
        cityLabel.font = .boldSystemFont(ofSize: 22)
        cityLabel.textColor = .white
        
        dateLabel.font = .systemFont(ofSize: 16)
        dateLabel.textColor = .white
        
        temperatureLabel.font = .systemFont(ofSize: 64, weight: .thin)
        temperatureLabel.textColor = .white
        
        descriptionLabel.font = .systemFont(ofSize: 20)
        descriptionLabel.textColor = .white
        
        feelsLikeLabel.font = .systemFont(ofSize: 16)
        feelsLikeLabel.textColor = .white
        
        weatherIconView.contentMode = .scaleAspectFit
        weatherIconView.tintColor = .white
        
        humidityLabel.font = .systemFont(ofSize: 14)
        windLabel.font = .systemFont(ofSize: 14)
        pressureLabel.font = .systemFont(ofSize: 14)
        
        humidityLabel.textColor = .white
        windLabel.textColor = .white
        pressureLabel.textColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        let cityStack = UIStackView(arrangedSubviews: [cityLabel, dateLabel])
        cityStack.axis = .horizontal
        cityStack.distribution = .equalSpacing
        
        let tempStack = UIStackView(arrangedSubviews: [weatherIconView, temperatureLabel])
        tempStack.axis = .horizontal
        tempStack.spacing = 10
        tempStack.alignment = .center
        
        let infoStack = UIStackView(arrangedSubviews: [humidityLabel, windLabel, pressureLabel])
        infoStack.axis = .horizontal
        infoStack.spacing = 16
        infoStack.distribution = .equalCentering
        
        let mainStack = UIStackView(arrangedSubviews: [cityStack, tempStack, descriptionLabel, feelsLikeLabel, infoStack])
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            weatherIconView.widthAnchor.constraint(equalToConstant: 50),
            weatherIconView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(model: CurrentWeatherModel) {
        cityLabel.text = model.location.name
        dateLabel.text = model.location.localtime
        temperatureLabel.text = "\(model.current.temp_c) °C"
        descriptionLabel.text = model.current.condition.text
        feelsLikeLabel.text = "Feels like \(model.current.feelslike_c) °C"
        weatherIconView.image = UIImage(systemName: model.current.condition.icon) ?? UIImage(systemName: "sun.max.fill")
        humidityLabel.text = "💧 \(model.current.humidity) %"
        windLabel.text = "💨 \(model.current.wind_kph) km/h"
        pressureLabel.text = "🧭 \(Int(model.current.pressure_mb)) mb"
    }
}
