//
//  ViewController.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/9/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit
import os.log

class MovieViewController: UIViewController {
    
    var movie: MovieResults?
    
    @IBOutlet weak var labelMovieTitle: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie, let title = movie.title {
            labelMovieTitle.text = title
            let image_url = Constants.base_image_url + (movie.backdrop_path)!
            let downloadURL = URL(string: image_url)!
            movieImageView.af_setImage(withURL: downloadURL)
            ratingControl.starCount = Int(movie.popularity!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMovieMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMovieMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MovieViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let title = labelMovieTitle.text ?? ""
        
        // Set the movie to be passed to MealTableViewController after the unwind segue.
        //        movie = MovieResults()
        //        movie?.original_title = title
    }
    
}

