//
//  SearchSettingsViewControlViewController.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/30/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import os.log

class SearchSettingsViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lyOfMov: UILabel! // lower year of movies
    @IBOutlet weak var uyOfMov: UILabel! // upper year of movies
    @IBOutlet weak var rangeSlider: RangeSlider!
    
    private var genres: [Genre]? = []
    private var genresSelectedDict = [Int:Genre]()
    private var lowerValue: Double? = nil
    private var mng: CoreDataManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        
        self.mng = CoreDataManager()
        
        self.genres = self.mng?.getGenres()
        
        if let genresSelected = self.mng?.getGenresDict() {
            if genresSelected.count > 0 {
                self.genresSelectedDict = genresSelected
            } else {
                print("Fail: genres selected read from core data is empty")
            }
            
            self.setRangeSlider()
        } else {
            print("Fail: extracting genres selected from Core Data")
        }
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
        
        cell.labelGenre.text = genre?.name
        
        if let id = genre?.id {
            setSwitchView(sw: cell.switchGenre, id: id)
        } else {
            print("Fail: id is nil")
        }
        
        return cell
    }
    
    // MARK: Private methods
    
    private func setSwitchView(sw: UISwitch, id: String) {
        
        if let id = Int(id) {
            sw.tag = id
            if (genresSelectedDict.count > 0) {
                sw.isOn = (genresSelectedDict[id]?.selected)!
            } else {
                print("Fail: genres selected is empty")
            }
        }
        
        sw.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .touchUpInside)
    }
    
    private func setRangeSlider() {
        let range = Defaults.getMovieYearsRange()
        let min = range.0 // sets wrong lower value if set value which differs from range.0
        let max = range.1
        lowerValue = min
        
        // init RangeSlider view, found it needs to init both maximumValue and upperValue
        //        rangeSlider.minimumValue = min
        rangeSlider.lowerValue = min
        rangeSlider.maximumValue = max
        rangeSlider.upperValue = max
        
        // init labels under RangeSlider with year
        lyOfMov.text = MovieYearUtils.getMinYearOfMovies(userSelectedMinYearOfMovies: min)
        uyOfMov.text = MovieYearUtils.getMaxYearOfMovies(userSelectedMaxYearOfMovies: max)
        
        rangeSlider.tintColor = UIColor.green
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueDidChange(_:)), for: .valueChanged)
        rangeSlider.addTarget(self, action: #selector(rangeSliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @objc func onSwitchValueChanged(_ switchView: UISwitch) {
        let isOn = switchView.isOn
        let tag = switchView.tag
        print("switch changed witch tag=\(tag) isOn=\(isOn)")
        self.mng?.saveUserSelectedGenre(genreSelected: self.genresSelectedDict[tag], isSelected: isOn)
        switchView.isOn = isOn
    }
    
    @objc func rangeSliderValueDidChange(_ slider:RangeSlider!) {
        let lv = rangeSlider.lowerValue
        let uv = rangeSlider.upperValue
        
        if self.lowerValue != lv {
            self.lowerValue = lv
            lyOfMov.text = MovieYearUtils.getMinYearOfMovies(userSelectedMinYearOfMovies: lv)
        } else {
            uyOfMov.text = MovieYearUtils.getMaxYearOfMovies(userSelectedMaxYearOfMovies: uv)
        }
    }
    
    @objc func rangeSliderDidEndSliding(_ rangeSlider:RangeSlider!) {
        let lv = rangeSlider.lowerValue
        let uv = rangeSlider.upperValue
        
        Defaults.setMovieYearsRange(movieYear: (lv, uv))
    }
}
