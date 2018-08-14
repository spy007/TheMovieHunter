//
//  RatingControl.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/13/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit

@IBDesignable class VoteControl: UIStackView {
    
    //MARK: Properties
    private var voteStars = [UIButton]()
    @IBInspectable var starSize: CGSize = CGSize(width: Constants.imageStarSize, height: Constants.imageStarSize) {
        didSet {
            setupVote()
        }
    }
    
    @IBInspectable var voteAverage: Int = Constants.starsCount {
        didSet {
            setupVote()
        }
    }
    
    var rating = 0
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVote()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupVote()
    }
    
    //MARK: Private Methods
    
    private func setupVote() {
        
        // Clear any existing buttons
        for button in voteStars {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        voteStars.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named:Constants.imageStarEmpty, in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: Constants.imageStarFilled, in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:Constants.imageStarHighlighted, in: bundle, compatibleWith: self.traitCollection)
        
        let voteAve = voteAverage // because there are 5 stars but vote can be 10
        for stars in 0..<Constants.starsCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            if (stars < voteAve) {
                button.setImage(filledStar, for: .normal)
            } else {
                button.setImage(emptyStar, for: .normal)
            }
//            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Setup the button action
            button.addTarget(self, action: #selector(VoteControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            voteStars.append(button)
        }
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
    }
}
