import UIKit
import SnapKit

class HourlyForecastView: UIView {

    //MARK: - Properies
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    //MARK: - Setup View
    private func setupView() {
        backgroundColor = UIColor.systemBlue
        layer.cornerRadius = 20
        clipsToBounds = true
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.showsHorizontalScrollIndicator = false

        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing

        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(-20)
        }
    }

    //MARK: - Configure
    func configure(with data: [DailyWeatherModel.Hour]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for item in data {
            let cell = HourlyForecastCellView()
            cell.snp.makeConstraints { make in
                make.width.equalTo(80)
            }
            cell.configure(model: item)
            stackView.addArrangedSubview(cell)
        }
    }
}
