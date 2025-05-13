import UIKit
import SnapKit

class HourlyForecastView: UIView {

    private let scrollView = UIScrollView()
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
            make.edges.equalToSuperview().inset(0)
            make.height.equalToSuperview().offset(-22)
        }
    }

    func configure(with data: [HourlyForecast]) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for item in data {
            let cell = HourlyForecastCellView()
            cell.snp.makeConstraints { make in
                make.width.equalTo(80)
            }
            cell.configure(
                time: item.time,
                icon: item.icon,
                temp: ("\(item.temperature)°C"),
                precipitation: ("💧\(item.precipitation)%")
            )
            stackView.addArrangedSubview(cell)
        }
    }
}
