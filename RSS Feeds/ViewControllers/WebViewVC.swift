//
//  WebViewVC.swift
//  RSS Feeds
//
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class WebViewVC: UIViewController {
    enum titleString: String{
        case wsj = "WSJ"
        case estimatedProgress = "estimatedProgress"
        case error = "Error"
    }
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnForward: UIBarButtonItem!
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var btnRefresh: UIBarButtonItem!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var customNavigationaBar: UINavigationBar!
    @IBOutlet weak var webView: WKWebView!
    var link : String?
    private var estimatedProgressObserver: NSKeyValueObservation?
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        guard link != nil else {return}
        loadWebPage(link!)
        
    }
    deinit {
        print("deinitialized")
    }
    /**
     Function that set up WKWebView properties and set up observer.
     ## Properties
     
     - set uiDelegate
     - set navigationDelegate
     - set allowsBackForwardNavigationGestures
     - set up observer and animate progress *progressView*
     */
    func webViewProperties(){
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        estimatedProgressObserver = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            self?.progressView.progress = Float(webView.estimatedProgress)
        }
    }
    /**
     Function that set up navigationBar properties.
     ## Properties
     
     - navigationItem title
     - create custom back button and assign as leftBarButtonItem, action: *selbtnBack(_:)*
     - set up accessibilityIdentifier for *customNavigationaBar*
     */
    func setUpNavigationBar(){
         let backButton = UIBarButtonItem(title: titleString.wsj.rawValue, style: .done, target: self, action: #selector(selbtnBack(_:)))
        customNavigationaBar.backItem?.backBarButtonItem = backButton
        customNavigationaBar.accessibilityIdentifier = accessibilityIdentifier.customNavigationBar.rawValue
    }

    /**
     Function loads WebPage url also usee method *webViewProperties()*
     
     - Parameter urlString: url of type String.
     
     */
    func loadWebPage(_ urlString: String){
        let myURL = URL(string:urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webViewProperties()

    }
    /**
     Calls *isConnectedToNetwork()* of class **InternetConnectivity**, to check internet Connection
     
     - Returns: Bool, which indicate internet connectivity
     */    func checkForInternetConnection() -> Bool{
        guard InternetConnectivity.isConnectedToNetwork() else {
            let alert = createAlert(globalConstants.noInternetConnection.rawValue, globalConstants.turnOnInternetconnectivity.rawValue)
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    /**
     Show progressView with animation
     */
    func showProgressView() {
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 1
        }, completion: nil)
    }

    /**
     Hide progressView with animation
     */
    func hideProgressView() {
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0
        }, completion: nil)
    }
    
    //MARK: - Button Actions
    @IBAction func selbtnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func selbtnGoBack(_ sender: Any) {
        guard checkForInternetConnection() else{return}
        guard webView.canGoBack else {
            return
        }
        webView.goBack()
    }
    @IBAction func selbtnGoForward(_ sender: Any) {
        guard checkForInternetConnection() else{return}
        guard webView.canGoForward else {
            return
        }
        webView.goForward()
    }
    @IBAction func selbtnRefresh(_ sender: Any) {
        guard checkForInternetConnection() else{return}
        webView.reload()
    }
    @IBAction func selbtnShare(_ sender: Any) {
        let activityViewController = UIActivityViewController (
            activityItems: [webView.url ?? ""],
            applicationActivities: nil
        )
        present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func selbtnSafari(_ sender: Any) {
        guard checkForInternetConnection() else{return}
        guard webView?.url != nil else {return}
        guard let url = webView?.url else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}

//MARK: - WKNavigationDelegate Methods
extension WebViewVC : WKNavigationDelegate,WKUIDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
        let alert = createAlert(titleString.error.rawValue, error.localizedDescription)
        present(alert, animated: true, completion: nil)
    }
}
