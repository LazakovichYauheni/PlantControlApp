import Foundation
import UIKit

final class ActivityIndicatorView: UIView {
    // MARK: - Subview Properties
    
    private lazy var indicatorView = UIView()
    
    // MARK: - Private Properties
    
    private var animationDuration: Double = 5
    private var shapeLayer = CAShapeLayer()
    
    // MARK: - UIView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubviews()
        makeConstraints()
        makeCircleView()
        animateCircle()
    }
    
    private func makeCircleView() {
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: frame.width / 2, y: frame.height / 2),
            radius: 40,
            startAngle: CGFloat(-Double.pi / 2),
            endAngle: CGFloat(3 * Double.pi / 2),
            clockwise: true
        )
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor().color(hex: "#26A5DC").cgColor
        shapeLayer.lineWidth = 15
        
        indicatorView.layer.addSublayer(shapeLayer)
    }
    
    private func animateCircle() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.duration = animationDuration
        animation.toValue = 1.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.repeatCount = MAXFLOAT
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        shapeLayer.strokeEnd = 0.0
        shapeLayer.add(animation, forKey: "circleAnimation")
    }
    
    private func addSubviews() {
        addSubview(indicatorView)
    }
    
    private func makeConstraints() {
        indicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
