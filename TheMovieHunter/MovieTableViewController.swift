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

class MovieTableViewController: UITableViewController {
    
    var movies = [MovieResults?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        loadMovies()
        //        loadContacts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMovies() {
        print("Printing movies: ")
        
        let url = URL(string: Constants.base_url)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let responseModel = try? jsonDecoder.decode(Json4Swift_Base.self, from: data!)
            
            if let movies = responseModel!.results {
                self.movies = movies
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            // TODO: it commented because it fails to save in realm because of problems with id:
            // https://stackoverflow.com/a/26152634/1931613
            // 'RLMException', reason: 'Primary key property 'id' does not exist on object 'MovieResults''
            // even if defined primaryKey() as it said to do according to above link
            //                RealmManager.addOrUpdate(model: self.model, object: responseModel?.results, completionHandler: { (error) in
            //                    if let err = error {
            //                        print("Error \(err.localizedDescription)")
            //                    } else {
            //                        RealmManager.fetch(model: self.model, condition: nil, completionHandler: { (result) in
            //
            //                            for m in result {
            //                                if let movie = m as? MovieResults {
            //                                    self.movies.append(movie)
            //                                    print(movie.title)
            //                                }
            //                            }
            //
            //                            self.tableView.reloadData()
            //                        })
            //                    }
            //                })
        }
        
        task.resume()
    }
    
    func loadContacts() {
        print("Printing contacts: ")
        
        HttpGetRequest.getContacts("https://api.androidhive.info/contacts/") { (contactsArr) -> Void in
            
            if contactsArr != nil, contactsArr.count > 0  {
                RealmManager.addOrUpdate(model: Constants.model, object: contactsArr, completionHandler: { (error) in
                    if let err = error {
                        print("Error \(err.localizedDescription)")
                    } else {
                        RealmManager.fetch(model: Constants.model, condition: nil, completionHandler: { (result) in
                            
                            for contact in result {
                                if let c = contact as? Contact {
                                    //                            self.contacts.append(c)
                                    //                                    print(c.getName())
                                }
                            }
                            
                            self.tableView.reloadData()
                        })
                    }
                })
            }
        }
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
            fatalError("The dequeued cell is not an instance of ContactTableViewCell.")
        }
        
        let movie = movies[indexPath.row]
        if movie != nil {
            cell.labelMovie.text = movie?.original_title
            // set image by url async
            if let url = movie?.backdrop_path {
                let image_url = Constants.base_image_url + url
                let downloadURL = URL(string: image_url)!
                cell.movieImageView.af_setImage(withURL: downloadURL)
                cell.ratingControl.starCount = 2// Int((movie?.popularity)!)
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
            //
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
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
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
}
