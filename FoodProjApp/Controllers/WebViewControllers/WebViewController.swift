//
//  WebViewController.swift
//  FoodProjApp
//
//  Created by kristians.tide on 22/11/2021.
//

import UIKit
import WebKit


class WebViewController: UIViewController, WKNavigationDelegate {
    
    //get the url string
    var urlString = String()

    @IBOutlet weak var WebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: urlString) else {return}
        
        WebView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish navigation")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
}



