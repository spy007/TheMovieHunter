//
//  MovieTableViewController.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 7/9/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import UIKit
import os.log
import Realm
import RealmSwift

class MovieTableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: Properties
    
    var loadingMoviesAlert: UIAlertController! = nil
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    var filtered: [Movie] = []
    var movies: [Movie] = []
    var mng: CoreDataManager? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UILabel()
        button.text = "Seatch settings"
        self.tableView.tableHeaderView?.addSubview(button)
        self.navigationController?.view.addSubview(button)
        
        mng = CoreDataManager()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        showAlert()
        
        // load from server
        loadMoviesData()
        
        // Setup delegates
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private methods
    
    private func loadMoviesData() {
        
        URLSession.shared.dataTask(with: UrlManager.getGenresUrl()) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let genresJson = try? jsonDecoder.decode(GenresJson.self, from: data!)
            
            if let genres = genresJson?.genres {
                DispatchQueue.main.async {
                    self.mng?.deleteAllData(entityName: String(describing: Genre.self))
                    self.mng?.save(navigationController: self.navigationController, movieGenres: genres)
                    
                    self.loadMovies(genres: genres)
                }
            }
            }.resume()
    }
    
    private func loadMovies(genres: [MovieGenre]?) {
        
        URLSession.shared.dataTask(with: UrlManager.getMoviesUrl()) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let responseModel = try? jsonDecoder.decode(MoviesJson.self, from: data!)
            
            if let movieResults = responseModel!.results {
                
                DispatchQueue.main.async {
                    self.mng?.deleteAllData(entityName: String(describing: Movie.self))
                    self.mng?.save(navigationController: self.navigationController, movieResults: movieResults, genres: genres)
                    
                    self.movies = (self.mng?.getMovies())!
                    
                    self.loadingMoviesAlert.dismiss(animated: true, completion: nil)
                    
                    self.tableView.reloadData()
                }
            }
            // TODO: it commented because it fails to save in realm because of problems with id:
            // https://stackoverflow.com/a/26152634/1931613
            // 'RLMException', reason: 'Primary key property 'id' does not exist on object 'MovieResults''
            // even if defined primaryKey() as it said to do according to above link
            
            //            RealmManager.addOrUpdate(model: Constants.model, object: responseModel, completionHandler: { (error) in
            //                if let err = error {
            //                    print("Error \(err.localizedDescription)")
            //                } else {
            //                    RealmManager.fetch(model: Constants.model, condition: nil, completionHandler: { (result) in
            //
            //                        for m in result {
            //                            if let movie = m as? MovieResults {
            //                                self.movies.append(movie)
            //                                print(movie.id)
            //                            }
            //                        }
            //
            //                        self.tableView.reloadData()
            //                    })
            //                }
            //            })
            }.resume()
    }
    
    private func showAlert() {
        self.loadingMoviesAlert = LoadingAlert.create(title: nil, message: Constants.alertLoadingMovies)
        self.present(self.loadingMoviesAlert, animated: false, completion: nil)
    }
    
    @objc private func showSearchSettings(button: UIButton) {
    
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
        if (searchActive) {
            movie = filtered[indexPath.row]
        }
        else {
            movie = movies[indexPath.row]
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
            let realm = try! Realm()
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame: CGRect = tableView.frame
        
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 50))
        headerView.addSubview(SearchSettingsControl())
        return headerView
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        print("Slider value changed")
        
        // Use this code below only if you want UISlider to snap to values step by step
        
        print("Slider step value \(Int(sender.value))")
    }
    
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
            self.tableView.reloadData()
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
            self.tableView.reloadData()
        }
    }
    
}
