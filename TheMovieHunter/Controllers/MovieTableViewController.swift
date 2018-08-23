//
//  MovieTableViewController.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/9/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit
import os.log
import PKHUD

class MovieTableViewController: UITableViewController, UISearchBarDelegate, MovieTableViewProtocol {
    
    //MARK: Properties
    
    // TODO: figure out how not to initialize presenter below like in IOS-Viper-Architecture project
    var presenter: MovieTablePresenterProtocol?
    var loadingMoviesAlert: UIAlertController? = nil
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        presenter = MovieTablePresenter()
    }
    
    override func viewWillAppear(_ animation: Bool) {
        super.viewWillAppear(animation)
        
        presenter?.viewWillAppear(view: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MovieTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MovieTableViewCell.")
        }
        
        var movie: Movie?
        let idx = indexPath.row
        if idx <= movies.count - 1 {
            movie = movies[idx]
            
            if movie != nil {
                cell.labelMovie.text = movie?.title
                // set image by url async
                if let image_path = movie?.backdrop_path {
                    cell.movieImageView.af_setImage(withURL: UrlManager.getImageUrl(imgPath: image_path))
                    if let vote = Int((movie?.vote_average)!/2) as Int? {
                        cell.ratingControl.voteAverage = vote
                    }
                }
            }
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let identifier = segue.identifier {
            
            if identifier == "ShowDetail" {
                guard let movieDetailViewController = segue.destination as? MovieViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedMovieCell = sender as? MovieTableViewCell else {
                    fatalError("Unexpected sender: \(sender)")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedMovieCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedMovie = movies[indexPath.row]
                movieDetailViewController.movie = selectedMovie
                movieDetailViewController.genres = presenter?.getGenres(with: selectedMovie)
                
            } else {
                fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
            }
        }
    }
    
    @IBAction func unwindToMovieList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? MovieViewController, let movie = sourceViewController.movie {
            
            // Add a new movie.
            let newIndexPath = IndexPath(row: movies.count, section: 0)
            
            movies.append(movie)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing movie.
                movies[selectedIndexPath.row] = movie
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new movie.
                let newIndexPath = IndexPath(row: movies.count, section: 0)
                
                movies.append(movie)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        presenter?.searchActive(searchActive: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        presenter?.searchActive(searchActive: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        presenter?.searchActive(searchActive: true)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        presenter?.searchActive(searchActive: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        presenter?.searchMovies(with: searchText)
    }
    
    func showMovies(with movies: [Movie]) {
        
        self.movies = movies
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Public methods
    
    func showLoading() {
        let appName = Utils.getAppName() 
        
        DispatchQueue.main.async {
            let hud = PKHUDProgressView(title: appName, subtitle: Constants.messageLoadingMovies)
            hud.subtitleLabel.textAlignment = .center
            PKHUD.sharedHUD.contentView = hud
            PKHUD.sharedHUD.show()
        }
    }
    
    func hideLoading() {
        
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
    
    func showError(errorMessage: String) {
        
        DispatchQueue.main.async {
            HUD.flash(.label(errorMessage), delay: 2.0)
        }
    }
}
