//
//  PickerGenre.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/26/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation
import UIKit

class GenresControl1: UIStackView,  UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: Properties
    
    private var genres: [String]? = ["One", "Two"]
    private var picker: UIPickerView? = nil
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        translatesAutoresizingMaskIntoConstraints = false
        //        heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        //        super.init(frame:CGRect(x: 0, y: 0, width: sliderWidth, height: sliderBarHeight))
        setupGenres()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupGenres()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        if component == 0 {
        //            return 10
        //        } else {
        //            return 100
        //        }
        return (genres?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //        if component == 0 {
        //            return "First \(row)"
        //        } else {
        //            return "Second \(row)"
        //        }
        return genres?[row]
    }
    
    private func setupGenres() {
        
        
        axis = .horizontal
        spacing = 4
        
                picker = UIPickerView()
                picker?.widthAnchor.constraint(equalToConstant: Constants.pickerGenresWidth).isActive = true
                picker?.delegate = self
        
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: Constants.pickerGenresWidth).isActive = true
        label.text = Constants.labelGenres
                addArrangedSubview(label)
                addArrangedSubview(picker!)
        //        let picker = UIPickerView()
        //        picker.translatesAutoresizingMaskIntoConstraints = false
        //
        //        picker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        //        picker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        //        picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        //
    }
}
