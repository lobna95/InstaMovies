//
//  MovieDetailsViewController.swift
//  InstaMovies
//
//  Created by Lobna on 5/20/20.
//  Copyright © 2020 Lobna. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var AllMovieDetail : Results?
    var myMovieDetail : SavedMovie?
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displayMovieData()
    }
    
    func displayMovieData(){
        if let movie = AllMovieDetail{
            titleLabel.text = movie.title
            fontSize(label: titleLabel)
            releaseDateLabel.text = movie.release_date
            overviewLabel.text = movie.overview
            fontSize(label: overviewLabel)
        }else if let movie = myMovieDetail{
            titleLabel.text = movie.title
            fontSize(label: titleLabel)
            releaseDateLabel.text = movie.date
            overviewLabel.text = movie.overview
            fontSize(label: overviewLabel)
        }
    }
    
    func fontSize(label: UILabel){
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
    }
    
    @IBAction func closeBtn(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
}
