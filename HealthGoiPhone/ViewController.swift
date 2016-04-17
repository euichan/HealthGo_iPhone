//
//  ViewController.swift
//  HealthGoiPhone
//
//  Created by 전의찬 on 2016. 4. 17..
//  Copyright © 2016년 전의찬. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate{
    
    @IBOutlet var webView:UIWebView!
   @IBOutlet var textField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        webView.scrollView.bounces = false
        
        let myURL = NSURL(string:"http://health.bitbyte.kr/marketing.html")
        let request = NSURLRequest(URL: myURL!)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}