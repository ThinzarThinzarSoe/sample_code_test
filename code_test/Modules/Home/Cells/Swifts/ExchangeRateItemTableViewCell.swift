//
//  ExchangeRateItemTableViewCell.swift
//  code_test
//
//  Created by Thinzar Soe on 9/2/22.
//

import UIKit

class ExchangeRateItemTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var lblBTC: UILabel!
    @IBOutlet weak var lblOtherExchangeCurrency: UILabel!
    
    override func setupUI() {
        super.setupUI()
        lblBTC.font = UIFont.Roboto.Bold.font(size: 15)
        lblOtherExchangeCurrency.font = UIFont.Roboto.Bold.font(size: 15)
    }
    
    override func setupLanguage() {
        super.setupLanguage()
    }
    
    func setupCell(data : ExchangeRateVO) {
        lblBTC.text = "1 BTC"
        lblOtherExchangeCurrency.text = "\(data.rate ?? "0.0") \(data.code ?? "")"
    }
    
}
