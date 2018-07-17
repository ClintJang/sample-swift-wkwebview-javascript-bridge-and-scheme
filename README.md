# sample-swift-wkwebview-javascript-bridge-and-scheme
[![License](http://img.shields.io/badge/License-MIT-green.svg?style=flat)](https://github.com/clintjang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/LICENSE) [![Swift 4](https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat)](https://swift.org) 

WKWebview로 javascirpt bridge 방식과 url을 scheme 하는 방식을 셈플링했습니다.

... 동작하는 소스는 올렸습니다. 확인해 보셔요~ 

# 정보
## 설명 이미지
.. 준비중

## 1. javascirpt bridge 방식
> 브릿지 연결을 이용한 것과 정의된 url의 스킴을 이용한 웹에서 네이티브로 콜백을 주는 구분이 있습니다. 

- 테스트를 위한 HTML 파일 : [sampleBridge.html](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Resources/sampleBridge.html)
    ```html 
    <html lang="ko">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>
    <script type="text/javascript">
    // alert(1)
    
    function callNative01() {
        try {
            webkit.messageHandlers.callbackHandler.postMessage("callNative01");
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
- swift code 처리 부분 : [WebViewBridgeViewController.swift](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Sample/Bridge/WebViewBridgeViewController.swift) ← 자세한것은 클릭해서 코드를 보세요.
    ```swift 
    .. (중략).. 

    private struct Constants {
        static let callBackHandlerKey = "callbackHandler"
    }

    .. (중략).. 

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

    .. (중략) ..

    // MARK: - WKScriptMessageHandler
    extension WebViewBridgeViewController : WKScriptMessageHandler {
        //MARK:- HERE!!!
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("message.name:\(message.name)")
            if message.name == Constants.callBackHandlerKey {
                print("message.body:\(message.body)")
                
                // popup!
                self.webView.stringByEvaluatingJavaScript(script: "javascript:test01();")
            }
        }
    }

    .. (중략) ..

    ```

## 2. URL의 Scheme를 이용해서 처리하는 방식

- 테스트를 위한 HTML 파일 : [sampleScheme.html](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Resources/sampleScheme.html)
    ```html 
    <html lang="ko">
    <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>

    <script type="text/javascript">
        //alert(2)
    function callNative01() {
        window.location = "nativeScheme://callNative01";
    }
        function test02() {
            alert('test02');
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

- swift code 처리 부분 : [WebViewSchemesViewController.swift](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Sample/Scheme/WebViewSchemesViewController.swift) ← 자세한것은 클릭해서 코드를 보세요.
    ``` swift 
    .. (중략) ..

    private struct Constants {
        static let schemeKey = "nativeScheme"
    }

    .. (중략) ..

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

    .. (중략) ..
    
    // MARK: - WKNavigationDelegate
    extension WebViewSchemesViewController : WKNavigationDelegate {

    .. (중략) ..

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
            
            // popup!
            self.webView.stringByEvaluatingJavaScript(script: "javascript:test02();")
            return
        }
        decisionHandler(.allow)
    }

    .. (중략) ..

    ```
