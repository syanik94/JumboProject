//
//  JSOperationLoader.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import WebKit

protocol JSOperationLoaderDelegate: class {
    func didCompleteLoadingOperation(for title: String, progress: Int, state: String)
    func didEncounterError(for title: String, error: JSLoaderError)
}

class JSOperationLoader: NSObject {
    enum Constant {
        static let jsEndpoint = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
    }
    
    // MARK: - Dependencies
    
    weak var delegate: JSOperationLoaderDelegate?
    var webView: WKWebView!
    let id: String
        
    // MARK: - Initializer
    
    init(id: String) {
        self.id = id
        super.init()
        setupWebView()
    }
    
    // MARK: - Setup
    
    fileprivate func setupWebView() {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        let userScript = WKUserScript(source: loadJavascriptContents(), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(userScript)
        userContentController.add(self, name: "jumbo")
        config.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
    }
    
    // MARK: - API Methods
    
    func load() {
        guard let url = URL(string: Constant.jsEndpoint) else {
            self.delegate?.didEncounterError(for: self.id, error: .invalidUrl)
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Helper Methods
    
    private func evaluateJavascript() {
        webView.evaluateJavaScript("startOperation('\(id)')") { (_, err) in
            if let _ = err {
                self.delegate?.didEncounterError(for: self.id, error: .javascriptEvaluationFailure)
            }
        }
    }
    
    func loadJavascriptContents() -> String {
        guard let url = URL(string: Constant.jsEndpoint) else {
            self.delegate?.didEncounterError(for: self.id, error: .invalidUrl)
            return ""
        }
        let contents = try? String(contentsOf: url)
        return contents ?? ""
    }
}

extension JSOperationLoader: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let mbody = message.body as? String else {
            delegate?.didEncounterError(for: id, error: .messageCastToStringFailure)
            return
        }
        guard let data = mbody.data(using: .utf8) else {
            delegate?.didEncounterError(for: id, error: .dataConversionFailure)
            return
        }
        if let messageResponse = try? JSONDecoder().decode(ResponseMessage.self, from: data) {
            let progress = messageResponse.progress ?? 0
            let state = messageResponse.state ?? ""
            
            delegate?.didCompleteLoadingOperation(for: id, progress: progress, state: state)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delegate?.didEncounterError(for: id, error: .networkFailure)
    }
}

extension JSOperationLoader: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        evaluateJavascript()
    }
}

















