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

class DropPinMapView: UIViewController, MKMapViewDelegate
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

    //        annotation.title = "\(first) \(last)"
    //       annotation.subtitle = mediaURL
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
        // Pop back to Drop Pin Start view ( Enter location )
        if let navigationController = navigationController
        {
            navigationController.popViewController( animated: true )
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
}
