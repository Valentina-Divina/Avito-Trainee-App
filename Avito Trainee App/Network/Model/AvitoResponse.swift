//
//  AvitoResponse.swift
//  Avito Trainee App
//
//  Created by Valya on 24.10.2022.
//

import UIKit
import RealmSwift

   // MARK: - AvitoResponse
    class AvitoResponse: Object, Decodable {
      @Persisted var company: CompanyResponse?
    }

    // MARK: - CompanyResponse
    class CompanyResponse: Object, Decodable {
        @Persisted var name: String
        @Persisted var employees: List<EmployeeResponse>
    }

    // MARK: - EmployeeResponse
    class EmployeeResponse: Object, Decodable {
        @Persisted var name: String
        @Persisted var phoneNumber: String
        @Persisted var skills: List<String>

        enum CodingKeys: String, CodingKey {
            case name
            case phoneNumber = "phone_number"
            case skills
        }
    }

