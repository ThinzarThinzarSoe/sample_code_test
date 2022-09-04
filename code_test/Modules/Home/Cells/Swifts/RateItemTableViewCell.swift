//
//  RateItemTableViewCell.swift
//  code_test
//
//  Created by Thinzar Soe on 9/4/22.
//

import UIKit

class RateItemTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var lblToCurrency: UILabel!
    @IBOutlet weak var lblToCurrencyRate: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var viewModel : CalculatorViewModel = CalculatorViewModel()
    
    override func setupUI() {
        super.setupUI()
        lblToCurrency.font = UIFont.Roboto.Bold.font(size: 18)
        lblToCurrencyRate.font = UIFont.Roboto.Bold.font(size: 18)
        heightConstraint.constant = UIScreen.main.bounds.height * 0.07
    }
    
    override func setupLanguage() {
        super.setupLanguage()
        lblToCurrency.text = "1BTC"
    }
    
    override func bindData() {
        super.bindData()
        viewModel.currencyRatePublishSubject.sink{[unowned self] in
            self.lblToCurrencyRate.text = " \($0)"
        }.store(in: &bindings)
    }
    
    func setupData(viewModel : inout CalculatorViewModel) {
        self.viewModel = viewModel
    }
}
