//
//  LoginVKwebVC.swift
//  Homework_1
//
//  Created by Maksim on 12.04.2021.
//
import UIKit
import Foundation
import WebKit

class LoginVKwebVC: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var wkWebView: WKWebView! {
        didSet {
            wkWebView.navigationDelegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
    }
    
    func configureWebView() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7821622"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.130")
        ]
        guard let urlToRequest = urlComponents.url else {return}
        let request = URLRequest(url: urlToRequest)
        self.wkWebView.load(request)
    }
    
    @IBAction func backBtnWasPrssd(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension LoginVKwebVC {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment.components(separatedBy: "&")
            .map {
                $0.components(separatedBy: "=")
            }
            .reduce([String: String]()) {
                result, param in
                    var dict = result
                    let key = param[0]
                    let value = param[1]
                    dict[key] = value
                    return dict
            }
        guard let token = params["access_token"] else { return }
        Session.shared.token = token
        print("\n Token saved to singleton - done : \(String(describing: Session.shared.token))")
        
        guard let userId = params["user_id"] else {return}
        Session.shared.userId = userId
        print("\n UserId saved to singleton - done : \(String(describing: Session.shared.userId)) \n")
        
        
        //loading UI
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "afterLoginTabBarVC")
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true, completion: nil)
        print("You are Logged in.")
        decisionHandler(.cancel)
    }
    
    
}
    
