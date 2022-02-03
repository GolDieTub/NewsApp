//
//  APInews.swift
//  NewsApp
//
//  Created by Uladzimir on 02.02.2022.
//

import Foundation

final class APInews{
    static let shared = APInews()
    
    struct Constants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=c79d2d0159a54a0ba19ea4e8285a8b3c")
        static let searchURLString = "https://newsapi.org/v2/everything?sortBy=publishedAt&apiKey=c79d2d0159a54a0ba19ea4e8285a8b3c&q="
    }

    private init(){}

    public func getTopNews(completion: @escaping (Result<[Article],Error>) -> Void){
        guard let url = Constants.topHeadLinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    public func search(with query: String, completion: @escaping (Result<[Article],Error>) -> Void){
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        let urlString = Constants.searchURLString + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url){ data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//Models

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable{
    let name: String
}
