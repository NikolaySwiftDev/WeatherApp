import UIKit
import SnapKit
import SDWebImage

class DailyForecastCellView: UIView {
    
    private let dayLabel = UILabel()
    private let iconView = UIImageView()
    private let tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        dayLabel.font = .systemFont(ofSize: 22, weight: .bold)
        dayLabel.textColor = .white
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        
        tempLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .right


        addSubview(dayLabel)
        addSubview(iconView)
        addSubview(tempLabel)

        dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(dayLabel.snp.trailing).offset(16)
            make.width.equalTo(44)
            make.height.equalTo(34)
        }

        tempLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }

    }

    func configure(model: DailyWeatherModel) {
        dayLabel.text = model.date.getFullDate()
        tempLabel.text = "\(model.day.mintemp_c)°C / \(model.day.maxtemp_c)°C"
        
        var iconString = model.day.condition.icon
        if iconString.hasPrefix("//") {
            iconString = "https:" + iconString
        }
        if let imageUrl = URL(string: iconString) {
            iconView.sd_setImage(with: imageUrl, placeholderImage: UIImage())
        }
    }
}
