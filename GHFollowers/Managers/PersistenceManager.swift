//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Жансая Шакуали on 31.07.2023.
//

import Foundation

enum PersistanceActiontype {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favourites = "favourites"
    }
    
    static func updateWith (favourite: Follower, actionType: PersistanceActiontype, completed: @escaping(ErrorMessage?) -> Void) {
        retrieveFavourites { result in
            switch result {
            case .success(let favourites):
               var retrievedFavourites = favourites
                
                switch actionType {
                case.add:
                    guard !retrievedFavourites.contains(favourite) else {
                        completed(.alreadyInFavourites)
                        return
                    }
                    retrievedFavourites.append(favourite)
                case.remove:
                    retrievedFavourites.removeAll { $0.login == favourite.login }
                }
                completed(save(favourites: retrievedFavourites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavourites(completed: @escaping(Result<[Follower], ErrorMessage>) -> Void) {
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favourites = try decoder.decode([Follower].self, from: favouritesData)
            completed(.success(favourites))
        } catch {
            completed(.failure(.unableToFavourite))
        }
    }
    
    static func save(favourites: [Follower]) -> ErrorMessage? {
        do {
            let encoder = JSONEncoder()
            let encodedFavourites = try encoder.encode(favourites)
            defaults.set(encodedFavourites, forKey: Keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
    }
}
