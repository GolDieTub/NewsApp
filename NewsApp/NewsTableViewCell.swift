//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Uladzimir on 02.02.2022.
//

import UIKit

class NewsTableViewCellViewModel{
    
    let title: String
    let description: String
    let imageURL: URL?
    var imageData: Data? = nil
    let showMore: String
    let like: Bool
    
    init(
        title: String,
        description: String,
        imageURL: URL?
    ){
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.showMore = "Show more"
        self.like = false
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    public let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold )
        return label
    }()
    
    public let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    public let newsImmageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    public let showMoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        //label.textColor = .systemBlue
        label.textColor = .systemBackground
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    public let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(newsImmageView)
        contentView.addSubview(showMoreLabel)
        contentView.addSubview(likeButton)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 170, height: 70)
        descriptionLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 170, height: contentView.frame.size.height/2)
        newsImmageView.frame = CGRect(x: contentView.frame.size.width - 160, y: 5, width: 160, height: contentView.frame.size.height - 10)
        showMoreLabel.frame = CGRect(x: contentView.frame.size.width - 260, y: 150, width: 80, height: 10)
        likeButton.frame = CGRect(x: 10, y: 150, width: 20, height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        descriptionLabel.text = nil
        newsImmageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        newsTitleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        showMoreLabel.text = "Show more"
        
        if let data = viewModel.imageData{
            newsImmageView.image = UIImage(data : data)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImmageView.image = UIImage(data : data)
                }
            }.resume()
        }
    }
}
