//
//  ViewController.swift
//  HealthGoiPhone
//
//  Created by 전의찬 on 2016. 4. 17..
//  Copyright © 2016년 전의찬. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate{
    
    @IBOutlet var webView:UIWebView!
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blackColor()
        webView.opaque = false;
        webView.backgroundColor = .clearColor()
        webView.scrollView.bounces = false
        
        // 1. Create a authentication context
        let authenticationContext = LAContext()
        var error:NSError?
        
        // 2. Check if the device has a fingerprint sensor
        // If not, show the user an alert view and bail out!
        guard authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
            
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
            
        }
        
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .DeviceOwnerAuthenticationWithBiometrics,
            localizedReason: "개인정보 접근을 위해 지문을 인식해주세요.",
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    
                    // Fingerprint recognized
                    // Go to view controller
                    self.navigateToAuthenticatedViewController()
                    let  alert = UIAlertView(title: "HelathGo", message: "전의찬님의 지문이 확인되었습니다", delegate: self, cancelButtonTitle: "확인")
                    alert.show()
                    
                    
                }else {
                    
                    // Check if there is an error
                    if let error = error {
                        
                        let message = self.errorMessageForLAErrorCode(error.code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                        
                    }
                    
                }
                
            })

    }
    
    func load() {
        
        let myURL = NSURL(string:"http://health.bitbyte.kr")
        let request = NSURLRequest(URL: myURL!)
        webView.loadRequest(request)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    /**
     This method will present an UIAlertViewController to inform the user that the device has not a TouchID sensor.
     */
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle("Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    /**
     This method will present an UIAlertViewController to inform the user that there was a problem with the TouchID sensor.
     
     - parameter error: the error message
     
     */
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        
        showAlertWithTitle("Error", message: message)
        
    }
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        self.load()
    }
    
    /**
     This method presents an UIAlertViewController to the user.
     
     - parameter title:  The title for the UIAlertViewController.
     - parameter message:The message for the UIAlertViewController.
     
     */
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.presentViewController(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    /**
     This method will return an error message string for the provided error code.
     The method check the error code against all cases described in the `LAError` enum.
     If the error code can't be found, a default message is returned.
     
     - parameter errorCode: the error code
     - returns: the error message
     */
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.AppCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.AuthenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.InvalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.PasscodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.SystemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.TouchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.TouchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.UserCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.UserFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
    
    func navigateToAuthenticatedViewController(){
        
        if let loggedInVC = storyboard?.instantiateViewControllerWithIdentifier("ViewController") {
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                
               // navigationController?.pushViewController(loggedInVC, animated: true)
                
            }
            
        }
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}