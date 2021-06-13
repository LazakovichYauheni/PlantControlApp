import Foundation
import UIKit

final class PlantTitleTableViewCell: UITableViewCell {
    // MARK: - Subview Properties
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = UIColor().color(hex: "#6C6C6C")
        $0.font = UIFont(name: "Roboto-Medium", size: 22)
    }
    
    private lazy var arrowView = UIImageView().then {
        $0.image = UIImage(named: "arrow")
    }
    
    // MARK: - UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func rotateArrowAnimated(isSelecting: Bool) {
        UIView.animate(
            withDuration: 1,
            animations: {
                self.arrowView.transform = isSelecting
                    ? CGAffineTransform(rotationAngle: .pi)
                    : CGAffineTransform.identity
            }
        )
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        backgroundColor = .clear
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowView)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
        }
        
        arrowView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(16)
            make.centerY.equalTo(titleLabel).inset(8)
        }
    }
    
    private func rotateArrow(isSelecting: Bool) {
        let rotationAngle: CGFloat = isSelecting ? 2 * CGFloat.pi : .pi
        arrowView.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
}

// MARK: - Configure

extension PlantTitleTableViewCell {
    struct ViewModel: Hashable {
        let title: String
        let isExpanded: Bool
        let isArrowHidden: Bool
    }
    
    func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        rotateArrow(isSelecting: !viewModel.isExpanded)
        arrowView.isHidden = viewModel.isArrowHidden
    }
}
