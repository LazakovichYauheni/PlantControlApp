import Foundation
import UIKit

protocol DailyConfigurable {
    func configure(with: DailyView.ViewModel)
}

final class DailyView: UIView {
    // MARK: - Subview Properties
    
    private lazy var iconView = UIImageView()
    
    private lazy var descriptionTitle = UILabel().then {
        $0.text = Constants.description
        $0.textColor = UIColor().color(hex: "#FFFFFF")
        $0.font = UIFont(name: "Roboto-Regular", size: 16)
    }
    
    private lazy var descriptionParameterTitle = UILabel().then {
        $0.text = Constants.descriptionWaterDefaultParameter
        $0.textColor = UIColor().color(hex: "#FFFFFF")
        $0.font = UIFont(name: "Roboto-Regular", size: 16)
    }
    
    private lazy var currentValueTitle = UILabel().then {
        $0.textColor = UIColor().color(hex: "#FFFFFF")
        $0.font = UIFont(name: "Roboto-Medium", size: 64)
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
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(iconView)
        addSubview(descriptionTitle)
        addSubview(descriptionParameterTitle)
        addSubview(currentValueTitle)
        addSubview(hintView)
    }
    
    private func makeConstraints() {
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.top.equalToSuperview().inset(20)
            make.size.equalTo(42)
        }
        
        descriptionTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(26)
        }
        
        descriptionParameterTitle.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(2)
            make.leading.equalToSuperview().inset(26)
            make.bottom.equalToSuperview().inset(16)
        }
        
        currentValueTitle.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(iconView)
        }
    }
    
}

// MARK: - DailyWaterConfigurable

extension DailyView: DailyConfigurable {
    struct ViewModel {
        let currentValueTitle: String?
        var backgroundColor: UIColor?
        var isHintEnabled: Bool = true
        var image: UIImage?
    }
    
    func configure(with viewModel: ViewModel) {
        if viewModel.isHintEnabled {
            hintView.isHidden = false
            
            hintView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        } else {
            hintView.isHidden = true
            backgroundColor = viewModel.backgroundColor
            iconView.image = viewModel.image
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = .white
            currentValueTitle.text = viewModel.currentValueTitle
        }
    }
}
