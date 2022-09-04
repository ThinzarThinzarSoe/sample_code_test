//
//  CalculatorViewModel.swift
//  code_test
//
//  Created by Thinzar Soe on 9/4/22.
//

import Foundation
import Combine
import RxSwift

class CalculatorViewModel: BaseViewModel {
    let exchangeRatePublishSubject = PassthroughSubject<[SaveExchangeRateVO],Never>()
    let lastUpdateTimePublishSubject = PassthroughSubject<String,Never>()
    let selectedCurrrencyTypePublishSubject = CurrentValueSubject<CurrencyType,Never>(.usd)
    let currencyRatePublishSubject = CurrentValueSubject<Double,Never>(0.0)
    let tfFromPublishSubject = CurrentValueSubject<String,Never>("0.0")
    let model: HomeModelProtocol
    
    init(model: HomeModelProtocol = HomeModel()) {
        self.model = model
    }
}

extension CalculatorViewModel {
    
    func retrieveAllExchangeRate (){
        model.retrieveSaveExchangeRateList().subscribe { [unowned self] list in
            let data = list.compactMap {$0.convertToVO()}
            exchangeRatePublishSubject.send(data.suffix(3))
        } onError: { error in
            print(error)
        }.disposed(by: disposableBag)
    }
}

