//
//  Phone.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 07.12.2017.
//  Copyright © 2017 ws-013-11b. All rights reserved.
//

import Foundation

public class Phone : Decodable
{
    @objc dynamic var office = ""
    
    @objc dynamic var home: String!
    
    @objc dynamic var mobile: String!
    
    public func getOffice() -> String {
        return office;
    }
    
    public func setOffice (office: String) {
        self.office = office;
    }
    
    public func getHome() -> String {
        return home;
    }
    
    public func setHome (home: String) {
        self.home = home;
    }
    
    public func getMobile() -> String {
        return mobile;
    }
    
    public func setMobile (mobile: String) {
        self.mobile = mobile;
    }
}
