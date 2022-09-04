//
//  DBManager.swift
//  code_test
//
//  Created by Thinzar Soe on 9/3/22.
//

import Foundation
import RealmSwift
import RxSwift
import RxRelay
import RxRealm

enum  ROname : String {
    case BpiRO
}

class DBManager {
    private var   database:Realm
    static let   sharedInstance = DBManager()
    
    private init() {
        database = try! Realm()
        print("Realm >> ", Realm.Configuration.defaultConfiguration.fileURL!)
    }
}

extension DBManager {
    //MARK: - General CRUD
    public func retrieveDataList<T>(value: T.Type) -> Observable<[T]> where T: Object {
        let array = database.objects(T.self)
        return Observable.array(from: array)
    }
    
    public func retrieveDataListByKeyContains<T>(value: T.Type , key : String , val : String) -> Observable<[T]> where T: Object {
        let array = database.objects(T.self).filter("\(key) CONTAINS %@", val)
        return Observable.array(from: array)
    }
    
    public func retrieveDataListByKey<T>(value: T.Type , key : String , val : String) -> Observable<[T]> where T: Object {
        let array = database.objects(T.self).filter("\(key) = %@", val)
        return Observable.array(from: array)
    }
    
    public func retrieveDataListByKey<T>(value: T.Type , key : String , val : Int) -> Observable<[T]> where T: Object {
        let array = database.objects(T.self).filter("\(key) = %@", val)
        return Observable.array(from: array)
    }
    
    public func retrieveData<T>(value: T.Type) -> Observable<T> where T: Object {
        guard let data = database.objects(T.self).first else {
            return Observable.empty()
        }
        return Observable.from(object: data)
    }
    
    public func retrieveDataByKey<T>(value: T.Type, key: String, id: Int) -> Observable<T> where T: Object {
        guard let data = database.objects(T.self).filter("\(key) = %@", id).first else{
            return Observable.empty()
        }
        return Observable.from(object: data)
    }
    
    
    public func saveDataList<T>(dataList: [T], value: T.Type, failure: @escaping (String) -> Void) where T : Object {
        do{
            database.refresh()
            try database.safeWrite{
                dataList.forEach { (item) in
                    saveData(data: item, value: T.self) { (err) in
                        failure(err)
                    }
                }
            }
            
        }catch let exception {
            failure(exception.localizedDescription)
        }
    }
    
    public func saveData<T>(data: T, value: T.Type, failure: @escaping (String) -> Void) where T : Object {
        do{
            database.refresh()
            try database.safeWrite{
                database.add(data, update: .modified)
               
            }
            
        }catch let exception {
            print("Failed to save")
            failure(exception.localizedDescription)
        }
    }
    
    public func updateData(_ closure: @escaping () -> Void, failure: @escaping (String) -> Void) {
        do {
            database.refresh()
            try database.safeWrite {
                closure()
            }
        } catch {
            failure(error.localizedDescription)
        }
    }
    
    public func deleteDataList<T>(value: T.Type, success: @escaping(() -> Void), failure: @escaping(String) -> Void) where T: Object {
        do{
            database.refresh()
            try database.safeWrite{
                database.delete(database.objects(T.self))
                success()
            }
        }catch let exception {
            failure(exception.localizedDescription)
        }
    }
    
    func deleteData(objectArray: [Object], success: @escaping(() -> Void), failure: @escaping(String) -> Void )   {
        do{
            try database.write {
                database.delete(objectArray)
                print("completely deleted . . . ")
            }
            success()
        } catch {
            print("Realm Debug : error occur when deleting \(error)")
            failure(error.localizedDescription)
        }
    }
    
    func deleteData(dateTime : String,roName : ROname){
        do {
            try database.safeWrite {
                if let object = getObjectById(dateTime: dateTime, roName: roName) {
                    database.delete(object)
                }else{
                    print("object not found")
                }
            }
        }catch _ {
            print("testing Fail to delete")
            
        }
        
    }
    
    
    func deleteRealmData(success: @escaping(() -> Void), failure: @escaping(String) -> Void) {
        do{
            try database.safeWrite{
                database.deleteAll()
            }
            success()
            
        }catch let exception {
            failure(exception.localizedDescription)
        }
    }
    
    //MARK:- retrieve by predicate
    func getObjectById(dateTime : String,roName : ROname) -> Object? {
        let predicate = NSPredicate(format: "dateTime == \(dateTime)")
        
        switch roName {
        case .BpiRO:
            let result = database.objects(BpiRO.self).filter(predicate)
            return result.count > 0 ? result[0] : nil
        }
        
    }
}

