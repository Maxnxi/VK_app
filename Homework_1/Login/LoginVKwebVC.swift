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
        
        //cloud animation
        startCloudAnimation()
        
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
    
    //cloud animation
    func startCloudAnimation() {
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        view.addSubview(coverView)
        coverView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        coverView.alpha = 0.6
        UIView.startLoadingCloudAnimation(view: coverView, time: 3)
    }
    
}


extension LoginVKwebVC {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        startCloudAnimation()
        
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
    
