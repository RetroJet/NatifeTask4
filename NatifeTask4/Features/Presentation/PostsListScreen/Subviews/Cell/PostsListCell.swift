//
//  PostsListCell.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

struct PostsListItemViewState: Hashable {
    let id: Int
    let date: String
    let title: String
    let previewText: String
    let like: String
    let isExpanded: Bool
    let showExpandButton: Bool
    let titleNumberOfLines: Int
}

final class PostsListCell: UICollectionViewCell {

    // MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
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
        label.textAlignment = .right
        return label
    }()

    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(expandTapped), for: .touchUpInside)
        return button
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var spacerView: UIView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return spacer
    }()

    // MARK: - Properties

    var expandButtonTapped: (() -> Void)?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Methods

extension PostsListCell {
    func configure(with viewState: PostsListItemViewState) {
        dateLabel.text = viewState.date
        titleLabel.text = viewState.title
        titleLabel.numberOfLines = viewState.titleNumberOfLines
        likeLabel.text = viewState.like
        textLabel.text = viewState.previewText

        expandButton.isHidden = !viewState.showExpandButton
        expandButton.setTitle(
            viewState.isExpanded ? Constant.collapseTitle : Constant.expandTitle,
            for: .normal
        )

        textLabel.numberOfLines = viewState.showExpandButton
                ? (viewState.isExpanded ? Constant.expandedLines : Constant.collapsedLines)
                : 0
    }
}

// MARK: - Private Methods

private extension PostsListCell {
    func setupView() {
        contentView.addSubview(mainStackView)

        mainStackView.addArrangedSubviews(
            textStackView,
            bottomStackView,
            expandButton
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

    @objc
    func expandTapped() {
        expandButtonTapped?()
    }
}

private extension PostsListCell {
    func setupLayout() {
        disableAutoresizing(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            expandButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}

private extension PostsListCell {
    enum Constant {
        static let expandTitle = "Expand"
        static let collapseTitle = "Collapse"
        static let expandedLines = 0
        static let collapsedLines = 2
        static let previewTextMinLength = 100
    }
}
