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
            case .error:
                setErrorState()
            case .success:
                setSuccessState()
            default:
                progressLabel.text = "Loading..."
                let currentProgress = viewModel.progress.fractionCompleted
                progressView.setProgress(Float(currentProgress), animated: false)
            }
        }
    }
    
    private let progressLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: 100).isActive = true
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
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupProgressBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    fileprivate func setupContentView() {
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
    
    fileprivate func setSuccessState() {
        progressLabel.text = "Success!"
        progressView.setProgress(1, animated: false)
        progressView.progressTintColor = .systemGreen
        
        UIView.animate(withDuration: 0.3, animations: {
            self.progressView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.progressView.transform = .identity
            })
        }
    }
    
    fileprivate func setErrorState() {
        progressLabel.text = "Error!"
        progressView.progressTintColor = .systemRed
    }
}




