//
//  ProgressDisplayViewController.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ProgressDisplayViewController: UITableViewController {
    
    enum Constant {
        static let progressCellID = "progressCellID"
    }
    
    let logicController = ProgressDisplayLogicController()
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        navigationItem.title = "Jumbo Project 🐘"
        setupCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUpdates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logicController.configureJSOperationLoader()
    }
    
    // MARK: - Observe Updates
    
    func observeUpdates() {
        logicController.handleLoadCompletion = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - View Setup
    
    fileprivate func setupCells() {
        tableView.register(ProgressTableViewCell.self, forCellReuseIdentifier: Constant.progressCellID)
    }
    
    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logicController.responseMessageViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.progressCellID, for: indexPath) as? ProgressTableViewCell
        let vm = logicController.responseMessageViewModels[indexPath.item]
        cell?.viewModel = vm
        return cell ?? UITableViewCell()
    }
}
