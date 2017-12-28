//
//  Database.swift
//  WeatherApp
//
//  Created by Mohd Zulhilmi Mohd Zain on 28/12/2017.
//  Copyright © 2017 MZMZ. All rights reserved.
//

import UIKit
import RealmSwift

class Database: NSObject {

}

class Condition: Object {
    
    @objc dynamic var date = ""
    @objc dynamic var temp = ""
    @objc dynamic var text = ""
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class Forecast: Object {
    
    @objc dynamic var date = ""
    @objc dynamic var temp = ""
    @objc dynamic var text = ""
    @objc dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
