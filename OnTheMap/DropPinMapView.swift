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
    var common : Common!
    var parse = ParseClient.sharedInstance()
    
    var appDelegate: AppDelegate!
    var dropPinAnnotation = MKPointAnnotation()
    
    // Cooordinate should be set by Geocoding result from previous view.
    var dropPinCoordinate = CLLocationCoordinate2D()
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    
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
    
    @IBAction func cancel(_ sender: Any)
    {
        common.debug( message: "DropPinMapView::cancel()" )
        self.dismiss( animated: true )
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
           self.dropPinMapView.addAnnotation(self.dropPinAnnotation)
        }
    }
   
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector)
    {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications()
    {
        NotificationCenter.default.removeObserver(self)
    }
    
}
