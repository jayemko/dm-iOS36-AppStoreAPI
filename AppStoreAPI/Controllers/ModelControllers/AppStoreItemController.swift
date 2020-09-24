//
//  AppStoreItemController.swift
//  AppStoreAPI
//
//  Created by Jason Koceja on 9/24/20.
//

import Foundation
import UIKit.UIImage

// https://itunes.apple.com/search?term=<#searchTerm#>&entity=software
// https://itunes.apple.com/search?term=<#searchTerm#>&entity=musicTrack

struct StringConstants {
    fileprivate static let baseURL = "https://itunes.apple.com"
    fileprivate static let searchComponent = "search"
    fileprivate static let queryTerm = "term"
    fileprivate static let queryEntity = "entity"
    fileprivate static let entityQueryValueMusicTrack = "musicTrack"
    fileprivate static let entityQueryValueSoftware = "software"
}

class AppleStoreItemController {
    
    static func fetchMusicItems(searchTerm: String, completion: @escaping (Result<[MusicItem], AppStoreError>) -> Void){
        
        guard let baseURL = URL(string: StringConstants.baseURL) else { return completion(.failure(.invalidURL))}
        let searchURL = baseURL.appendingPathComponent(StringConstants.searchComponent)
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let queryItemTerm = URLQueryItem(name: StringConstants.queryTerm, value: searchTerm)
        let queryItemEntity = URLQueryItem(name: StringConstants.queryEntity, value: StringConstants.entityQueryValueMusicTrack)
        components?.queryItems = [queryItemTerm, queryItemEntity]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        
        print("[\(#function):\(#line)] -- finalURL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error { return completion(.failure(.thrownError(error)))}
            
            guard let data = data else { return completion(.failure(.invalidData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(MusicTopLevelObject.self, from: data)
                let musicItems = topLevelObject.results
                return completion(.success(musicItems))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchAppItems(searchTerm: String, completion: @escaping (Result<[AppItem], AppStoreError>) -> Void){
        
        guard let baseURL = URL(string: StringConstants.baseURL) else { return completion(.failure(.invalidURL))}
        let searchURL = baseURL.appendingPathComponent(StringConstants.searchComponent)
        var components = URLComponents(url: searchURL, resolvingAgainstBaseURL: true)
        let queryItemTerm = URLQueryItem(name: StringConstants.queryTerm, value: searchTerm)
        let queryItemEntity = URLQueryItem(name: StringConstants.queryEntity, value: StringConstants.entityQueryValueSoftware)
        components?.queryItems = [queryItemTerm, queryItemEntity]
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        
        print("[\(#function):\(#line)] -- finalURL: \(finalURL)")
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error { return completion(.failure(.thrownError(error)))}
            
            guard let data = data else { return completion(.failure(.invalidData))}
            
            do {
                let topLevelObject = try JSONDecoder().decode(AppTopLevelObject.self, from: data)
                let appItems = topLevelObject.results
                return completion(.success(appItems))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }

    static func fetchThumbnailFrom(url: URL, completion: @escaping (Result<UIImage, AppStoreError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownImageError(error)))
            }
            
            guard let data = data else { return completion(.failure(.invalidData)) }
            guard let thumbImage = UIImage(data: data) else {
                return completion(.failure(.unableToDecode))
            }
            return completion(.success(thumbImage))
        }.resume()
    }
}
