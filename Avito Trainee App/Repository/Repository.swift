//
//  Repository.swift
//  Avito Trainee App
//
//  Created by Valya on 26.10.2022.
//

import RealmSwift

class Repository {
    static let shared = Repository()
    private init(){}
    private let service = Service.shared
    
    // MARK: - getCompany
    func getCompany(completion: @escaping (AvitoResponse?) -> (), errorCallback: @escaping (Error) -> ()) {
        let date = NSDate()
        var company: AvitoResponse? = nil
        let currentTime = date.timeIntervalSince1970
        print("=========")
        print(date)
        print(currentTime)
        
        do {
            let realm = try Realm()
            company = realm.objects(AvitoResponse.self).first
            
            if (company != nil) && (!needToUpdate(currentTime: currentTime)) {
                completion(company!)
            } else {
                service.loadCompany(completion: { companyResponse in
                    let dateToSave = DateWrapper()
                    dateToSave.currentDateForRealm = currentTime
                    self.saveCompanyData(companyResponse, dateToSave)
                    
                    completion(companyResponse)
                }) { error in
                    errorCallback(error)
                }
            }
        } catch {
            completion(nil)
            errorCallback(error)
            print(error)
        }
    }
    
    // MARK: - saveCompanyData
    private func saveCompanyData(_ company: AvitoResponse, _ whenSaved: DateWrapper) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.deleteAll()
                realm.add(company)
                realm.add(whenSaved)
            }
            
        } catch {
            print(error)
        }
    }
    
    // MARK: - needToUpdate
    private func needToUpdate(currentTime: TimeInterval) -> Bool {
        let realm = try! Realm()
        let lastTimeUpdate = realm.objects(DateWrapper.self).first?.currentDateForRealm
        
        if let lastTimeUpdateUnwrap = lastTimeUpdate {
            let timeDiff = currentTime - lastTimeUpdateUnwrap
            if timeDiff <= 3600 { // 1 час
                return false
            } else {
                return true
            }
        } else {
            return true
        }
    }
    
}
