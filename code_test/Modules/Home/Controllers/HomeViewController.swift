
import UIKit
import CombineCocoa

class HomeViewController : BaseViewController {
    
    @IBOutlet weak var lblLastUpdateDteTime: UILabel!
    @IBOutlet weak var heightConstraintForLastUpdateDteTime: NSLayoutConstraint!
    @IBOutlet weak var widthConstraintForLastUpdateDteTime: NSLayoutConstraint!
    @IBOutlet weak var tblExchangeRate: UITableView!
    
    var btnCalculator = RoundedCornerUIButton(type: .custom)
    var viewModel : HomeViewModel = HomeViewModel()
    var exchageRateList : [ExchangeRateVO] = []
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getExchangeRate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { [unowned self] timer in
            viewModel.getExchangeRate()
        })
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    override func setupUI() {
        super.setupUI()
        setupNavigationChatBarButton()
        lblLastUpdateDteTime.isHidden = true
        lblLastUpdateDteTime.font = UIFont.Roboto.Bold.font(size: 14)
        lblLastUpdateDteTime.text = "Last updated: 04-Sep-2020 01:00 PM"
        heightConstraintForLastUpdateDteTime.constant = "Last updated: 04-Sep-2020 01:00 PM".size(withAttributes: [.font: UIFont.Roboto.Bold.font(size: 14)]).height + 20
        widthConstraintForLastUpdateDteTime.constant = "Last updated: 04-Sep-2020 01:00 PM".size(withAttributes: [.font: UIFont.Roboto.Bold.font(size: 14)]).width + 20
        lblLastUpdateDteTime.backgroundColor = .clear
        lblLastUpdateDteTime.textColor = .white
        setFloatingCalculatorBtn()
        btnCalculator.isHidden = true
        setupTableView()
    }
    
    override func setupLanguage() {
        super.setupLanguage()
        setupNavigationTitle(title: "Exchange Rate")
    }
    
    override func bindData() {
        super.bindData()
        viewModel.exchangeRatePublishSubject.sink {
            if !$0.isEmpty{
                self.exchageRateList = $0
            }
            self.tblExchangeRate.isHidden = false
            self.btnCalculator.isHidden = false
            self.tblExchangeRate.reloadData()
        }.store(in: &bindings)
        
        viewModel.lastUpdateTimePublishSubject.sink {
            if $0 != "" {
                if let updateDateAndTime = XTDateFormatterStruct.xt_fullLongDateFormatter().date(from: $0){
                    self.lblLastUpdateDteTime.text = "Last updated: \(XTDateFormatterStruct.xt_shortDateFormatterWithTime().string(from: updateDateAndTime))"
                }
            }
            self.lblLastUpdateDteTime.isHidden = false
        }.store(in: &bindings)
    }
    
    @objc override func didTapChat(){
        HomeScreen.HomeVC.navigateToHistoryExchangeRateVC.show()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        viewModel.bindViewModel(in : self)
    }

    private func setFloatingCalculatorBtn() {
        btnCalculator = RoundedCornerUIButton(frame: CGRect.zero)
        btnCalculator.setTitle("", for: .normal)
        btnCalculator.setImage(UIImage(named: "ic_calculator")?.imageWithColor(color: .white), for: .normal)
        btnCalculator.setImage(UIImage(named: "ic_calculator")?.imageWithColor(color: .white), for: .selected)
        btnCalculator.translatesAutoresizingMaskIntoConstraints = false
        btnCalculator.backgroundColor = .black
        btnCalculator.isCircle = true
        self.view.addSubview(btnCalculator)
        btnCalculator.snp.makeConstraints { make in
             make.bottom.equalTo(-30)
             make.trailing.equalTo(-30)
             make.width.equalTo(60)
             make.height.equalTo(60)
         }
         
        btnCalculator.addTarget(self, action: #selector(didTapCalculatorIcon), for: .touchUpInside)
     }
     
     @objc func didTapCalculatorIcon() {
         HomeScreen.HomeVC.navigateToCalculatorVC.show()
     }

    private func setupTableView() {
        tblExchangeRate.delegate = self
        tblExchangeRate.dataSource = self
        tblExchangeRate.showsVerticalScrollIndicator = false
        tblExchangeRate.contentInsetAdjustmentBehavior = .never
        tblExchangeRate.separatorStyle = .none
        tblExchangeRate.backgroundColor = .clear
        tblExchangeRate.isHidden = true
        tblExchangeRate.registerForCells(cells: [ExchangeRateItemTableViewCell.self]
                                   )
    }
}

extension HomeViewController : TableViewDelegateAndDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchageRateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getExchangeRateCell(indexPath: indexPath)
    }
}

extension HomeViewController {
    func getExchangeRateCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tblExchangeRate.dequeReuseCell(type: ExchangeRateItemTableViewCell.self, indexPath: indexPath)

         cell.setupCell(data: exchageRateList[indexPath.row])
        return cell
    }
}
