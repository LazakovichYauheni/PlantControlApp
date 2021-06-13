import Foundation
import UIKit

final class DeviceInfoTableViewCell: UITableViewCell {
    // MARK: - Subview Properties
    
    private lazy var iconImageView = UIImageView().then {
        $0.image = UIImage(named: "wifiIcon")
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = UIColor().color(hex: "#787A7C")
        $0.font = UIFont(name: "Roboto-Regular", size: 18)
    }
    
    // MARK: - UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) { nil }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(34)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(40)
            make.centerY.equalTo(iconImageView)
        }
    }
    
    func configure(name: String) {
        titleLabel.text = name
    }
}
