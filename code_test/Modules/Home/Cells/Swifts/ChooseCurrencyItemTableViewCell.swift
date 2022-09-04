//
//  ChooseCurrencyItemTableViewCell.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import UIKit
import CombineCocoa

protocol ChooseCurrencyItemTableViewCellDelegate {
    func didChooseCurrency()
}
class ChooseCurrencyItemTableViewCell: BaseTableViewCell {
    @IBOutlet weak var btnChoose: RoundedCornerUIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var delegate : ChooseCurrencyItemTableViewCellDelegate?
    
    override func setupUI() {
        super.setupUI()
        heightConstraint.constant = UIScreen.main.bounds.height * 0.05
    }
    
    override func setupLanguage() {
        super.setupLanguage()
    }
    
    override func bindData() {
        super.bindData()
        btnChoose.tapPublisher.sink {
            self.delegate?.didChooseCurrency()
        }.store(in: &bindings)
    }
    
    func setupCell(viewModel : inout ExchangeRateViewModel) {
        viewModel.selectedCurrrencyTypePublishSubject.sink{ [unowned self] in
            btnChoose.setTitle("\($0.getCurrencyName()) - \($0.getDescription())", for: .normal)
        }.store(in: &bindings)
    }
}
