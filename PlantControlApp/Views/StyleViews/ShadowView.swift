import UIKit

extension UIView {
    /// Цвет тени
    @IBInspectable open var shadowColor: UIColor? {
        set { layer.shadowColor = newValue?.cgColor }
        get { UIColor(cgColor: layer.shadowColor!) }
    }
}

/// Вью с тенью
public class ShadowView: UIView {
    public override var shadowColor: UIColor? {
        didSet { updateShadow() }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        updateShadow()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateShadow()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    fileprivate func updateShadow() {
        backgroundColor = UIColor.clear
        let layer = self.layer
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOpacity = 0.21
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 6)
    }
}
