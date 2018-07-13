//
//  RealmManager.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 11.12.2017.
//  Copyright © 2017 ws-013-11b. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmManagerOld {
    
    public static func addOrUpdate(obj: Contact) {
        //DispatchQueue.global(qos: .userInitiated).async {
        let realm = try! Realm()
        do {
            try realm.write({
                realm.add(obj, update: true)
                print("^^^ Contact stored.")
            })
        }catch let err {
            print("^^^^^^^^^^^^^^ERROR \(err.localizedDescription)")
        }
    }
    
    public static func fetch() -> Results<Contact>? {
        let realm = try! Realm()
        return realm.objects(Contact.self)
    }
}
