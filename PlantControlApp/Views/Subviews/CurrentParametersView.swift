import Foundation
import UIKit

protocol CurrentParametersConfigurable {
    func configure(with: CurrentParametersView.ViewModel)
}

private extension Constants {
    static let greenMaxProgress = 40
    static let yellowMaxProgress = 35
}

final class CurrentParametersView: ShadowView {
    // MARK: - Subview Properties
    
    private lazy var headerTitle = UILabel().then {
        $0.text = Constants.currentParameters
        $0.textColor = UIColor().color(hex: "#B2B9C1")
        $0.font = UIFont(name: "Roboto-Regular", size: 22)
    }
    
    private lazy var humidityTitle = UILabel().then {
        $0.text = Constants.humidity
        $0.textColor = UIColor().color(hex: "#B2B9C1")
        $0.font = UIFont(name: "Roboto-Regular", size: 18)
    }
    
    private lazy var humidityProgressView = UIView().then {
        $0.layer.cornerRadius = 7.5
        $0.backgroundColor = UIColor().color(hex: "#F3F0F0")
    }
    
    private lazy var waterLevelTitle = UILabel().then {
        $0.text = Constants.waterLevel
        $0.textColor = UIColor().color(hex: "#B2B9C1")
        $0.font = UIFont(name: "Roboto-Regular", size: 18)
    }
    
    private lazy var waterProgressView = UIView().then {
        $0.layer.cornerRadius = 7.5
        $0.backgroundColor = UIColor().color(hex: "#F3F0F0")
    }
    
    private lazy var lightningTitle = UILabel().then {
        $0.text = Constants.lightning
        $0.textColor = UIColor().color(hex: "#B2B9C1")
        $0.font = UIFont(name: "Roboto-Regular", size: 18)
    }
    
    private lazy var lightningProgressView = UIView().then {
        $0.layer.cornerRadius = 7.5
        $0.backgroundColor = UIColor().color(hex: "#F3F0F0")
    }
    
    private lazy var hintView = PulsatingView().then {
        $0.isHidden = true
        $0.layer.cornerRadius = 12
    }
    
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
        backgroundColor = .white
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(headerTitle)
        addSubview(humidityTitle)
        addSubview(humidityProgressView)
        addSubview(waterLevelTitle)
        addSubview(waterProgressView)
        addSubview(lightningTitle)
        addSubview(lightningProgressView)
        addSubview(hintView)
    }
    
    private func makeConstraints() {
        headerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.centerX.equalToSuperview()
        }
        
        humidityTitle.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        humidityProgressView.snp.makeConstraints { make in
            make.top.equalTo(humidityTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }
        
        waterLevelTitle.snp.makeConstraints { make in
            make.top.equalTo(humidityProgressView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        waterProgressView.snp.makeConstraints { make in
            make.top.equalTo(waterLevelTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }
        
        lightningTitle.snp.makeConstraints { make in
            make.top.equalTo(waterProgressView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        lightningProgressView.snp.makeConstraints { make in
            make.top.equalTo(lightningTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func drawLine(currentValue: Float, progressView: UIView) {
        let midY = progressView.frame.midY
        let greenMaxProgressWidth = CGFloat(Constants.greenMaxProgress) * progressView.frame.width / 100
        let yellowMaxProgressWidth = CGFloat(Constants.yellowMaxProgress) * progressView.frame.width / 100
        
        let greenProgressLayer = createShapeLayer(color: UIColor().color(hex: "#76D449"))
        let yellowProgressLayer = createShapeLayer(color: UIColor().color(hex: "#F5E54D"))
        let redProgressLayer = createShapeLayer(color: UIColor().color(hex: "#DA3636"))
        
        let greenBezierPath = UIBezierPath()
        let yellowBezierPath = UIBezierPath()
        let redBezierPath = UIBezierPath()
        
        greenBezierPath.move(to: CGPoint(x: progressView.frame.minX + 7, y: midY))
        
        let currentValueWidth = CGFloat(currentValue) * progressView.frame.width / 100
        
        if currentValueWidth > greenMaxProgressWidth {
            let differenceWidth = currentValueWidth - greenMaxProgressWidth
            
            greenBezierPath.addLine(to: .init(x: greenMaxProgressWidth, y: midY))
            yellowBezierPath.move(to: .init(x: greenMaxProgressWidth, y: midY))

            if differenceWidth > yellowMaxProgressWidth {
                yellowBezierPath.addLine(to: .init(x: greenMaxProgressWidth + yellowMaxProgressWidth, y: midY))
                redBezierPath.move(to: .init(x: greenMaxProgressWidth + yellowMaxProgressWidth, y: midY))
                redBezierPath.addLine(to: .init(x: currentValueWidth, y: midY))
            } else {
                yellowBezierPath.addLine(to: .init(x: currentValueWidth, y: midY))
            }
        } else {
            greenBezierPath.addLine(to: .init(x: currentValueWidth, y: midY))
        }
        
        greenProgressLayer.path = greenBezierPath.cgPath
        yellowProgressLayer.path = yellowBezierPath.cgPath
        redProgressLayer.path = redBezierPath.cgPath
        
        
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.3
        CATransaction.setCompletionBlock {
            CATransaction.setCompletionBlock {
                redProgressLayer.add(animation, forKey: "anim")
                self.layer.addSublayer(redProgressLayer)
            }
            
            yellowProgressLayer.add(animation, forKey: "anim")
            self.layer.addSublayer(yellowProgressLayer)
        }
        greenProgressLayer.add(animation, forKey: "anim")
        layer.addSublayer(greenProgressLayer)
        CATransaction.commit()
    }
    
    private func createShapeLayer(color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = 15
        layer.lineCap = .round
        layer.strokeEnd = 1
        
        return layer
    }
}

// MARK: - CurrentParametersConfigurable

extension CurrentParametersView: CurrentParametersConfigurable {
    struct ViewModel {
        var humidityValue: Float = .zero
        var waterValue: Float = .zero
        var lightningValue: Float = .zero
        var isHintEnabled: Bool = true
    }
    
    func configure(with viewModel: ViewModel) {
        if viewModel.isHintEnabled {
            hintView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            hintView.isHidden = false
        } else {
            hintView.isHidden = true
            layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
            drawLine(currentValue: viewModel.humidityValue, progressView: humidityProgressView)
            drawLine(currentValue: viewModel.waterValue, progressView: waterProgressView)
            drawLine(currentValue: viewModel.lightningValue, progressView: lightningProgressView)
        }
    }
}
