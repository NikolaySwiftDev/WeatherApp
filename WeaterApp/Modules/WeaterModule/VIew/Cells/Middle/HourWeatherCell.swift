

import UIKit
import SnapKit

class HourlyForecastCellView: UIView {

    private let timeLabel = UILabel()
    private let iconView = UIImageView()
    private let temperatureLabel = UILabel()
    private let precipitationLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        clipsToBounds = true

        timeLabel.font = .systemFont(ofSize: 16, weight: .bold)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center

        iconView.contentMode = .scaleAspectFill
        iconView.tintColor = .white

        temperatureLabel.font = .boldSystemFont(ofSize: 16)
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .center

        precipitationLabel.font = .systemFont(ofSize: 12)
        precipitationLabel.textColor = .cyan
        precipitationLabel.textAlignment = .center

        addSubview(timeLabel)
        addSubview(iconView)
        addSubview(temperatureLabel)
        addSubview(precipitationLabel)

        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }

        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }

        precipitationLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }
    }

    func configure(model: DailyWeatherModel.Hour) {
        timeLabel.text = model.time.getTime()
        temperatureLabel.text = "\(model.temp_c)°C"
        precipitationLabel.text = "\(model.chance_of_rain)%"
        
        var iconString = model.condition.icon
        if iconString.hasPrefix("//") {
            iconString = "https:" + iconString
        }
        if let imageUrl = URL(string: iconString) {
            iconView.sd_setImage(with: imageUrl, placeholderImage: UIImage())
        }
    }
}
