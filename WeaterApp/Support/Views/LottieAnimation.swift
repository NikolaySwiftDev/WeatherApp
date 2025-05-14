import UIKit
import Lottie
import SnapKit

final class LottieView: UIView {
    
    private var animationView: LottieAnimationView?

    init(animationName: String) {
        super.init(frame: .zero)
        setupAnimation(named: animationName)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAnimation(named: "loading")
    }
    
    private func setupAnimation(named name: String) {
        let animationView = LottieAnimationView(name: name)
        self.animationView = animationView
        
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
        addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func play() {
        animationView?.play()
    }
    
    func stop() {
        animationView?.stop()
    }
}
