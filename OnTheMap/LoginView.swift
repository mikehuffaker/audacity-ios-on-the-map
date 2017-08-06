//
//  LoginView.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 7/29/17 for Udacity On The Map project.
//  Copyright © 2017 Mike Huffaker. 
//

import UIKit
import Foundation

class LoginView: UIViewController, UITextFieldDelegate
{
    var common : Common!
    var keyboardDisplayed = false
     
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!


    // Login View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        common = Common()
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)

    }
    
    @IBAction func initiateLoginAttempt(_ sender: Any)
    {
        if Constants.Debug.Logging
        {
            print ( "LoginView::initiateLoginAttempt()" )
            print ( "LoginView::initiateLoginAttempt() - Email entered: \(txtEmail.text!)" )
            print ( "LoginView::initiateLoginAttempt() - Password entered: \(txtPassword.text!)" )
        }
        

        if ( txtEmail.text!.isEmpty )
        {
            common.showErrorAlert( vc: self, title: "Login Error", message: "You must enter an email to log in", button_title: "OK" )
        }
        else if ( txtPassword.text!.isEmpty )
        {
            common.showErrorAlert( vc: self, title: "Login Error", message: "You must enter a password to log in", button_title: "OK" )
        }
        else
        {
            _ = loginToUdacity( email: txtEmail.text!, password: txtPassword.text! )
        }
    
    }
    
    @IBAction func initiateOpenSignupURL(_ sender: Any)
    {
        
        if let url = URL( string: Constants.UdacityAPI.SignupURL )
        {
            if UIApplication.shared.canOpenURL( url )
            {
                UIApplication.shared.open( url, options: [:], completionHandler: nil )
            }
        }
    }
    
    // Login to Udacity
    func loginToUdacity( email: String, password: String ) -> Bool
    {
        if Constants.Debug.Logging
        {
            print ( "LoginView::loginToUdacity()" )
        }
        var loggedIn = false
        
        //let request = NSMutableURLRequest( url: URL(string: Constants.UdacityAPI.UdacitySessionURL)! )
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            if let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if ( statusCode >= 200 && statusCode <= 299 )
                {
                    print("Your request returned a non-error status code: \(statusCode)")
                }
                else
                {
                    print("Your request returned a status code other than 2xx: \(statusCode)")
                    // To do, 403 is bad login, display a message
                    return
                }
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            loggedIn = true
 
        }
        
        /* 7. Start the request */
        task.resume()
        if loggedIn == false
        {
            common.showErrorAlert( vc: self, title: "Login Error", message: "Error logging into Udacity, please try again", button_title: "OK" )
        }
        
        return loggedIn
    }

    
    // Keyboard Notification setup
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector)
    {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        // Only if the text field has is initial value, then null
        // out when the user starts editing
        if textField.text == "Enter Email" || textField.text == "Enter Password"
        {
            textField.text = ""
        }
        
        return
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    func keyboardWillShow(_ notification: Notification)
    {
        if !keyboardDisplayed
        {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification)
    {
        if keyboardDisplayed
        {
            view.frame.origin.y += keyboardHeight(notification)
        }
    }
    
    func keyboardDidShow(_ notification: Notification)
    {
        keyboardDisplayed = true
    }
    
    func keyboardDidHide(_ notification: Notification)
    {
        keyboardDisplayed = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat
    {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func resignIfFirstResponder(_ textField: UITextField)
    {
        if textField.isFirstResponder
        {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject)
    {
        resignIfFirstResponder(txtEmail)
        resignIfFirstResponder(txtPassword)
    }
    
    //
  //  func showErrorAlert ( title: String, message: String, button_title: String )
   // {
        // create the alert
   //     let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
        // add an action (button)
   //     alert.addAction(UIAlertAction(title: button_title, style: UIAlertActionStyle.default, handler: nil))
    
        // show the alert
    //   self.present(alert, animated: true, completion: nil)
    //}

}
