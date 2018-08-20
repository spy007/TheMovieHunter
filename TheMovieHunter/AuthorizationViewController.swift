//
//  AuthorizationViewController.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/10/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var buttonGuestAuthentication: UIButton!
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var textUsername: UITextField!
    
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var switchRememberMe: UISwitch!
    
    private var isGetGuestSession = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("*** viewDidLoad()")
        
        textUsername.delegate = self
        
        textPassword.delegate = self
        
        let rememberMe = Defaults.getRememberMe()
        print("rememberMe=\(rememberMe)")
        
        if rememberMe {
            switchRememberMe.isOn = rememberMe
            let credentials = Defaults.getCredentials()
            textUsername.text = credentials.0
            textPassword.text = credentials.1
        }
        
        setControlsEnabled()
        
        setGuestAuthenticationButton()
    }
    
    override func viewWillAppear(_ animation: Bool) {
        super.viewWillAppear(animation)
        
        print("*** viewWillAppear()")
    }
    
    override func viewDidAppear(_ animation: Bool) {
        super.viewDidAppear(animation)
        
        print("*** viewDidAppear()")
    }
    
    override func viewWillDisappear(_ animation: Bool) {
        super.viewWillDisappear(animation)
        
        print("*** viewWillDisappear()")
    }

    override func viewDidDisappear(_ animation: Bool) {
        super.viewDidDisappear(animation)
        
        print("*** viewDidDisappear()")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func switchRememberMeChanged(_ sw: UISwitch) {
        let isSelected = sw.isOn
        switchRememberMe.isOn = isSelected
        Defaults.setRememberMe(rememberMe: isSelected)
    }
    
    @IBAction func buttonGuestAuthentication(_ sender: Any) {
        guestAuthorization()
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        if switchRememberMe.isOn {
            if let username = textUsername.text, let password = textPassword.text {
                Defaults.set(credentials: (username, password))
            }
        }
        
        buttonLogin.accessibilityLabel = "Currently there is problem to get response from server"
        
        var isDateExpired = true
        
        let date = Defaults.getExpireDate()
        
        if let expireDate = date {
            if let date = Utils.stringToDate(date: expireDate) {
                isDateExpired = date < Date()
            }
        }
        
        if isDateExpired {
            URLSession.shared.dataTask(with: UrlManager.getToken()) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                if let tokenJson = try? jsonDecoder.decode(TokenJson.self, from: data!) {
                    let success = tokenJson.success
                    print("session: \(success)")
                    
                    if success, let expireDate = tokenJson.expires_at, let requestToken = tokenJson.request_token {
                        Defaults.setRequestToken(requestToken: requestToken)
                        Defaults.setExpireDate(expireDate: Utils.utcDateToDate(utcDate: expireDate))
                        print("requestToken: \(requestToken) expires_at: \(expireDate)")
                        
                        self.loginProcess()
                    }
                }
                }.resume()
        } else {
            loginProcess()
        }
    }
    
    @IBAction func usernameEditing(_ sender: UITextField) {
        setControlsEnabled()
    }
    
    @IBAction func passwordChanging(_ sender: UITextField) {
        setControlsEnabled()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Private methods
    
    private func setControlsEnabled() {
        
        let isEnabled = !(textUsername.text?.isEmpty)! && !(textPassword.text?.isEmpty)!
        switchRememberMe.isEnabled = isEnabled
        buttonLogin.isEnabled = isEnabled
        
        switchRememberMe.isOn = Defaults.getRememberMe()
        
    }
    
    private func loginProcess() {
        
        DispatchQueue.main.async(execute: {
            self.goToMoviesList()
        })
        
        if true {
            return
        }
        
        // prepare json data
        if let requestToken = Defaults.getRequesToken() {
            let json: [String: String] = ["username": Constants.login,
                                          "password": Constants.password,
                                          "request_token" : requestToken]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            let url = URL(string: UrlManager.getValidateWithLogin())!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "****** No data from server")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? TokenJson {
                    print("****** Response on login request \(responseJSON)")
                } else {
                    print("Failed to authorize, username or password wrong") // add dialog
                }
                }.resume()
            
            self.goToMoviesList()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func setGuestAuthenticationButton() {
        
        if let guestExpireDate = Defaults.getGuestExpireDate() {
            if  let date = Utils.stringToDate(date: guestExpireDate) {
                isGetGuestSession = date < Date()
            }
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
            goToMoviesList()
        } else {
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
