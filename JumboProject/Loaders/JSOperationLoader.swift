//
//  JSOperationLoader.swift
//  JumboProject
//
//  Created by Yanik Simpson on 1/3/20.
//  Copyright © 2020 Yanik Simpson. All rights reserved.
//

import Foundation
import WebKit

typealias ResponseCompletion = (id: String, progress: Int, state: String)
protocol JSOperationLoaderDelegate: class {
    func didLoadJavascriptResponse(with response: ResponseCompletion)
    func didFailLoading(with error: JSLoaderError)
}

protocol JSOperationLoaderProtocol {
    var delegate: JSOperationLoaderDelegate? { get set }
    var ids: [String] { get set }
    func load()
}

class JSOperationLoader: NSObject, JSOperationLoaderProtocol {
    enum Constant {
        static let jsEndpoint = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
    }
    
    // MARK: - Dependencies
    
    weak var delegate: JSOperationLoaderDelegate?
    private(set) var webView: WKWebView!
    var ids = [String]()
        
    // MARK: - Initializer
    
    override init() {
        super.init()
        setupWebView()
    }
    
    // MARK: - Setup
    
    /*
     WebView setup where javascript content is added, listen for posted messages, webView is instantiated
     */
    fileprivate func setupWebView() {
        let config = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        let userScript = WKUserScript(source: loadJavascriptContents(), injectionTime: .atDocumentStart, forMainFrameOnly: true)
        userContentController.addUserScript(userScript)
        userContentController.add(self, name: "jumbo")
        config.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
    }
    
    // MARK: - API Methods
    
    /*
     Begins URL loading by the webView, later informing WKNavigationDelegate, informs the delegate of error
     */
    func load() {
        guard let url = URL(string: Constant.jsEndpoint) else {
            delegate?.didFailLoading(with: .invalidUrl(urlString: Constant.jsEndpoint))
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Private Methods
    
    /*
    Handles calling startOperation(id) from the Javascript file which triggers WKScriptMessageHandler didReceive method,
     updates the delegate in error case
    */
    func evaluateJavascript() {
        ids.forEach { (id) in
            webView.evaluateJavaScript("startOperation('\(id)')") { (_, err) in
                if let _ = err {
                    self.delegate?.didFailLoading(with: .javascriptEvaluationFailure)
                }
            }
        }
    }
    
    private func loadJavascriptContents() -> String {
        guard let url = URL(string: Constant.jsEndpoint) else {
            self.delegate?.didFailLoading(with: .invalidUrl(urlString: Constant.jsEndpoint))
            return ""
        }
        let contents = try? String(contentsOf: url)
        return contents ?? ""
    }
    
    func handleReceivedMessage(message: String) {
        guard let data = message.data(using: .utf8) else {
            self.delegate?.didFailLoading(with: .dataConversionFailure)
            return
        }
        if let messageResponse = try? JSONDecoder().decode(ResponseMessage.self, from: data) {
            let id = messageResponse.id
            let progress = messageResponse.progress ?? 0
            let state = messageResponse.state ?? ""
            let responseSuccess = (id, progress, state)
            delegate?.didLoadJavascriptResponse(with: responseSuccess)
        } else {
            self.delegate?.didFailLoading(with: .jsonDecodingError)
        }
    }
}

    // MARK: - WKNavigationDelegate Methods

extension JSOperationLoader: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        evaluateJavascript()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        delegate?.didFailLoading(with: .networkFailure)
    }
}

    // MARK: - WKScriptMessageHandler Methods

extension JSOperationLoader: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody = message.body as? String {
            handleReceivedMessage(message: messageBody)
        } else {
            delegate?.didFailLoading(with: .messageCastToStringFailure)
        }
    }
}
















