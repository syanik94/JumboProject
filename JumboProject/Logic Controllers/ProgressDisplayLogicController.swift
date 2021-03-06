//
//  ProgressDisplayLogicController.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/14/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation

final class ProgressDisplayLogicController {
    
    var handleLoadCompletion: (() -> Void)?
    
    var jsLoader: JSOperationLoaderProtocol?
    
    private(set) var responseMessageViewModels: [ResponseMessageViewModel] = []
    private(set) var viewModelLookup: [String: ResponseMessageViewModel] = [:]
    
    // MARK: - Initializer
    
    init(ids: [String] = IDLoader.loadIDs(count: 30),
         jsLoader: JSOperationLoaderProtocol = JSOperationLoader()) {
        self.jsLoader = jsLoader
        createResponseMessageViewModels(from: ids)
    }
    
    // MARK: - Methods

    /*
     Loads a Javascript loading operation for each unique ID and assigns delegate
     */
    
    func configureJSOperationLoader() {
        jsLoader?.ids = responseMessageViewModels.map { $0.id }
        jsLoader?.delegate = self
        jsLoader?.load()
    }
    
    // MARK: - Private Functions
    
    /*
     Loads specifed number of View Model objects with unique ID's
     */
    
    private func createResponseMessageViewModels(from ids: [String]) {
        ids.forEach { (id) in
            let respObject = ResponseMessage(id: id)
            let viewModel = ResponseMessageViewModel(responseMessage: respObject)
            viewModelLookup[id] = viewModel
            responseMessageViewModels.append(viewModel)
        }
    }
    
    private func handleJavascriptLoadResponse(with response: ResponseCompletion) {
        if let vm = viewModelLookup[response.id] {
            vm.updateState(from: response)
            handleLoadCompletion?()
        }
    }
}

// MARK: - JSOperationLoaderDelegate Methods

extension ProgressDisplayLogicController: JSOperationLoaderDelegate {
    func didLoadJavascriptResponse(with response: ResponseCompletion) {
        handleJavascriptLoadResponse(with: response)
    }
    
    func didFailLoading(with error: JSLoaderError) {
        // TODO: - Swtich on error and handle accordingly
    }
}





