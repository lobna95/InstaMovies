//
//  savedMovieModel.swift
//  InstaMovies
//
//  Created by Lobna on 5/20/20.
//  Copyright © 2020 Lobna. All rights reserved.
//

import Foundation

class SavedMovie: Codable{
    var title: String = ""
    var overview: String = ""
    var date: String = ""
    var image: Data? = nil
}
