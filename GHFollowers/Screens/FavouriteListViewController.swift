 //
//  FavouriteListViewController.swift
//  GHFollowers
//
//  Created by Жансая Шакуали on 02.07.2023.
//

import UIKit

class FavouriteListViewController: UIViewController {
    
    let tableView = UITableView()
    var favourites: [Follower] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseId)
    }
    
    func getFavourites() {
        PersistenceManager.retrieveFavourites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favourites):
                
                if favourites.isEmpty {
                    self.showEmptyStateView(with: "No favourites?\nAdd one on follower screen", in: self.view)
                } else {
                    self.favourites = favourites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
                    
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FavouriteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseId) as! FavouriteCell
        let favourite = favourites[indexPath.row]
        cell.set(favourite: favourite)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        let destVC = FollowersListViewController()
        destVC.username = favourite.login
        destVC.title = favourite.login
        
        navigationController?.pushViewController(destVC, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let favourite = favourites[indexPath.row]
        favourites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.updateWith(favourite: favourite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
