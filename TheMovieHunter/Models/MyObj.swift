//
//  MyObj.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/17/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation
import RealmSwift

class MyObj: Object, Decodable {
    @objc dynamic var id = 0
    
    func set(_ newId: Int) { self.id = newId }
    
    override public class func primaryKey() -> String? {
        return "id"
    }
}
