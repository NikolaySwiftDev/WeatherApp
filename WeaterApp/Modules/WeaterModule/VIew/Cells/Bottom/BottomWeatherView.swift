import UIKit
import SnapKit

class DailyForecastView: UIView {
    
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    func configure(with data: [DailyForecast]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
      
        for item in data {
            let cell = DailyForecastCellView()
            cell.configure(
                day: item.day,
                icon: item.icon,
                temperatureMax: item.temperatureMax,
                temperatureMin: item.temperatureMin,
                showRain: item.willRain
            )
            stackView.addArrangedSubview(cell)
        }
    }

}
