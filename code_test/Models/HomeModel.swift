//
//  HomeModel.swift
//  code_test
//
//  Created by Thinzar Soe on 9/2/22.
//

import Foundation
import Combine
import RxSwift

protocol HomeModelProtocol {
    func getExchangeRate() -> AnyPublisher<ExchangeRateResponse?, Error>
    func saveServerTime(data : SaveServerTimeVO)
    func retrieveSaveServerTimeList () -> Observable<[SaveServerTimeRO]>
    func saveExchangeRate(data : SaveExchangeRateVO)
    func retrieveSaveExchangeRateList () -> Observable<[SaveExchangeRateRO]>
    func retrieveExchangeRateByCurrencyName(currencyName : String) -> Observable<[SaveExchangeRateRO]>
    func retrieveSaveServerTime (id : Int) -> Observable<SaveServerTimeRO>
    func retrieveSaveServerTimeByDate (date : String) -> Observable<[SaveServerTimeRO]>
}

class HomeModel : HomeModelProtocol {
    let db = DBManager.sharedInstance
    
    deinit {
        
    }
    
    func getExchangeRate() -> AnyPublisher<ExchangeRateResponse?,Error> {
        let url = ApiConfig.ExchangeRate.getExchangeRateList.urlString()
        return ApiClient.shared.requestCombine(url: url).compactMap { (data) -> ExchangeRateResponse? in
            if let reponseData = data.decode(modelType: ExchangeRateResponse.self){
                return reponseData
            }
            return nil
        }.eraseToAnyPublisher()
    }
    
    func saveServerTime(data : SaveServerTimeVO) {
        let saveServerTimeROData = data.convertToRO()
        db.saveData(data: saveServerTimeROData, value: SaveServerTimeRO.self) {
            print($0)
        }
    }
    
    func retrieveSaveServerTimeList () -> Observable<[SaveServerTimeRO]> {
        return db.retrieveDataList(value: SaveServerTimeRO.self)
    }
    
    func saveExchangeRate(data : SaveExchangeRateVO) {
        let data = data.convertToRO()
        db.saveData(data: data, value: SaveExchangeRateRO.self) {
            print($0)
        }
    }
    
    func retrieveSaveExchangeRateList () -> Observable<[SaveExchangeRateRO]> {
        return db.retrieveDataList(value: SaveExchangeRateRO.self)
    }
    
    func retrieveExchangeRateByCurrencyName (currencyName : String) -> Observable<[SaveExchangeRateRO]> {
        return db.retrieveDataListByKey(value: SaveExchangeRateRO.self, key: "code", val: currencyName)
    }

    func retrieveSaveServerTime (id : Int) -> Observable<SaveServerTimeRO> {
        return db.retrieveDataByKey(value: SaveServerTimeRO.self, key: "id", id: id)
    }
    
    func retrieveSaveServerTimeByDate (date : String) -> Observable<[SaveServerTimeRO]> {
        return db.retrieveDataListByKeyContains(value: SaveServerTimeRO.self, key: "lastUpdateTime", val: date)
    }
}
