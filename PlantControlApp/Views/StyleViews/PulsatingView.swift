import Foundation
import UIKit

final class PulsatingView: UIView {
    // MARK: - UIView
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        startPulsatingAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private Methods
    
    private func stopAnimation() {
        layer.removeAnimation(forKey: "backgroundColorAnimation")
    }
    
    private func startPulsatingAnimation() {
        stopAnimation()
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = UIColor().color(hex: "#D5D6D9").cgColor
        animation.toValue = UIColor().color(hex: "#EEF0F3").cgColor
        animation.duration = 3
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        layer.add(animation, forKey: "backgroundColorAnimation")
    }
}
