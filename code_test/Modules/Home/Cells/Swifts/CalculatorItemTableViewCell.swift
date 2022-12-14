//
//  CalculatorItemTableViewCell.swift
//  code_test
//
//  Created by Thinzar Soe on 9/4/22.
//

import UIKit
import CombineCocoa

protocol CalculatorItemTableViewCellDelegate {
    func didTapChoose()
}

class CalculatorItemTableViewCell : BaseTableViewCell {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnChooseCurrency: UIButton!
    @IBOutlet weak var tfFrom: UITextField!
    
    var fromValue : Double = 0.0
    var exchageRateList : [SaveExchangeRateVO] = []
    var delegate : CalculatorItemTableViewCellDelegate?
    var selectedCurrencyType : CurrencyType = .usd
    var viewModel : CalculatorViewModel = CalculatorViewModel()
    
    override func setupUI() {
        super.setupUI()
        heightConstraint.constant = UIScreen.main.bounds.height * 0.07
        btnChooseCurrency.titleLabel?.font = UIFont.Roboto.Bold.font(size: 18)
        tfFrom.font = UIFont.Roboto.Bold.font(size: 18)
        tfFrom.keyboardType = .numberPad
        tfFrom.delegate = self
    }
    
    override func setupLanguage() {
        super.setupLanguage()
    }
    
    override func bindData() {
        super.bindData()
        btnChooseCurrency.tapPublisher.sink {
            self.delegate?.didTapChoose()
        }.store(in: &bindings)
        
        viewModel.tfFromPublishSubject.sink {
            self.tfFrom.text = $0
        }.store(in: &bindings)
        
        tfFrom.textPublisher.sink{[unowned self] in
            self.tfFrom.text = $0
            viewModel.tfFromPublishSubject.send($0 ?? "")
        }.store(in: &bindings)
    }
    
    func setupData(viewModel : inout CalculatorViewModel) {
        self.viewModel = viewModel
        btnChooseCurrency.setTitle(viewModel.selectedCurrrencyTypePublishSubject.value.getCurrencyName(), for: .normal)
    }
}

extension CalculatorItemTableViewCell : UITextFieldDelegate{
    func textField(_ shouldChangeCharactersIntextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
            let inverseSet = NSCharacterSet(charactersIn:"0123456789.").inverted

            let components = string.components(separatedBy: inverseSet)

            let filtered = components.joined(separator: "")

            return string == filtered

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // Try to find next responder
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
       }
       // Do not add a line break
       return false
    }
}
