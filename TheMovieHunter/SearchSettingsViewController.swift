//
//  SearchSettingsViewControlViewController.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/30/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit

class SearchSettingsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelYearOfMovie: UILabel!
    
    @IBOutlet weak var sliderYearOfMovie: UISlider!
    
    var genres: [Genre]? = []
    private let minMovieYear: Float = 1902
    private let maxMovieYear = Float(Calendar.current.component(.year, from: Date()))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "icon_settings_1x"), tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        genres = CoreDataManager().getGenres()
        
        labelYearOfMovie.text = "\(Int(maxMovieYear))"
        setSlider()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres!.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! GenreTableViewCell
        
        let genre = genres?[indexPath.row]
        cell.genre = genre
        
        cell.labelGenre.text = genre?.name
        
        return cell
    }
    
    private func setSlider() {
        if let slider = sliderYearOfMovie {
            slider.minimumValue = minMovieYear
            slider.maximumValue = maxMovieYear
            slider.setValue(maxMovieYear, animated: true)
            slider.isContinuous = true
            slider.tintColor = UIColor.green
            slider.addTarget(self, action: #selector(SearchSettingsControl.sliderValueDidChange(_:)), for: .valueChanged)
            slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        }
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!) {
        let val = "\(Int(sender.value))"
        print("Slider val: " + val)
        labelYearOfMovie?.text = val
    }
    
    @objc func sliderDidEndSliding(_ sender:UISlider!) {
        let val = "\(Int(sender.value))"
        print("Slider touch up: " + val)
        labelYearOfMovie?.text = val
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
