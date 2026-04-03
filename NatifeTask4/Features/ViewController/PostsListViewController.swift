//
//  PostsListViewController.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

class PostsListViewController: UIViewController {
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = .max
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.clipsToBounds = true
        label.contentMode = .top
        return label
    }()
    
    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let buttonCell: UIButton = {
        let button = UIButton()
        button.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Private Methods

private extension PostsListViewController {
    func setupView() {
        view.addSubviews(
            titleLable,
            textLabel,
            likeLabel,
            dateLabel,
        )
    }
}

private extension PostsListViewController {
    func setupLayout() {
        
    }
}
