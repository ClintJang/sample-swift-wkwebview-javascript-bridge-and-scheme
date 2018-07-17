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
- [WebViewBridgeViewController.swift](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Sample/Bridge/WebViewBridgeViewController.swift)

## 2. URL의 Scheme를 이용해서 처리하는 방식

- [sampleScheme.html](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Resources/sampleScheme.html)
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

- [WebViewSchemesViewController.swift](https://github.com/ClintJang/sample-swift-wkwebview-javascript-bridge-and-scheme/blob/master/JWSWebViewSample/Sample/Scheme/WebViewSchemesViewController.swift)
