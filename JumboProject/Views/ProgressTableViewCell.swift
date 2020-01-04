//
//  ProgressTableViewCell.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

final class ProgressTableViewCell: UITableViewCell {
    
    var viewModel: ResponseMessageViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            switch viewModel.state {
            case .error(let error):
                handleErrorState(error: error)
            case .success:
                handleSuccessState()
            default:
                progressLabel.text = "Loading..."
                let currentProgress = Float(viewModel.progress.fractionCompleted)
                progressView.setProgress(currentProgress, animated: false)
            }
        }
    }
    
    private let progressLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
//        l.widthAnchor.constraint(equalToConstant: 100).isActive = true
        l.text = "Waiting..."
        return l
    }()
    
    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: UIProgressView.Style.default)
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [progressLabel, progressView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupProgressBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - View Setup
    
    fileprivate func setupContentView() {
        selectionStyle = .none
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            contentStackView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    fileprivate func setupProgressBar() {
        progressView.layer.cornerRadius = 15
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 15
        progressView.subviews[1].clipsToBounds = true
    }
    
    
    // MARK: - State Handlers
    
    fileprivate func handleSuccessState() {
        progressLabel.text = "Success!"
        progressView.setProgress(1, animated: false)
        progressView.progressTintColor = .systemGreen
        
        UIView.animate(withDuration: 0.3, animations: {
            self.progressView.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.progressView.transform = .identity
            })
        }
    }
    
    fileprivate func handleErrorState(error: JSLoaderError) {
        var errorDescription: String
        switch error {
        case .operationFailure:
            errorDescription = "Operation Failed!"
        case .invalidStateString:
            errorDescription = "Invalid String!"
        case .javascriptEvaluationFailure:
            errorDescription = "Evaluation Failed!"
        case .invalidUrl:
            errorDescription = "Invalid URL!"
        case .messageCastToStringFailure:
            errorDescription = "Data Failure!"
        case .dataConversionFailure:
            errorDescription = "Data Failure!"
        case .networkFailure:
            errorDescription = "Network Failure!"
        }
        progressLabel.text = errorDescription
        progressView.progressTintColor = .systemRed
    }
}




