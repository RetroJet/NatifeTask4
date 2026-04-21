//
//  PostDetailViewController.swift
//  NatifeTask4
//
//  Created by Nazar on 06.04.2026.
//

import SnapKit
import UIKit

struct PostDetailItemViewState: Hashable {
    let id: Int
    let date: String
    let title: String
    let text: String
    let image: String
    let like: String
}

protocol PostDetailViewControllerProtocol: AnyObject {
    func render(_ state: PostDetailViewState)
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
        label.textColor = .gray
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
        title = CommonText.navigationBarTitle

        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .separator
        appearance.backgroundColor = .white

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

private extension PostDetailViewController {
    func setupLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        imageMain.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(350)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(imageMain)
            
        }
        
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(imageMain.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(textStackView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
}

// MARK: - PostDetailViewControllerProtocol

extension PostDetailViewController: PostDetailViewControllerProtocol {
    func render(_ state: PostDetailViewState) {
        dateLabel.text = state.item.date
        titleLabel.text = state.item.title
        textLabel.text = state.item.text
        likeLabel.text = state.item.like

        activityIndicator.startAnimating()
    }

    func showImage(_ data: Data) {
        activityIndicator.stopAnimating()
        imageMain.image = UIImage(data: data)
    }

    func showError(_ message: String) {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: CommonText.okButtonTitle, style: .default))
        present(alert, animated: true)
    }
}
