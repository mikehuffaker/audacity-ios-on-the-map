//
//  DropPinMapView.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 10/25/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DropPinMapView: UIViewController, MKMapViewDelegate, UITextFieldDelegate
{
    // Classes
    var common : Common!
    var parse = ParseClient.sharedInstance()
    
    // Variables
    var keyboardDisplayed = false
    var dropPinAnnotation = MKPointAnnotation()
    var dropPinCoordinate = CLLocationCoordinate2D()
    
    // Outlets for view objects
    @IBOutlet weak var txtShareLink: UITextField!
    @IBOutlet weak var dropPinMapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        common = Common()
        common.debug( message: "DropPinMapView::viewDidLoad()" )

        txtShareLink.delegate = self
        
        refreshMap()
    }
    
    override func viewWillAppear(_ animated: Bool )
    {
        super.viewWillAppear( animated )
        common.debug( message: "DropPinMapView::viewWillAppear()" )
    }
    
    // Load or reload the map annotation
    func refreshMap()
    {
        common.debug( message: "DropPinMapView::refreshMap():Loading annotation into the map" )
        
        dropPinAnnotation.coordinate = dropPinCoordinate

        performUIUpdatesOnMain
        {
            self.dropPinMapView.addAnnotation( self.dropPinAnnotation )
        }
    }
   
    @IBAction func postToMap(_ sender: Any)
    {
        common.debug( message: "DropPinMapView::postToMap()" )
        // Here is where to logic to post the pin drop via Parse and
        // pop back-to the Map View Controller will go.
    }
    
    @IBAction func cancel(_ sender: Any)
    {
        common.debug( message: "DropPinMapView::cancel()" )
        
        if let navigationController = navigationController
        {
            var viewControllers = navigationController.viewControllers
            let origCallingVC = viewControllers[ viewControllers.count - 3 ]
            navigationController.popToViewController ( origCallingVC, animated: true )
        }
    }
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector)
    {
        NotificationCenter.default.addObserver( self, selector: selector, name: notification, object: nil )
    }
    
    func unsubscribeFromAllNotifications()
    {
        NotificationCenter.default.removeObserver( self )
    }
    
    // Text Field Delegate Logic
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        // Only if the text field has is initial value, then null
        // out when the user starts editing
        if textField.text == "Enter a Link to Share Here"
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
    
    func resignIfFirstResponder(_ textField: UITextField)
    {
        if textField.isFirstResponder
        {
            textField.resignFirstResponder()
        }
    }

    @IBAction func userDidTapView(_ sender: UITapGestureRecognizer)
    {
        resignIfFirstResponder( txtShareLink )
    }
}
