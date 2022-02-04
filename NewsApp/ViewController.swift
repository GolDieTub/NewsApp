//
//  ViewController.swift
//  NewsApp
//
//  Created by Uladzimir on 02.02.2022.
//

import UIKit
import SafariServices
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    private var buttonTags = Array(repeating: false, count: 20)
    private let searchVC = UISearchController(searchResultsController: nil)
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()

    public var likedPosts: [[String:Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        view.backgroundColor = .systemBackground
        //loadData()
        fetchTopStories()
        createSearchBar()

    }
    
    @objc func refresh(_ sender: AnyObject) {
        APInews.shared.getTopNews {[weak self] result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        description: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.refreshControl?.endRefreshing()
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }

    }
    
    @objc func didTapCellButton(sender: UIButton) {
        let buttonTag = sender.tag
        if buttonTags[sender.tag] == false{
            buttonTags[sender.tag] = true
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else if buttonTags[sender.tag] == true{
            buttonTags[sender.tag] = false
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
            
        }
//        UserDefaults.standard.set(articles[buttonTag].url, forKey: "LikesKey")
//        UserDefaults.standard.synchronize()

    }
    
    func loadData(){
        
        if let array = UserDefaults.standard.array(forKey: "LikesKey") as? [[String:Any]]{
            likedPosts = array
        } else {
            likedPosts = []
        }
        print(likedPosts)
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    func fetchTopStories(){
        APInews.shared.getTopNews {[weak self] result in
            switch result{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        description: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? ""))
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return viewModels.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath)
                as?NewsTableViewCell else{
                    fatalError()
                }
        cell.configure(with: viewModels[indexPath.row])
        cell.likeButton.tag = indexPath.row
                cell.likeButton.addTarget(self, action: #selector(didTapCellButton(sender:)), for: .touchUpInside)
        if (cell.descriptionLabel.text?.count ?? 0 > 80){
            cell.showMoreLabel.textColor = .systemBlue
        }
        else{
            cell.showMoreLabel.textColor = .systemBackground
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "" ) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        APInews.shared.search(with: text) {[weak self] result in
            switch result{
                case .success(let articles):
                    self?.articles = articles
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(
                            title: $0.title,
                            description: $0.description ?? "No Description",
                            imageURL: URL(string: $0.urlToImage ?? ""))
                    })
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }

    }
    
}

