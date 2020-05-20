//
//  moviesModel.swift
//  InstaMovies
//
//  Created by Lobna on 5/19/20.
//  Copyright © 2020 Lobna. All rights reserved.
//

import Foundation

struct Movies: Decodable{
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Results]
}

struct Results: Decodable{
    let popularity: Double
    let vote_count: Int
    let video: Bool
    let poster_path: URL
    let id: Int
    let adult: Bool
    let backdrop_path: String
    let original_language: String
    let original_title: String
    let genre_ids: [Int]
    let title: String
    let vote_average: Double
    let overview: String
    let release_date: String
}
