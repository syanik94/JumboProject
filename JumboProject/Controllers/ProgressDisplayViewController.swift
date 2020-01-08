//
//  ContentView.swift
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
        
    private(set) var responseMessageViewModels: [ResponseMessageViewModel] = []
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        navigationItem.title = "Jumbo Project 🐘"
        setupCells()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewModels()
        loadJSOperations()
    }
    
    // MARK: - View Setup
    
    fileprivate func setupCells() {
        tableView.register(ProgressTableViewCell.self, forCellReuseIdentifier: Constant.progressCellID)
    }
    
    // MARK: - Methods
    
    /*
     Loads specifed number of View Model objects with unique ID's
     */
    func createViewModels() {
        IDLoader.loadIDs(count: 10).forEach { (id) in
            let respObject = ResponseMessage(id: id)
            let viewModel = ResponseMessageViewModel(responseMessage: respObject)
            self.responseMessageViewModels.append(viewModel)
        }
    }
    
    /*
     Loads a Javascript loading operation for each View Model and assigns delegate
     */
    func loadJSOperations() {
        responseMessageViewModels.forEach { (vm) in
            vm.updateHandler = { [weak self] id in
                if let row = self?.responseMessageViewModels.firstIndex(where: { $0.id == id }) {
                    self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
                }
            }
            vm.load()
        }
    }

    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseMessageViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.progressCellID, for: indexPath) as? ProgressTableViewCell
        let vm = responseMessageViewModels[indexPath.item]
        cell?.viewModel = vm
        return cell ?? UITableViewCell()
    }
}
