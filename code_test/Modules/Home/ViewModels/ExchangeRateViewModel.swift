//
//  ExchangeRateViewModel.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import Foundation
import Combine
import RxSwift

class ExchangeRateViewModel: BaseViewModel {
    private let model: HomeModelProtocol
    let exchangeRatePublishSubject = PassthroughSubject<[SaveExchangeRateVO],Never>()
    let saveServerTimePublishSubject = PassthroughSubject<SaveServerTimeVO,Never>()
    let saveServerTimeListByDatePublishSubject = PassthroughSubject<[SaveServerTimeVO],Never>()
    let selectedCurrrencyTypePublishSubject = CurrentValueSubject<CurrencyType,Never>(.usd)
    
    let selectedStartDateCurrentValueSubject = CurrentValueSubject<String,Never>("")
    let selectedEndDateCurrentValueSubject = CurrentValueSubject<String,Never>("")
    let selectedStartTimeCurrentValueSubject = CurrentValueSubject<String,Never>("")
    let selectedEndTimeCurrentValueSubject = CurrentValueSubject<String,Never>("")
    
    var saveDataList : [SaveServerTimeVO] = []
    
    init(model: HomeModelProtocol = HomeModel()) {
        self.model = model
    }
}

extension ExchangeRateViewModel {
    func retrieveAllExchangeRate (){
        model.retrieveExchangeRateByCurrencyName(currencyName: selectedCurrrencyTypePublishSubject.value.getCurrencyName()).subscribe { [unowned self] list in
            exchangeRatePublishSubject.send(list.compactMap {$0.convertToVO()})
        } onError: { error in
            print(error)
        }.disposed(by: disposableBag)
    }
    
    func getSaveServerTimeByID(id : Int) {
        model.retrieveSaveServerTime(id: id).subscribe { [unowned self] serverTime in
            saveServerTimePublishSubject.send(serverTime.convertToVO())
        } onError: { error in
            print(error)
        }.disposed(by: disposableBag)
    }
    
    func retrieveSaveServerTimeByDate(date : String) {
        print(date)
        model.retrieveSaveServerTimeByDate(date: date).subscribe { [unowned self] list in
            saveDataList += list.compactMap {$0.convertToVO()}
            saveServerTimeListByDatePublishSubject.send(saveDataList)
        } onError: { error in
            print(error)
        }.disposed(by: disposableBag)
    }
}

