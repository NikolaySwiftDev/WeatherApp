import UIKit
import SnapKit

class DailyForecastCellView: UIView {
    
    private let dayLabel = UILabel()
    private let iconView = UIImageView()
    private let tempLabel = UILabel()
    private let rainIndicator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        dayLabel.font = .systemFont(ofSize: 16)
        dayLabel.textColor = .white
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        
        tempLabel.font = .systemFont(ofSize: 16)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .right
        
        rainIndicator.backgroundColor = UIColor.cyan.withAlphaComponent(0.7)
        rainIndicator.layer.cornerRadius = 4

        addSubview(dayLabel)
        addSubview(iconView)
        addSubview(tempLabel)
        addSubview(rainIndicator)

        dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }

        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(dayLabel.snp.trailing).offset(16)
            make.width.height.equalTo(24)
        }

        tempLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }

        rainIndicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(tempLabel.snp.leading).offset(-12)
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
    }

    func configure(day: String, icon: UIImage?, temperature: String, showRain: Bool) {
        dayLabel.text = day
        iconView.image = icon
        tempLabel.text = temperature
        rainIndicator.isHidden = !showRain
    }
}
