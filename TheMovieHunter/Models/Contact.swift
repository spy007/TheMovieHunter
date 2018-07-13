//
//  Contacts.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 07.12.2017.
//  Copyright © 2017 ws-013-11b. All rights reserved.
//

import Foundation
import RealmSwift

public class Contact: Object, Decodable {
    @objc dynamic var id: String!
    
    var phone: Phone!
    
    @objc dynamic var address: String!
    
    @objc dynamic var email: String!
    
    @objc dynamic var name: String!
    
    @objc dynamic var gender: String!
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    public func getId() -> String {
        return id
    }
    
    public func setId (id: String) {
    self.id = id
    }
    
    public func getPhone() -> Phone {
    return phone
    }
    
    public func setPhone(phone: Phone) {
        self.phone = phone
    }
    
    public func getAddress() -> String {
    return address
    }
    
    public func setAddress (address: String) {
        self.address = address
    }
    
    public func getEmail() -> String {
        return email
    }
    
    public func setEmail (email: String) {
    self.email = email
    }
    
    public func getName() -> String {
        return name
    }
    
    public func setName (name: String) {
        self.name = name
    }
    
    public func getGender() -> String {
        return gender
    }
    
    public func setGender (gender: String) {
        self.gender = gender
    }
}
