//
//  WebViewController.swift
//  NetworkBasic_Assignment
//
//  Created by Mac Pro 15 on 2022/09/12.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var webView: WKWebView!
    
    var destinationURL: String = "https://www.apple.com"
    var httpURL: String = "http://www.me.go.kr" //App Transpot Security Settings(ATSS) 적용: http 접속 가능

    
    override func viewDidLoad() {
        super.viewDidLoad()

        openWebPage(url: httpURL)
        searchBar.delegate = self
    }
    
    //스켈레톤뷰 사용하면 로딩중 이미지 표시 가능
    //url유효성 체크를 위해 guard let 구문을 통해 케이스 구분
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
        print("Invalid URL")
        return
    }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @IBAction func goBackButtonClicked(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func goForwardButtonClicked(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
}
    
extension WebViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        openWebPage(url: searchBar.text!)
    }
}
