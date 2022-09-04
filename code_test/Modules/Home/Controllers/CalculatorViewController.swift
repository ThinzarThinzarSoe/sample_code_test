//
//  CalculatorViewController.swift
//  code_test
//
//  Created by Thinzar Soe on 9/4/22.
//

import UIKit
import CombineCocoa

class CalculatorViewController : BaseTableViewController {
    
    var currencyTypeList : [CurrencyType] = [.usd , .gbp , .eur]
    var selectedCurrencyType : CurrencyType = .usd
    var viewModel : CalculatorViewModel = CalculatorViewModel()
    var exchageRateList : [SaveExchangeRateVO] = []
    var toVale : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBackButton()
        exchageRateList.removeAll()
        viewModel.retrieveAllExchangeRate()
    }
    
    deinit {
        
    }
    
    override func didTapBackBtn() {
        AppScreens.shared.goBackToHomeVC()
    }
    
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .primary_grey
    }
    
    override func setupLanguage() {
        super.setupLanguage()
        setupNavigationTitle(title: "Currency Convertor")
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        viewModel.bindViewModel(in : self)
    }
    
    override func setupTableView() {
        super.setupTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.backgroundColor = .primary_grey
        tableView.isHidden = true
        tableView.registerForCells(cells: [
            CalculatorItemTableViewCell.self,
            RateItemTableViewCell.self])
    }
    
    func getCurrencyRate() -> Double{
        if let idx = self.exchageRateList.firstIndex(where: {$0.code == self.selectedCurrencyType.getCurrencyName()}) {
            return self.exchageRateList[idx].rate_float ?? 0.0
        }
        return 0.0
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.exchangeRatePublishSubject.sink {
            if !$0.isEmpty{
                self.exchageRateList = $0
            }
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }.store(in: &bindings)
        
        viewModel.selectedCurrrencyTypePublishSubject.sink{ [unowned self] in
            self.selectedCurrencyType = $0
            viewModel.tfFromPublishSubject.send("0.0")
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }.store(in: &bindings)
        
        viewModel.tfFromPublishSubject.sink{ [unowned self] in
            let fromValue = Double($0)
            viewModel.currencyRatePublishSubject.send(getCurrencyRate() * (fromValue ?? 0.0))
        }.store(in: &bindings)
        
        viewModel.currencyRatePublishSubject.sink{ _ in
            self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        }.store(in: &bindings)
    }
    
    private func showCurrencyPicker() {
        let idx = self.currencyTypeList.firstIndex(where: {$0.getID() == selectedCurrencyType.getID()})
        let nameArray = self.currencyTypeList.compactMap {
            return "\($0.getCurrencyName()) - \($0.getDescription())"
        }
        CustomPicker.selectOption(title: "Choose Currency", cancelText: "Cancel", dataArray: nameArray, selectedIndex: idx) {[weak self] (selctedText, atIndex) in
            self?.viewModel.selectedCurrrencyTypePublishSubject.send(self?.currencyTypeList[atIndex] ?? .usd)
        }
    }
 }

extension CalculatorViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return getCalculatorCell(indexPath: indexPath)
        } else {
            return getRateCell(indexPath: indexPath)
        }
    }
}

extension CalculatorViewController {
    func getCalculatorCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReuseCell(type: CalculatorItemTableViewCell.self, indexPath: indexPath)
        cell.delegate = self
        cell.setupData(viewModel: &viewModel)
        return cell
    }
    
    func getRateCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeReuseCell(type: RateItemTableViewCell.self, indexPath: indexPath)
        cell.setupData(viewModel: &viewModel)
        return cell
    }
}

extension CalculatorViewController : CalculatorItemTableViewCellDelegate {
    func didTapChoose() {
        self.showCurrencyPicker()
    }
}
