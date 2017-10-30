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
    // Classes
    var common : Common!
    var udacity = UdacityClient.sharedInstance()
    
    // Variables
    var keyboardDisplayed = false
    
    // Outlets for view objects
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignup: UIButton!

    // Login View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
        common = Common()
        common.debug( message: "LoginView::viewDidLoad()" )
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
        subscribeToNotification( NSNotification.Name( rawValue: Constants.Notifications.UdacityClientError ), selector: #selector( self.handleUdacityError ) )
        subscribeToNotification( NSNotification.Name( rawValue: Constants.Notifications.UdacityLoginComplete ), selector: #selector( self.completeLogin ) )
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        common.debug( message: "LoginView::viewWillAppear()" )
    }
    
    // If the Udacity login has an error, this function will be called to display an alert in the view controller and
    // reenable the fields and controls so the user can try again.
    func handleUdacityError()
    {
        common.debug( message: "LoginView::handleUdacityError()" )

        performUIUpdatesOnMain
        {
            self.common.showErrorAlert( vc: self, title: "Udacity Error", message: self.udacity.lastError, button_title: "OK" )
        }
        
        setUIEnabled( true )
    }
    
    // If Udacity login returned without errors and a Session ID, then complete login by continuing to the next View.
    func completeLogin()
    {
        common.debug( message: "LoginView::completeLogin()" )

        let controller = self.storyboard!.instantiateViewController( withIdentifier: "MapAndListTabVC" ) as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    
    // One of the view controllers is closing and requested a logout
    @IBAction func initiateLogout()
    {
        common.debug( message: "LoginView::initiateLogout()" )
        
        if ( !udacity.sessionID.isEmpty )
        {
            udacity.logout()
        }
        
        resetUI()
    }
    
    @IBAction func initiateLoginAttempt(_ sender: Any)
    {
        common.debug( message: "LoginView::initiateLoginAttempt()" )
        common.debug( message: "LoginView::initiateLoginAttempt() - Email entered: \(txtEmail.text!)" )
        common.debug( message: "LoginView::initiateLoginAttempt() - Password entered: \(txtPassword.text!)" )
        
        if ( txtEmail.text!.isEmpty )
        {
            common.showErrorAlert( vc: self, title: "Login Error", message: "You must enter a valid email to log in", button_title: "OK" )
        }
        else if ( txtPassword.text!.isEmpty )
        {
            common.showErrorAlert( vc: self, title: "Login Error", message: "You must enter a valid password to log in", button_title: "OK" )
        }
        else
        {
            // Do some checks to make sure the user entered something valid for email and password
            let emailCheck = txtEmail.text! as NSString
            let passwordCheck = txtPassword.text! as NSString
            
            if ( !emailCheck.contains( "@" ) || emailCheck.contains( "Enter Email" ) )
            {
                common.showErrorAlert( vc: self, title: "Login Error", message: "You must enter a valid email to log in", button_title: "OK" )
            }
            else if ( passwordCheck.contains( "Enter Password" ) )
            {
                common.showErrorAlert( vc: self, title: "Login Error", message: "You must enter a valid password to log in", button_title: "OK" )
            }
            else
            {
                setUIEnabled( false )
                udacity.login( email: txtEmail.text!, password: txtPassword.text! )
            }
        }
    }
    
    @IBAction func initiateOpenSignupURL(_ sender: Any)
    {
        common.debug( message: "LoginView::initiateOpenSignupURL()" )

        if let url = URL( string: Constants.UdacityAPI.SignupURL )
        {
            if UIApplication.shared.canOpenURL( url )
            {
                UIApplication.shared.open( url, options: [:], completionHandler: nil )
            }
        }
    }
    
    // Login to Udacity
    //func loginToUdacity( email: String, password: String )
    //{
    //    common.debug( message: "LoginView::loginToUdacity()" )
    //
    //    var loggedIn = false
    //
    //    setUIEnabled(false)
        
        //let request = NSMutableURLRequest( url: URL(string: Constants.UdacityAPI.UdacitySessionURL)! )
    //    let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    //    request.httpMethod = "POST"
    //    request.addValue("application/json", forHTTPHeaderField: "Accept")
    //    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //    request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
    //    let session = URLSession.shared
        
    //    let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // if an error occurs, print it and re-enable the UI
    //        func displayError( error: String, debug_error: String )
    //        {
    //            self.common.debug( message: debug_error )
    //            performUIUpdatesOnMain
    //            {
    //                self.common.showErrorAlert( vc: self, title: "Login Error", message: error, button_title: "OK" )
    //                self.setUIEnabled(true)
    //            }
    //        }

            /* GUARD: Was there an error? */
    //        guard (error == nil) else {
    //            displayError( error: "There was a timeout connecting, please check internet connection", debug_error: "\(error!)" )
    //            return
    //        }
            
            /* GUARD: Did we get a successful 2XX response? */
    //        if let statusCode = (response as? HTTPURLResponse)?.statusCode
    //        {
    //            if ( statusCode >= 200 && statusCode <= 299 )
    //            {
    //                self.common.debug( message: "Your request returned a non-error status code: \(statusCode)" )
    //            }
    //            else
    //            {
    //                displayError( error: "Invalid user ID or Password, please try again",  debug_error: "Status code was: \(statusCode)" )
                    // To do, 403 is bad login, display a message
    //                return
    //            }
    //        }
            
            /* GUARD: Was there any data returned? */
    //        guard let data = data else {
    //            displayError( error: "There was a problem validating your login", debug_error: "Repoonse Data object was null" )
    //            return
    //        }
            
    //        let range = Range(5..<data.count)
    //        let newData = data.subdata(in: range) /* subset response data! */
    //        self.common.debug( message: NSString( data: newData, encoding: String.Encoding.utf8.rawValue )! as String )
            
    //        print ( "LoginView::loginToUdacity() - parsing data" )
    //        let parsedResult: [String:AnyObject]!
    //        do
    //        {
    //            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
    //        } catch
    //        {
    //            displayError( error: "There was a problem validating your login", debug_error: "Could not parse the data as JSON: '\(newData)'" )
    //            return
    //        }
            
            /* GUARD: Is the session id key in parsedResult? */
    //        guard let sessionDictionary = parsedResult[Constants.UdacityAPI.ResponseKeys.Session] as? [String:AnyObject] else
    //        {
    //            displayError( error: "There was a problem validating your login", debug_error: "Cannot find key '\(Constants.UdacityAPI.ResponseKeys.Session )' in \(parsedResult)" )
    //            return
    //        }
            
    //        guard let sessionId = sessionDictionary[Constants.UdacityAPI.ResponseKeys.Id] as? String else
    //        {
    //            displayError( error: "There was a problem validating your login", debug_error: "Cannot find key '\(Constants.UdacityAPI.ResponseKeys.Id) ' in \(parsedResult)" )
    //            return
    //        }
            
    //        print ( "Session ID is: \(sessionId)" )
            
            
     //       let controller = self.storyboard!.instantiateViewController( withIdentifier: "MapAndListTabVC" ) as! UITabBarController
            //    let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapView" )
     //       self.present(controller, animated: true, completion: nil)

            
    //    }
        
        /* 7. Start the request */
    //    task.resume()
        
    //    return
    //}

    
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
    
    func setUIEnabled(_ enabled: Bool)
    {
        common.debug( message: "LoginView::setUIEnabled()" )
        txtEmail.isEnabled = enabled
        txtPassword.isEnabled = enabled
        btnLogin.isEnabled = enabled
        btnSignup.isEnabled = enabled
        
        // adjust login button alpha
        if enabled
        {
            btnLogin.alpha = 1.0
        }
        else
        {
            btnLogin.alpha = 0.5
        }
    }

    func resetUI()
    {
        common.debug( message: "LoginView::resetUI()" )
        setUIEnabled( true )
        txtEmail.text?.removeAll()
        txtPassword.text?.removeAll()
    }
}
