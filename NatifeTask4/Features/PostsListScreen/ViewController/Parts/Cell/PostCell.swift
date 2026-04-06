//
//  PostCell.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

final class PostCell: UICollectionViewCell {

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
        return label
    }()

    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(expandTapped), for: .touchUpInside)
        return button
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

extension PostCell {
    func configure(with post: Post, isExpanded: Bool) {
        let postDate = Date(timeIntervalSince1970: TimeInterval(post.timeshamp))
        dateLabel.text = Constant.dateFormatter.string(from: postDate)
        titleLabel.text = post.title
        likeLabel.text = "\(Constant.likeIcon)\(post.likesCount)"
        textLabel.text = post.previewText
        textLabel.numberOfLines = isExpanded ? Constant.expandedLines : Constant.collapsedLines
        expandButton.setTitle(isExpanded ? Constant.collapseTitle : Constant.expandTitle, for: .normal)
        expandButton.isHidden = post.previewText.count < Constant.previewTextMinLength
    }
}

// MARK: - Private Methods

private extension PostCell {
    func setupView() {
        contentView.addSubviews(
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

private extension PostCell {
    func setupLayout() {
        disableAutoresizing(
            textStackView,
            bottomStackView,
            expandButton
        )

        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            bottomStackView.topAnchor.constraint(equalTo: textStackView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            expandButton.heightAnchor.constraint(equalToConstant: 45),
            expandButton.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 20),
            expandButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            expandButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            expandButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}

private extension PostCell {
    enum Constant {
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            return formatter
        }()

        static let likeIcon = "❤️"
        static let expandTitle = "Expand"
        static let collapseTitle = "Collapse"
        static let expandedLines = 0
        static let collapsedLines = 2
        static let previewTextMinLength = 100
    }
}
