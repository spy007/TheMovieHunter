//
//  MovieSearchTableViewController.swift
//  TheMovieHunter
//
//  Created by ws-016-11b on 17.09.2018.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit
import PKHUD

class MovieSearchTableViewController: UITableViewController, UISearchBarDelegate, MovieSearchTableViewProtocol {
    

    
    var presenter: MovieSearchTablePresenterProtocol = MovieSearchTablePresenter()
    var searchBar: UISearchBar = UISearchBar()
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchBar
        presenter.viewDidLoad(view: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        return false
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        searchBar.resignFirstResponder()
        
        if let identifier = segue.identifier {
            
            if identifier == "ShowDetail" {
                guard let movieDetailViewController = segue.destination as? MovieViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedMovieCell = sender as? MovieTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedMovieCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedMovie = movies[indexPath.row]
                movieDetailViewController.movie = selectedMovie
                movieDetailViewController.genres = presenter.getGenres(with: selectedMovie)
                
            } else{
                fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count>0) {
            presenter.searchMovies(with: searchText)
        }
        else {
            movies = []
            presenter.showMovies(with: movies)
        }
        
    }
    
    func showMovies(with movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showLoading() {
        //TODO
    }
    
    func hideLoading() {
        //TODO
    }
    
    func showError(errorMessage: String) {
        DispatchQueue.main.async {
            HUD.flash(.label(errorMessage), delay: 2.0)
        }
    }
}
