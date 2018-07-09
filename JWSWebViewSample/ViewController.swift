//
//  ViewController.swift
//  JWSWebViewSample
//
//  Created by ClintJang on 2018. 7. 9..
//  Copyright © 2017년 ClintJang. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

extension UIViewController {
    /// common close function
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true) {
            print("self's controller close")
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

extension WKWebView {
    func stringByEvaluatingJavaScript(script: String) {
        self.evaluateJavaScript(script) { (result, error) in
            
        }
    }
}
