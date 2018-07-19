# sample swift wkwebview javascript bridge and scheme
[![License](http://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://github.com/clintjang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/LICENSE) [![Swift 4](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://swift.org) 

```
I have tried to sample the method of javascirpt bridge and url scheme with wkwebview.

★ Web (Front) → Native
In the past, when linking with the UIWebView, we had to define a schema in the URL and parse it using scheme information.
In WKWebView, there is an additional way to do logic processing with javascript bridge.

★ Native → Web (Front)
The native-to-web forwarding / processing method is exactly the same as calling the JavaScript function ("evaluatejavascript") as in the existing UIWebView.
```

- [README.md](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/README.md) : 한국어 설명

# Info
## Result image(GIF)
<img width="268" height="480" src="/Image/resultLow.gif">

## 1. javascirpt bridge
> There is a distinction between using bridge connections and natively javascript calling back from the web using the scheme of the defined url. 

- HTML file for testing: [sampleBridge.html](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Resources/sampleBridge.html)
    ```html 
    <html lang="ko">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <script type="text/javascript">
       // alert(1)

        function callNative01() {
           try {
               webkit.messageHandlers.callbackHandler.postMessage("testValue");
           } catch(error) {
               alert(error)
           }
        }

        function callNative02() {
            try {
                webkit.messageHandlers.callbackHandler.postMessage({key01:'testValue01', key02:'testValue02'});
            } catch(error) {
                alert(error)
            }
        }

        function test01() {
           alert('test01');
        }

        function testCallBack(message) {
            alert(message);
        }
    </script>
    <body>
        <h1> <a href="javascript:test01();">Test Click</a> </h1> <br /><br />
        <h1> <a href="javascript:callNative01();">CallNative 01 Click</a> </h1> <br /><br />
        <h1> <a href="javascript:callNative02();">CallNative 02 Click</a> </h1> <br /><br />
    <h1> This is a sample file created to test a simple "WebView".<br /></h1>
    <h1> Modify this file to test the "WebView" content.<br /></h1>
    </body>
    </html>
    ```
- swift code : [WebViewBridgeViewController.swift](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Sample/Bridge/WebViewBridgeViewController.swift) ← Click the details to see the code.
    ```swift 
    .. (skip).. 

    private struct Constants {
        static let callBackHandlerKey = "callbackHandler"
    }

    .. (skip).. 

    func setupView() {
        // Bridge Setting
        let userController: WKUserContentController = WKUserContentController()
        let userScript: WKUserScript = WKUserScript(source: "test01()", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        userController.addUserScript(userScript)
        
        userController.add(self, name: Constants.callBackHandlerKey)
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userController
        
        // Default WebView Setting
        self.webView = WKWebView(frame:self.safeAreaContainerView.bounds, configuration: configuration)
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

    .. (skip) ..

    // MARK: - WKScriptMessageHandler
    extension WebViewBridgeViewController : WKScriptMessageHandler {
        //MARK:- HERE!!!
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
          print("message.name:\(message.name)")
          if message.name == Constants.callBackHandlerKey {
              print("message.body:\(message.body)")

              // Just TEST CallBack
              if let dictionary = message.body as? Dictionary<String, AnyObject> {
                  print(dictionary)
                  var popupPrintString = ""
                  dictionary.forEach { (key, value) in
                      popupPrintString += "\(key):\(value) "
                  }
                  // call back!
                  self.webView.stringByEvaluatingJavaScript(script: "javascript:testCallBack('\(popupPrintString)');")
              } else {
                  // call back!
                  self.webView.stringByEvaluatingJavaScript(script: "javascript:testCallBack('\(String(describing:message.body))');")
              }

              // popup!
  //            self.webView.stringByEvaluatingJavaScript(script: "javascript:test01();")

          }
      }
    }

    .. (skip) ..

    ```

## 2. URL Scheme

- HTML file for testing : [sampleScheme.html](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Resources/sampleScheme.html)
    ```html 
    <html lang="ko">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>

    <script type="text/javascript">
        //alert(2)

       function callNative01() {
           window.location = "nativeScheme://testHost";
       }

        function test02() {
            alert('test02');
        }

        function testCallBack(message) {
            alert(message);
        }
    </script>
    <body>
    <h1> <a href="javascript:test02();">Test Click</a> </h1> <br /><br />

    <h1> <a href="javascript:callNative01();">CallNative 01 Click</a> </h1> <br /><br />


    <h1> This is a sample file created to test a simple "WebView".<br /></h1>
    <h1> Modify this file to test the "WebView" content.<br /></h1>
    </body>
    </html>
    ```

- swift code : [WebViewSchemesViewController.swift](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Sample/Scheme/WebViewSchemesViewController.swift) ← Click the details to see the code.
    ``` swift 
    .. (skip) ..

    private struct Constants {
        static let schemeKey = "nativeScheme"
    }

    .. (skip) ..

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

    .. (skip) ..

    // MARK: - WKNavigationDelegate
    extension WebViewSchemesViewController : WKNavigationDelegate {

    .. (skip) ..

    //MARK:- HERE!!!
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("\(#function)")

        // Check whether WebView Native is linked
        if let url = navigationAction.request.url,
            let urlScheme = url.scheme,
            let urlHost = url.host,
            urlScheme.uppercased() == Constants.schemeKey.uppercased() {
            print("url:\(url)")
            print("urlScheme:\(urlScheme)")
            print("urlHost:\(urlHost)")

            decisionHandler(.cancel)

            // call back!
            self.webView.stringByEvaluatingJavaScript(script: "javascript:testCallBack('\(urlHost)');")

            // popup!
  //            self.webView.stringByEvaluatingJavaScript(script: "javascript:test02();")
            return
        }
        decisionHandler(.allow)
    }

    .. (skip) ..

    ```

## 3. Common
- [ViewController.swift](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/ViewController.swift)
    ```swift
    .. (skip) ..

    extension WKWebView {
        func stringByEvaluatingJavaScript(script: String) {
            self.evaluateJavaScript(script) { (result, error) in
                
            }
        }
    }

    ```
