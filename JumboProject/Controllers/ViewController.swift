//
//  ContentView.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    enum Constant {
        static let progressCellID = "progressCellID"
    }
        
    private(set) var responseMessageViewModels: [ResponseMessageViewModel] = []
    
    
    // MARK: - View Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        navigationItem.title = "Jumbo Project 🐘"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCells()
        createViewModels()
        loadJSOperations()
    }
    
    
    // MARK: - View Setup
    
    fileprivate func setupCells() {
        tableView.register(ProgressTableViewCell.self, forCellReuseIdentifier: Constant.progressCellID)
    }
    
    
    // MARK: - Methods
    
    func createViewModels() {
        IDLoader.loadIDs().forEach { (id) in
            let respObject = ResponseMessage(id: id)
            let viewModel = ResponseMessageViewModel(responseMessage: respObject)
            self.responseMessageViewModels.append(viewModel)
        }
    }
    
    func loadJSOperations() {
        responseMessageViewModels.forEach { (viewModel) in
            let jsLoader = JSOperationLoader(id: viewModel.id)
            jsLoader.delegate = self
            jsLoader.load()
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

// MARK: - JSOperation Loader Delegate

extension ViewController: JSOperationLoaderDelegate {
    func didCompleteLoadingOperation(for title: String, progress: Int, state: String) {
        if let index = responseMessageViewModels.firstIndex(where: { $0.id == title }) {
            let responseViewModel = responseMessageViewModels[index]
            responseViewModel.handleStateChanges(state: state, progress: progress)
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func didEncounterError(for title: String, state: ResponseMessageViewModel.State) {
        if let index = responseMessageViewModels.firstIndex(where: { $0.id == title }) {
            let responseViewModel = responseMessageViewModels[index]
            responseViewModel.state = state
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
}
