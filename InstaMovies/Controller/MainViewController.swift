//
//  MainViewController.swift
//  InstaMovies
//
//  Created by Lobna on 5/18/20.
//  Copyright © 2020 Lobna. All rights reserved.
//

import UIKit

// MARK: - Popup view controller
var detailsViewController: MovieDetailsViewController = {
    let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailsViewController")
    return popupViewController as! MovieDetailsViewController
}()

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var allMoviesView: UIView!
    @IBOutlet weak var myMoviesView: UIView!
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var allmovies = [Results]()
    var page: String = "1"
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Movies.plist")
    var myMovies = [SavedMovie]()
    
    var allMovies: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        loadAllMovies()
    }
    
    func loadAllMovies(){
        MoviesRequest.instance.getMovies(page: page) { (movies, error) in
            if error == nil{
                self.allmovies.removeAll()
                guard let movies = movies else{return}
                for movie in movies.results{
                    self.allmovies.append(movie)
                }
                DispatchQueue.main.async {
                    self.moviesTableView.reloadData()
                }
            }else{
                print(error)
            }
        }
    }
    
    func loadMyMovies(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                myMovies = [try decoder.decode(SavedMovie.self, from: data)]
                moviesTableView.reloadData()
            }catch{
                print("Error Decoding Movie Data \(error)")
            }
        }
    }
    
    @IBAction func allMoviesTapGesture(_ sender: UITapGestureRecognizer) {
        print("All Movies Tapped")
        allMovies = true
        loadAllMovies()
    }
    
    @IBAction func myMoviesTapGesture(_ sender: UITapGestureRecognizer) {
        print("My Movies Tapped")
        allMovies = false
        loadMyMovies()
    }
    
}
// MARK: - TableView Delegates & Datasource
extension MainViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allMovies{
            return allmovies.count
        }else{
            return myMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        if allMovies{
            if allmovies.count != 0{
                cell.movieTitleLabel.text = self.allmovies[indexPath.row].original_title
                //MARK: - This Could should retrive image but I can not retrive image from the url given from response
                //                    let imageURL = URL(string:self.movies[indexPath.row].poster_path)?api_key=acea91d2bff1c53e6604e4985b6989e2&age=1")
                //                    print(imageURL)
                //                    let imageTask = URLSession.shared.dataTask(with: imageURL!) { (imageData, _, imageError) in
                //                        if let imageError = imageError { print(imageError); return }
                //                        DispatchQueue.main.async {
                //                            print("SEt image")
                //                            print(imageData)
                //                            let apodImage = UIImage(data: imageData!)
                //                            cell.movieImage.image = apodImage
                //                            // do something with the image view
                //                        }
                //                    }
                //                    imageTask.resume()
                
            }
        }else{
            if myMovies.count != 0{
                cell.movieTitleLabel.text = myMovies[indexPath.row].title
                let image = UIImage(data: myMovies[indexPath.row].image!)
                cell.movieImage.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popOverVC = detailsViewController
        if allMovies{
            popOverVC.AllMovieDetail = allmovies[indexPath.row]
        }else{
            popOverVC.myMovieDetail = myMovies[indexPath.row]
        }
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            // Notify interested parties that end has been reached
        }
    }
}
