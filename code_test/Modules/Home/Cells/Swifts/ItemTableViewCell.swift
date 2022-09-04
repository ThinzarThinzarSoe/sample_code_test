//
//  SelectedDaysItemTableViewCell.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import UIKit

class ItemTableViewCell: BaseTableViewCell {

    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblBTC: UILabel!
    @IBOutlet weak var lblOtherExchangeCurrency: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupUI() {
        super.setupUI()
        lblDateTime.font = UIFont.Roboto.Bold.font(size: 15)
        lblBTC.font = UIFont.Roboto.Bold.font(size: 15)
        lblOtherExchangeCurrency.font = UIFont.Roboto.Bold.font(size: 15)
    }
    
    func setupCell(data : [String : [SaveExchangeRateVO]]){
        if let updateDateAndTime = XTDateFormatterStruct.xt_fullLongDateFormatter().date(from: Array(data.keys).first ?? ""){
            self.lblDateTime.text = " \(XTDateFormatterStruct.xt_shortDateFormatterWithTime().string(from: updateDateAndTime))"
        }
        lblBTC.text = "1 BTC"
        data.values.enumerated().forEach { (index, rate) in
            lblOtherExchangeCurrency.text = "\(rate.first?.rate ?? "0.0") \(rate.first?.code ?? "")"
        }
    }
}
