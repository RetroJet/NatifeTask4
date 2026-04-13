//
//  PostDetailViewController.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import UIKit

protocol PostDetailViewControllerProtocol: AnyObject {
    func showPost(_ post: PostDetail)
    func showImage(_ data: Data)
    func showError(_ message: String)
}

final class PostDetailViewController: UIViewController {

    // MARK: - UI Elements

    private let contentView = UIView()
    private let scrollView = UIScrollView()

    private lazy var imageMain: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.contentMode = .top
        label.numberOfLines = 0
        return label
    }()

    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = . gray
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    private lazy var spacerView: UIView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return spacer
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Properties

    var presenter: PostDetailPresenterProtocol!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupLayout()
        presenter.fetchPost()
    }
}

// MARK: - Private Methods

private extension PostDetailViewController {
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)

        imageMain.addSubview(activityIndicator)

        scrollView.addSubview(contentView)

        contentView.addSubviews(
            imageMain,
            textStackView,
            bottomStackView
        )

        textStackView.addArrangedSubviews(
            titleLabel,
            textLabel
        )

        bottomStackView.addArrangedSubviews(
            likeLabel,
            spacerView,
            dateLabel
        )
    }

    func setupNavigationBar() {
        title = Constants.navigationBarTitle

        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .separator
        appearance.backgroundColor = .white

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

private extension PostDetailViewController {
    func setupLayout() {
        view.disableAutoresizing(
            scrollView,
            contentView,
            imageMain,
            activityIndicator,
            textStackView,
            bottomStackView,
        )

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageMain.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageMain.heightAnchor.constraint(equalToConstant: 350),

            activityIndicator.centerXAnchor.constraint(equalTo: imageMain.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageMain.centerYAnchor),

            textStackView.topAnchor.constraint(equalTo: imageMain.bottomAnchor, constant: 20),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            bottomStackView.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

private extension PostDetailViewController {
    enum Constants {
        static let likeIcon = "❤️"
        static let navigationBarTitle: String = "Title"
    }
}

// MARK: - PostDetailViewControllerProtocol

extension PostDetailViewController: PostDetailViewControllerProtocol {
    func showPost(_ post: PostDetail) {
        let postDate = Date(timeIntervalSince1970: TimeInterval(post.timeshamp))
        dateLabel.text = DateFormatter.postDate.string(from: postDate)
        titleLabel.text = post.title
        textLabel.text = post.text
        likeLabel.text = "\(Constants.likeIcon)\(post.likesCount)"

        activityIndicator.startAnimating()
        presenter.loadImage(from: post.postImage)

    }

    func showImage(_ data: Data) {
        activityIndicator.stopAnimating()
        imageMain.image = UIImage(data: data)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CommonText.okButtonTitle, style: .default))
        present(alert, animated: true)
    }
}
