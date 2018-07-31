//
//  SearchSettings.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/24/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SearchSettingsControl1: UIStackView {
    
    // MARK: Properties
    var sliderLabel: UILabel? = nil
    private let minMovieYear: Float = 1902
    private let maxMovieYear = Float(Calendar.current.component(.year, from: Date())) // current year
    private let sliderWidth = 50
    private let sliderBarHeight = 50
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: CGFloat(sliderBarHeight)).isActive = true
        //        super.init(frame:CGRect(x: 0, y: 0, width: sliderWidth, height: sliderBarHeight))
        setupSettings()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupSettings()
    }
    
    // MARK: Private methods
    
    private func getSliderLabel() -> UILabel {
        let label = UILabel()
        label.text = "\(Int(maxMovieYear))"
        label.textAlignment = .center
        label.widthAnchor.constraint(equalToConstant: CGFloat(sliderWidth)).isActive = true
        
        return label
    }
    
    public func getSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = minMovieYear
        slider.maximumValue = maxMovieYear
        slider.setValue(maxMovieYear, animated: true)
        slider.isContinuous = true
//        slider.tintColor = UIColor.green
        slider.addTarget(self, action: #selector(SearchSettingsControl.sliderValueDidChange(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        return slider
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!) {
        let val = "\(Int(sender.value))"
        print("Slider val: " + val)
        sliderLabel?.text = val
    }
    
    @objc func sliderDidEndSliding(_ sender:UISlider!) {
        let val = "\(Int(sender.value))"
        print("Slider touch up: " + val)
        sliderLabel?.text = val
    }
    
    public func getSliderBar() -> UIStackView {
        
        let sliderStack = UIStackView(frame:CGRect(x: 0, y: 0, width: sliderWidth, height: sliderBarHeight))
        sliderStack.axis = .vertical
        sliderLabel = getSliderLabel()
        sliderStack.addArrangedSubview(sliderLabel!)
        sliderStack.addArrangedSubview(getSlider())
        
        return sliderStack
    }
    
    private func setupSettings() {
        axis = .horizontal
        spacing = 21
        addArrangedSubview(getSliderBar())
        addArrangedSubview(GenresControl())
        
    }
    
    
}
