//
//  MovieTableViewController.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/9/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit
import os.log

class MovieTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: Properties
    
    var loadingMoviesAlert: UIAlertController? = nil
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    var filtered: [Movie] = []
    var movies: [Movie] = []
    var mng: CoreDataManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //       showAlert()
        
        // Setup delegates
        searchBar.delegate = self
        
        mng = CoreDataManager()
    }
    
    override func viewWillAppear(_ animation: Bool) {
        super.viewWillAppear(animation)
        
        self.loadMoviesData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    
    private func loadMoviesData() {
        
        URLSession.shared.dataTask(with: UrlManager.getGenresUrl()) { (data, response, error) in
            if let mng = self.mng {
                let jsonDecoder = JSONDecoder()
                let genresJson = try? jsonDecoder.decode(GenresJson.self, from: data!)
                
                if let genres = genresJson?.genres {
                    // Code in here is now running "in the background" and can safely
                    // do anything in privateContext.
                    // This is where you will create your entities and save them.
                    Utils.getPrivateContext().perform {
                        if !Defaults.keyExists(key: Defaults.selectedGenresKey) {
                            mng.save(genresResponse: genres)
                            mng.saveSelectedGenres()
                        }
                        self.loadMovies()
                    }
                }
            }
            }.resume()
    }
    
    private func loadMovies() {
        
        self.mng?.deleteAllData(entity: String(describing: Movie.self))
        
        let moviesYearRange = Defaults.getMovieYearsRange()
        let maxYear = Int(moviesYearRange.1)
        let minYear = Int(moviesYearRange.0)
        
        self.movies.removeAll()
        
        for y in minYear...maxYear {
            
            URLSession.shared.dataTask(with: UrlManager.getMoviesUrlByYear(year: Int(Constants.minMovieYear)+y)) { (data, response, error) in
                let jsonDecoder = JSONDecoder()
                
                let responseModel = try? jsonDecoder.decode(MoviesJson.self, from: data!)
                
                if let movieResults = responseModel!.results {
                    if !Defaults.keyExists(key: Defaults.selectedGenresKey) {
                        // not to make movies list empty if user have not yet selected genres
                        if let genreSelected = self.mng?.getGenresDict()![Constants.actionId] {
                            self.mng?.saveSelectedGenre(genreSelected: genreSelected, isSelected: true)
                        }
                    }
                    if let movs = self.mng?.save(movieResults: movieResults) {
                        if movs.count > 0 {
                            self.movies += movs
                        }
                    }
                }
                
                if y == maxYear {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
                }.resume()
        }
        
        // Will use later
        //        DispatchQueue.main.async {
        //            self.loadingMoviesAlert?.dismiss(animated: true, completion: nil)
        //        }
    }
    
    private func showAlert() {
        self.loadingMoviesAlert = LoadingAlert.create(title: nil, message: Constants.alertLoadingMovies)
        self.present(self.loadingMoviesAlert!, animated: false, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive) {
            return filtered.count
        }
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
            if (searchActive) {
                movie = filtered[idx]
            }
            else {
                movie = movies[idx]
            }
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
            
            let deletedItem = movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //            let predicate = NSPredicate(format: "id == %@", deletedItem.getId())
            //ead
            //            if let productToDelete = realm.objects(Contact.self)
            //                .filter(predicate).first {
            //                realm.delete(productToDelete)
            //            }
            //
            //            RealmManager.deleteObject(object: deletedItem, completionHandler: { (error) in
            //                if let err = error {
            //                    print("Error \(err.localizedDescription)")
            //                }
            //            })
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Try create header in list later
    /*
     
     override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return Constants.searchSettingsHeight
     }
     
     override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
     let frame: CGRect = tableView.frame
     
     let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: Constants.searchSettingsHeight))
     
     headerView.addSubview(SearchSettingsControl())
     return headerView
     }
     */
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new movie.", log: OSLog.default, type: .debug)
            
        case "Show":
            print("Show")
            
        case "ShowDetail":
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
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
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
                
                RealmManager.addOrUpdate(model: Constants.model, object: movie, completionHandler: { (error) in
                    if let err = error {
                        print("Error \(err.localizedDescription)")
                    }
                })
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            searchActive = false;
        } else {
            filtered = movies.filter({ (movie) -> Bool in
                let tmp: NSString = movie.title! as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            if(filtered.count == 0){
                searchActive = false;
            } else {
                searchActive = true;
            }
        }
        
        self.tableView.reloadData()
    }
    
    @objc func searchTapped(sender:UIButton) {
        print("search pressed")
    }
    
    @objc func addTapped (sender:UIButton) {
        print("add pressed")
    }
    
}
