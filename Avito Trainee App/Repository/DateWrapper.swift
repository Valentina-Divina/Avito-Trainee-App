//
//  CurrentDataForRealm.swift
//  Avito Trainee App
//
//  Created by Valya on 27.10.2022.
//

import UIKit
import RealmSwift

class DateWrapper: Object {
  @Persisted var currentDateForRealm: Double?
}
