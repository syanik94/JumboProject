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
        
    var viewModels: [ResponseMessageViewModel] = []

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
    
    
    // MARK: -
    
    func createViewModels() {
        IDLoader.loadIDs().forEach { (id) in
            let respObject = ResponseMessage(id: id)
            let viewModel = ResponseMessageViewModel(responseMessage: respObject)
            self.viewModels.append(viewModel)
        }
    }
    
    func loadJSOperations() {
        viewModels.forEach { (viewModel) in
            let jsLoader = JSOperationLoader(responseViewModel: viewModel)
            
            jsLoader.completion = { [weak self] in
                if let index = self?.viewModels.firstIndex(where: { $0.id == viewModel.id}) {
                    self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
            jsLoader.load()
        }
    }
    
    // MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.progressCellID, for: indexPath) as? ProgressTableViewCell
        let vm = viewModels[indexPath.item]
        cell?.viewModel = vm
        return cell ?? UITableViewCell()
    }
}
