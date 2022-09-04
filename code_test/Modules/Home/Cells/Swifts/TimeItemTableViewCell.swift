//
//  TimeItemTableViewCell.swift
//  code_test
//
//  Created by Thinzar Soe on 9/4/22.
//

import UIKit

protocol TimeItemTableViewCellDelegate {
    func didTapTime(type : TimeType)
}

class TimeItemTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var imgEnd: UIImageView!
    @IBOutlet weak var lblStartDate: UIPaddedLabel!
    @IBOutlet weak var lblEndDate: UIPaddedLabel!
    @IBOutlet weak var btnEndDate: RoundedCornerUIButton!
    @IBOutlet weak var btnStartDate: RoundedCornerUIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var delegate : TimeItemTableViewCellDelegate?
    var viewModel : ExchangeRateViewModel?
    
    override func setupUI() {
        super.setupUI()
        lblStartDate.textColor = .white
        lblEndDate.textColor = .white
        lblStartDate.font = UIFont.Roboto.Bold.font(size: 14)
        lblEndDate.font = UIFont.Roboto.Bold.font(size: 14)
        btnStartDate.titleLabel?.font = UIFont.Roboto.Regular.font(size: 14)
        btnEndDate.titleLabel?.font = UIFont.Roboto.Regular.font(size: 14)
        btnStartDate.setTitleColor(.black, for: .normal)
        btnEndDate.setTitleColor(.black, for: .normal)
        btnStartDate.backgroundColor = .accent_3_color
        btnEndDate.backgroundColor = .accent_3_color
        heightConstraint.constant = UIScreen.main.bounds.height * 0.09
    }
    
    override func setupLanguage() {
        super.setupLanguage()
        lblStartDate.text = "From Time"
        lblEndDate.text = "To Time"
    }
    
    override func bindData() {
        super.bindData()
        btnStartDate.tapPublisher.sink {
            self.delegate?.didTapTime(type: .start_time)
        }.store(in: &bindings)
        
        btnEndDate.tapPublisher.sink {
            self.delegate?.didTapTime(type: .end_time)
        }.store(in: &bindings)
    }
    
    func setupCell(viewModel : inout ExchangeRateViewModel){
        self.viewModel = viewModel
        viewModel.selectedStartTimeCurrentValueSubject.sink {
            self.btnStartDate.setTitle($0, for: .normal)
        }.store(in: &bindings)
        
        viewModel.selectedEndTimeCurrentValueSubject.sink {
            self.btnEndDate.setTitle($0, for: .normal)
        }.store(in: &bindings)
    }
}


