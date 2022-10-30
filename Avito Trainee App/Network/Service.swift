//
//  Service.swift
//  Avito Trainee App
//
//  Created by Valya on 26.10.2022.
//

// https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c

import UIKit

class Service {
    static let shared = Service()
    private init(){
        urlComponents.scheme = "https"
        urlComponents.host = "run.mocky.io"
        urlComponents.path = "/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    }
    
    var urlComponents = URLComponents()
    let session = URLSession(configuration: .default)
    
    func loadCompany(completion: @escaping (AvitoResponse) -> (), errorCallback: @escaping (Error) -> ()) {
        session.dataTask(with: urlComponents.url!) { data, res, err in
            if let err = err {
                // Ошибка сети
                print(err.localizedDescription)
                DispatchQueue.main.async {
                    errorCallback(err)
                }
            } else if let unwrappedData = data {
                do {
                    let avitoResponse = try JSONDecoder().decode(AvitoResponse.self, from: unwrappedData)
                    DispatchQueue.main.async {
                        completion(avitoResponse)
                    }
                } catch {
                    // Ошибка декодирования JSON
                    DispatchQueue.main.async {
                        errorCallback(error)
                    }
                    print(error)
                }
            }
        }.resume()
    }
}
