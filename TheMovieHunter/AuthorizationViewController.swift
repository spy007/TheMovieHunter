//
//  AuthorizationViewController.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/10/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var buttonGuestAuthentication: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    
    private var isGetGuestSession = false
    
    override func viewDidAppear(_ animation: Bool) {
        super.viewDidAppear(animation)
        
        setGuestAuthenticationButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func buttonGuestAuthentication(_ sender: Any) {
        guestAuthorization()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: Private methods
    
    private func setGuestAuthenticationButton() {
        
        if let guestExpireDate = Defaults.getGuestExpireDate() {
            if  let date = Utils.stringToDate(date: guestExpireDate) {
                isGetGuestSession = date < Date()
            } else {
                isGetGuestSession = true
            }
        } else {
            isGetGuestSession = true
        }
        
        buttonGuestAuthentication.isHidden = !isGetGuestSession
        
        if !isGetGuestSession {
            goToMoviesList()
        }
    }
    
    private func goToMoviesList() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let movieTableViewController = storyBoard.instantiateViewController(withIdentifier: "MoviesTabBarController") as! MoviesTabBarController
                  present(movieTableViewController, animated: true, completion: nil)
//        navigationController?.pushViewController(movieTableViewController, animated: true)
    }
    
    private func guestAuthorization() {
        
        if !isGetGuestSession {
            return
        }
        
        URLSession.shared.dataTask(with: UrlManager.getGuestSession()) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let guestSessionJson = try? jsonDecoder.decode(GuestSessionJson.self, from: data!) {
                let success = guestSessionJson.success
                print("session: \(success)")
                
                if success, let guestExpireDate = guestSessionJson.expires_at {
                    Defaults.setGuestExpireDate(guestExpireDate: Utils.utcDateToDate(utcDate: guestExpireDate))
                    print("guest_session_id: \(guestSessionJson.guest_session_id  ?? "no session id") expires_at: \(guestExpireDate  ?? "expire date not provided by server")")
                    
                    self.goToMoviesList()
                }
            }
            }.resume()
    }
    
    func UTCToLocal(UTCDateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.dateFormat = "yyyy-MMM-dd hh:mm:ss" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }
}
