//
//  JSOperationLoader.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import WebKit

class JSOperationLoader: NSObject {
    
    enum Constant {
        static let jsEndpoint = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
    }
    
    // MARK: - Dependencies
    
    let responseViewModel: ResponseMessageViewModel
    
    var webView: WKWebView!
    
    
    // MARK: - Initializer
    
    init(responseViewModel: ResponseMessageViewModel) {
        self.responseViewModel = responseViewModel
        super.init()
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        let userScript = WKUserScript(source: JSOperationLoader.loadJavascriptContents(), injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(userScript)
        userContentController.add(self, name: "jumbo")
        config.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
    }
    
    
    // MARK: - API Methods
    
    func load() {
        guard let url = URL(string: Constant.jsEndpoint) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func evaluateJavascript() {
        webView.evaluateJavaScript("startOperation('\(responseViewModel.id)')") { (result, err) in
            if let err = err {
                print(err.localizedDescription)
                self.responseViewModel.state = .error
            }
            if let result = result {
                print(result)
            }
        }
    }
    
    static func loadJavascriptContents() -> String {
        guard let url = URL(string: Constant.jsEndpoint) else { return "" }
        let contents = try? String(contentsOf: url)
        return contents ?? ""
    }
}

extension JSOperationLoader: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        if let mbody = message.body as? String {
            if let data = mbody.data(using: .utf8) {
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let responseProgress = json?["progress"] as? Int ?? 0
                let responseState = json?["state"] as? String ?? ""
                self.responseViewModel.handleStateChanges(state: responseState, progress: responseProgress)
            }
        }
    }
}

extension JSOperationLoader: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        evaluateJavascript()
    }
}

















