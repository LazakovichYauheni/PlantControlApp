import Foundation
import UIKit

final class PlantsTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(.infinity, contentSize.height)
        return CGSize(width: contentSize.width, height: height)
    }
    
    override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }
}
