import UIKit

protocol ModalViewEventsRespondable: NSObject {
    func didCellTapped(name: String)
}

public final class ModalView: UIView {
    // MARK: - Public Properties
    
    weak var delegate: ModalViewEventsRespondable?
    
    // MARK: - Subview Properties
    
    private lazy var topView = UIView().then {
        $0.backgroundColor = UIColor().color(hex: "#C4C4C4")
        $0.layer.cornerRadius = 1.5
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(DeviceInfoTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
    }
    
    // MARK: - Private Properties
    
    private var plantTitles: [String] = []
    
    // MARK: - UIView

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        backgroundColor = .white
        layer.cornerRadius = 8
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - PrivateMethods
    
    private func commonInit() {
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(topView)
        addSubview(tableView)
    }
    
    private func makeConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(3)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(with plantTitles: [String]) {
        self.plantTitles = plantTitles
    }
}

// MARK: - UITableViewDelegate

extension ModalView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didCellTapped(name: plantTitles[indexPath.row])
    }
}

// MARK: - UITableViewDataSource

extension ModalView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        plantTitles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? DeviceInfoTableViewCell else { return UITableViewCell() }
        cell.configure(name: plantTitles[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
