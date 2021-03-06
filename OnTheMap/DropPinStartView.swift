//
//  DropPinStartView.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 10/15/17.
//  Copyright © 2017 Udacity. All rights reserved.
//


import UIKit
import Foundation
import CoreLocation

class DropPinStartView: UIViewController, UITextFieldDelegate
{
    // Classes
    var common : Common!
    
    // Variables
    var keyboardDisplayed = false
    
    // Outlets for view objects
    @IBOutlet weak var lblLocationPrompt: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var btnGeocodeLocation: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    // Login View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
        common = Common()
        common.debug( message: "DropPinStartView::viewDidLoad()" )
        
        txtLocation.delegate = self
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
        // Hide the navigation controller bars for this screen
        if let navigationController = navigationController
        {
            navigationController.isToolbarHidden = true
            navigationController.isNavigationBarHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear( animated )
        common.debug( message: "DropPinStartView::viewWillAppear()" )
        
        resignIfFirstResponder( txtLocation )
    }
    
    @IBAction func initiateGeocode(_ sender: Any)
    {
        common.debug( message: "DropPinStartView::initiateGeocode()" )
        common.debug( message: "DropPinStartView::initiateGeocode() - Location entered: \(txtLocation.text!)" )
        
        if ( txtLocation.text!.isEmpty )
        {
            common.showErrorAlert( vc: self, title: "Location Error", message: "Please enter a location before pressing Find on the Map", button_title: "OK" )
        }
        else
        {
            CLGeocoder().geocodeAddressString( txtLocation.text!, completionHandler:
            {  ( placemarks, error ) in
                    
                if error != nil
                {
                    self.common.debug( message: "Geocode failed: \(error!.localizedDescription)" )
                    self.common.showErrorAlert( vc: self, title: "Geocoding Error", message: "Unable to geocode and find address you entered", button_title: "OK " )
                }
                else if placemarks!.count > 0
                {
                    let placemark = placemarks![0]
                    let location = placemark.location
                    self.common.debug( message: "Geocode Lon: \(location?.coordinate.longitude)" )
                    self.common.debug( message: "Geocode Lat: \(location?.coordinate.latitude )" )
                    
                    // Transition to Map View.
                    let controller = self.storyboard!.instantiateViewController( withIdentifier: "DropPinMapVC" )
                    let dpmvController = controller as! DropPinMapView
                    dpmvController.dropPinCoordinate = ( location?.coordinate )!
                    
                    print ( "going to map drop pin view " )
                    if let navigationController = self.navigationController
                    {
                        navigationController.pushViewController( controller, animated: true )
                    }
                }
            }
            )
        }
    }
    
    @IBAction func cancel(_ sender: Any)
    {
        common.debug( message: "DropPinStartView::cancel()" )
        
        if let navigationController = navigationController
        {
            navigationController.popViewController( animated: true )
        }
    }
    
    // Keyboard Notification setup
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector)
    {
        NotificationCenter.default.addObserver( self, selector: selector, name: notification, object: nil )
    }
    
    func unsubscribeFromAllNotifications()
    {
        NotificationCenter.default.removeObserver( self )
    }
    
    // Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        // Only if the text field has is initial value, then null
        // out when the user starts editing
        if textField.text == "Enter Your Location Here"
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
        common.debug( message: "DropPinStartView::keyboardWillShow()" )
        if !keyboardDisplayed
        {
            view.frame.origin.y -= keyboardHeight( notification )
        }
    }
    
    func keyboardWillHide(_ notification: Notification)
    {
        common.debug( message: "DropPinStartView::keyboardWillHide()" )
        if keyboardDisplayed
        {
            view.frame.origin.y += keyboardHeight( notification )
        }
    }
    
    func keyboardDidShow(_ notification: Notification)
    {
        common.debug( message: "DropPinStartView::keyboardDidShow()" )
        keyboardDisplayed = true
    }
    
    func keyboardDidHide(_ notification: Notification)
    {
        common.debug( message: "DropPinStartView::keyboardDidHide()" )
        keyboardDisplayed = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat
    {
        let userInfo = ( notification as NSNotification ).userInfo
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
    
    @IBAction func userDidTapView(_ sender: UITapGestureRecognizer)
    {
        resignIfFirstResponder( txtLocation )
    }

    func setUIEnabled(_ enabled: Bool)
    {
        common.debug( message: "DropPinStartView::setUIEnabled()" )
        txtLocation.isEnabled = enabled
        btnGeocodeLocation.isEnabled = enabled
        btnCancel.isEnabled = enabled
        
        // adjust login button alpha
        if enabled
        {
            btnGeocodeLocation.alpha = 1.0
            btnCancel.alpha = 1.0
        }
        else
        {
            btnGeocodeLocation.alpha = 0.5
            btnCancel.alpha = 0.5
        }
    }
    
    func resetUI()
    {
        common.debug( message: "DropPinStartView::resetUI()" )
        setUIEnabled( true )
        txtLocation.text?.removeAll()
    }
}

