//
//  HttpGetRequest.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 06.12.2017.
//  Copyright © 2017 ws-013-11b. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HttpGetRequest {
    public static func getContacts(_ url: String, getContactsOperation: @escaping ([Contact]) -> Void) {
        
        getData(url) {(getDataOperationResult) -> Void in
            do {
                let contactsWrapper =  try JSONDecoder().decode(ContactsWrapper.self, from: getDataOperationResult)
                getContactsOperation(contactsWrapper.contacts)
            } catch let jsonErr {
                print("Error serializing json", jsonErr)
            }
        }
    }
    
    private static func getData(_ url: String, responseDataOperation: @escaping (Data) -> Void) {
        
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if let data = responseData.data {
                responseDataOperation(data)
            }
        }
    }
}
