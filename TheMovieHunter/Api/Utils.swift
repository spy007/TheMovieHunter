//
//  Utils.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/18/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Utils {
    
    func doubleToInteger(data:Double)-> Int {
        let doubleToString = "\(data)"
        let stringToInteger = (doubleToString as NSString).integerValue
        
        return stringToInteger
    }
    
    class func stringToDate(date: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: date)
    }
    
    class func utcDateToDate(utcDate: String) -> String {
        let end = utcDate.index(utcDate.startIndex, offsetBy: utcDate.count - " UTC".count)
        return String(utcDate[utcDate.startIndex..<end])
    }
    
    /* It allows to run code in background */
    class func getPrivateContext() -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = getContext().persistentStoreCoordinator
        
        return privateContext
    }
    
    class func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}
