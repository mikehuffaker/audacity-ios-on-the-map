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
    var keyboardDisplayed = false
     
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!


    // Login View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        
    }
    
    
    //if let url = URL(string: "https://apple.com") {
    //    if UIApplication.shared.canOpenURL(url) {
    //        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    //    }
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
    
    

}
