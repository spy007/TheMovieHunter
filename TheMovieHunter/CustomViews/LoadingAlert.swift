//
//  WaitingBar.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 08.12.2017.
//  Copyright © 2017 ws-013-11b. All rights reserved.
//

import Foundation
import UIKit

class LoadingAlert {
    
    public static func create(title: String?, message: String) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        
        alertController.view.addSubview(spinnerIndicator)
        
        return alertController
    }
}
