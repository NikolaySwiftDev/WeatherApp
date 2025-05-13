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
        backgroundColor = UIColor.systemBlue
        layer.cornerRadius = 20
        clipsToBounds = true
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    func configure(with data: [DailyWeatherModel]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
      
        for item in data {
            let cell = DailyForecastCellView()
            cell.configure(model: item)
            stackView.addArrangedSubview(cell)
        }
    }
}
