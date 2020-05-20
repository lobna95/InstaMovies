//
//  movies.swift
//  InstaMovies
//
//  Created by Lobna on 5/19/20.
//  Copyright © 2020 Lobna. All rights reserved.
//

import Foundation

class MoviesRequest{
    static let instance = MoviesRequest()

    func getMovies(page: String, _ completion: @escaping(_ movies: Movies?,_ error: Error?)->()) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=acea91d2bff1c53e6604e4985b6989e2&age=1&page=\(page)") else {return}
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            do{
                let movies = try JSONDecoder().decode(Movies.self, from: data)
                completion(movies, nil)
//                for result in movies.results{
//                    print(result.original_title)
//                }
                
            }catch{
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func getMovieImage(){
        
    }
}
