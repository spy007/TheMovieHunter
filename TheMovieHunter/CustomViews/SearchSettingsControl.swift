//
//  SearchSettings.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/24/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation
import UIKit

class SearchSettingsControl: UIStackView {
    
    // MARK: Properties
    
    private var sliderLabel = UILabel()
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setControl()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setControl()
    }
    
    // MARK: Private methods
    
    private func getSlider() -> UISlider {
        let slider = UISlider(frame:CGRect(x: 0, y: 25, width: 300, height: 20))
        slider.minimumValue = 1902
        slider.maximumValue = Float(Calendar.current.component(.year, from: Date())) // current year
        slider.isContinuous = true
        slider.tintColor = UIColor.green
        slider.addTarget(self, action: #selector(MovieTableViewController.sliderValueDidChange(_:)), for: .valueChanged)
        
        return slider
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!) {
        print("Slider value changed")
        
        // Use this code below only if you want UISlider to snap to values step by step
        
        print("Slider step value \(Int(sender.value))")
    }
    
    private func setControl() {
        
        let sliderStack = UIStackView()
        sliderStack.axis = .vertical
        sliderStack.spacing = 2
        sliderStack.addArrangedSubview(sliderLabel)
        sliderStack.addArrangedSubview(getSlider())
        
        addArrangedSubview(sliderLabel)
    }
    
}
