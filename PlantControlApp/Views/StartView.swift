import Foundation
import UIKit
import SnapKit

protocol Configure {
    func configure(with: StartView.ViewModel)
}

protocol StartViewEventsRespondable: NSObject {
    func didAddButtonTapped()
    func didPlantChanged(index: Int)
}

final class StartView: UIView {
    // MARK: - Public Properties
    
    weak var delegate: StartViewEventsRespondable?
    
    // MARK: - Subview Properties
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = UIColor().color(hex: "#6C6C6C")
        $0.text = Constants.defaultTitle
        $0.font = UIFont(name: "Roboto-Medium", size: 22)
    }
    
    private lazy var plantsTableView = PlantsTableView().then {
        $0.isHidden = true
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.register(PlantTitleTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    private lazy var dailyWaterView = DailyView().then {
        $0.layer.cornerRadius = 12
    }
    
    private lazy var dailyLightView = DailyView().then {
        $0.layer.cornerRadius = 12
    }
    
    private lazy var currentParametersView = CurrentParametersView().then {
        $0.layer.cornerRadius = 12
    }
    
    private lazy var buttonContainerView = ShadowView().then {
        $0.layer.cornerRadius = 39
        $0.backgroundColor = .white
    }
    
    private lazy var firstPlusView = UIView().then {
        $0.layer.cornerRadius = 2.5
        $0.backgroundColor = .gray
    }
    
    private lazy var secondPlusView = UIView().then {
        $0.layer.cornerRadius = 2.5
        $0.backgroundColor = .gray
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private lazy var stackView = UIStackView()
    private lazy var containerView = UIView()
    
    // MARK: - Private Properties
    
    private lazy var dataSource = PlantTableViewDataSource(tableView: plantsTableView).then {
        plantsTableView.dataSource = $0
        $0.delegate = self
    }
    
    // MARK: - UIView
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private Methods
    
    private func commonInit() {
        backgroundColor = UIColor().color(hex: "#F6F6F9")
        addSubviews()
        makeConstraints()
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        buttonContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didAddButtonTapped)))
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(plantsTableView)
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(dailyWaterView)
        containerView.addSubview(dailyLightView)
        containerView.addSubview(currentParametersView)
        containerView.addSubview(buttonContainerView)
        buttonContainerView.addSubview(firstPlusView)
        buttonContainerView.addSubview(secondPlusView)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
            make.centerX.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(self)
            make.height.greaterThanOrEqualTo(self)
        }
        
        dailyWaterView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(142)
        }
        
        dailyLightView.snp.makeConstraints { make in
            make.top.equalTo(dailyWaterView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(142)
        }

        currentParametersView.snp.makeConstraints { make  in
            make.top.equalTo(dailyLightView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        buttonContainerView.snp.makeConstraints { make in
            make.top.equalTo(currentParametersView.snp.bottom).offset(24)
            make.size.equalTo(CGSize(width: 78, height: 78))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        
        firstPlusView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(43)
            make.width.equalTo(5)
        }
        
        secondPlusView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(43)
            make.height.equalTo(5)
        }
    }
    
    @objc private func didAddButtonTapped() {
        delegate?.didAddButtonTapped()
    }
}

extension StartView: Configure {
    struct ViewModel {
        let rows: [PlantTableViewDataSource.Row]
        let data: PlantModel?
        let isInitialState: Bool
    }
    func configure(with viewModel: ViewModel) {
        if !viewModel.rows.isEmpty {
            plantsTableView.isHidden = false
            titleLabel.isHidden = true
            
            plantsTableView.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
                make.leading.trailing.equalToSuperview()
            }
            scrollView.snp.makeConstraints { make in
                make.top.equalTo(plantsTableView.snp.bottom).offset(16)
                make.leading.trailing.bottom.equalToSuperview()
            }
            dataSource.update(with: viewModel.rows)
            
            dailyWaterView.configure(with: .init(
                currentValueTitle: String(viewModel.data?.dailyWaterRate ?? .zero),
                backgroundColor: viewModel.data?.color,
                isHintEnabled: false,
                image: UIImage(named: "water")
            ))
            dailyLightView.configure(with: .init(
                currentValueTitle: String(viewModel.data?.dailyLightRate ?? .zero),
                backgroundColor: viewModel.data?.color,
                isHintEnabled: false,
                image: UIImage(named: "bulb")
            ))
            currentParametersView.configure(with: .init(
                humidityValue: viewModel.data?.humidity ?? .zero,
                waterValue: viewModel.data?.waterLevel ?? .zero,
                lightningValue: viewModel.data?.lightning ?? .zero,
                isHintEnabled: false
            ))
                        
            firstPlusView.backgroundColor = viewModel.data?.color
            secondPlusView.backgroundColor = viewModel.data?.color
        } else {
            plantsTableView.isHidden = true
            titleLabel.isHidden = false
            
            dailyWaterView.configure(with: .init(currentValueTitle: nil))
            dailyLightView.configure(with: .init(currentValueTitle: nil))
            currentParametersView.configure(with: .init())
        }
    }
}

// MARK: - PlantTableViewDataSourceEventsRespondable

extension StartView: PlantTableViewDataSourceEventsRespondable {
    func didSelectRow(index: Int) {
        delegate?.didPlantChanged(index: index)
    }
}
