//
//  HomeViewModel.swift
//  code_test
//
//  Created by Thinzar Soe on 9/2/22.
//

import Foundation
import Combine
import RxSwift

class HomeViewModel: BaseViewModel {
    let exchangeRatePublishSubject = PassthroughSubject<[ExchangeRateVO],Never>()
    let lastUpdateTimePublishSubject = PassthroughSubject<String,Never>()
    
    private let model: HomeModelProtocol
    var saveServerTimeList: [SaveServerTimeVO] = []
    var saveExchangeRateList: [SaveExchangeRateVO] = []
    var saveServerTimeId : Int = 0
    init(model: HomeModelProtocol = HomeModel()) {
        self.model = model
    }
}

extension HomeViewModel {
    
    func getRate() {
        
    }
    
    func getExchangeRate() {
        model.getExchangeRate().sink(receiveCompletion: { [unowned self] in
            guard case .failure (let error ) = $0 else {return}
            errorPublishSubject.send(error)
        }) { [unowned self] (response) in
            if let responseData = response {
                print("......")
                print(responseData)
                if let time = responseData.time {
                    lastUpdateTimePublishSubject.send(time.updatedISO ?? "")
                    saveServerTimeId = getIdForSaveServerTime()
                    model.saveServerTime(data: SaveServerTimeVO(id: Int64(saveServerTimeId), lastUpdateTime: time.updatedISO))
                }
                self.fetchData(exchageResponse: responseData)
            }
        }.store(in: &bindings)
    }
    
    func fetchData(exchageResponse : ExchangeRateResponse) {
        var exchageRateList : [ExchangeRateVO] = []
        guard let dictionary = try? DictionaryEncoder().encode(exchageResponse.bpi) else {return}
        for key in dictionary.keys {
            if key == "USD" {
                if let data = dictionary["USD"] {
                    let id = getIdForExchangeRate()
                    let exchangeData = ExchangeRateVO(dictionary: data as! [String : Any])
                    exchageRateList.append(exchangeData)
                    model.saveExchangeRate(data: SaveExchangeRateVO(id: Int64(id), saveServerTimeId: Int64(saveServerTimeId), code: exchangeData.code, symbol: exchangeData.symbol, rate: exchangeData.rate, rate_float: exchangeData.rate_float))
                }
            } else if key == "GBP" {
                if let data = dictionary["GBP"] {
                    let id = getIdForExchangeRate()
                    let exchangeData = ExchangeRateVO(dictionary: data as! [String : Any])
                    exchageRateList.append(exchangeData)
                    model.saveExchangeRate(data: SaveExchangeRateVO(id: Int64(id), saveServerTimeId: Int64(saveServerTimeId), code: exchangeData.code, symbol: exchangeData.symbol, rate: exchangeData.rate, rate_float: exchangeData.rate_float))
                }
            } else if key == "EUR" {
                if let data = dictionary["EUR"] {
                    let id = getIdForExchangeRate()
                    let exchangeData = ExchangeRateVO(dictionary: data as! [String : Any])
                    exchageRateList.append(exchangeData)
                    model.saveExchangeRate(data: SaveExchangeRateVO(id: Int64(id), saveServerTimeId: Int64(saveServerTimeId), code: exchangeData.code, symbol: exchangeData.symbol, rate: exchangeData.rate, rate_float: exchangeData.rate_float))
                }
            }
        }
        exchangeRatePublishSubject.send(exchageRateList)
    }
    
    func getIdForSaveServerTime() -> Int {
        model.retrieveSaveServerTimeList().subscribe { [unowned self] serverTimeList in
            saveServerTimeList = serverTimeList.compactMap {$0.convertToVO()}
        } onError: { error in
            print(error)
        }.disposed(by: disposableBag)
        return saveServerTimeList.count + 1
    }
    
    func getIdForExchangeRate() -> Int {
        model.retrieveSaveExchangeRateList().subscribe { [unowned self] list in
            saveExchangeRateList = list.compactMap {$0.convertToVO()}
        } onError: { error in
            print(error)
        }.disposed(by: disposableBag)
        return saveExchangeRateList.count + 1
    }
}
