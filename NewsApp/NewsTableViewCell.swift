//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Uladzimir on 02.02.2022.
//

import UIKit

class NewsTableViewCellViewModel{
    let title: String
    let subTitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    let showMore: String
    
    init(
        title: String,
        subTitle: String,
        imageURL: URL?
    ){
        self.title = title
        self.subTitle = subTitle
        self.imageURL = imageURL
        self.showMore = "Show more"
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold )
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImmageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let showMoreLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImmageView)
        contentView.addSubview(showMoreLabel)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 170, height: 70)
        subTitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width - 170, height: contentView.frame.size.height/2)
        newsImmageView.frame = CGRect(x: contentView.frame.size.width - 160, y: 5, width: 160, height: contentView.frame.size.height - 10)
        showMoreLabel.frame = CGRect(x: contentView.frame.size.width - 260, y: 150, width: 80, height: 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subTitleLabel.text = nil
        newsImmageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        newsTitleLabel.text = viewModel.title
        subTitleLabel.text = viewModel.subTitle
        showMoreLabel.text = "Show more"
        
        //imege
        if let data = viewModel.imageData{
            newsImmageView.image = UIImage(data : data)
        }
        else if let url = viewModel.imageURL {
            //fetch
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
