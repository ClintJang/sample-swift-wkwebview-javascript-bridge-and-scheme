//
//  WebViewSchemesViewController.swift
//  JWSWebViewSample
//
//  Created by ClintJang on 2018. 7. 9..
//  Copyright © 2017년 ClintJang. All rights reserved.
//

import Foundation
import WebKit

/**
 The "WKWebView" test screen controller class implemented in the language "swift".
 - class : SwiftWKWebViewController
 */
final class WebViewSchemesViewController : UIViewController {
    @IBOutlet weak var safeAreaContainerView: UIView!
    private var webView: WKWebView!
    
    private struct Constants {
        static let schemeKey = "nativeScheme"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initializes
        setupView()
        
        loadURL()
    }
}

// MARK:- Private
private extension WebViewSchemesViewController {
    func setupView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true // default YES.
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        self.webView.navigationDelegate = self
        self.webView.uiDelegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        self.safeAreaContainerView.addSubview(self.webView)
        
        // WKWebView Layout Setting
        // Constraints like "UIWebView" are set.
        // This is a sample. If you are developing, use a library called "SnapKit".
        // https://github.com/SnapKit/SnapKit
        let margins = safeAreaContainerView.layoutMarginsGuide
        webView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    func loadURL() {
        guard let  url = Bundle.main.url(forResource: "sampleScheme", withExtension: "html") else {
            return
        }
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
}

// MARK: - WKUIDelegate
extension WebViewSchemesViewController : WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("\(#function)")
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("\(#function)")
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        print("\(#function)")
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
            completionHandler(nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - WKNavigationDelegate
extension WebViewSchemesViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        print("\(#function)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("\(#function)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("\(#function)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
        print("\(#function)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //MARK:- HERE!!!
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("\(#function)")
        
        // WebView Native 연동 여부 확인
        if let url = navigationAction.request.url,
            let urlScheme = url.scheme,
            let urlHost = url.host,
            urlScheme.uppercased() == Constants.schemeKey.uppercased() {
            print("url:\(url)")
            print("urlScheme:\(urlScheme), Lower case.") // 소문자입니다.
            print("urlHost:\(urlHost)")

            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("\(#function)")
        decisionHandler(.allow)
    }
}

