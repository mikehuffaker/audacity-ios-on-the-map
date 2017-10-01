//
//  MapView.swift
//  OnTheMap
//
//  Created by Mike Huffaker 7/29/17 for Udacity On The Map project.
//  Copyright © 2017 Mike Huffaker.
//

import UIKit
import MapKit

/**
* This view controller demonstrates the objects involved in displaying pins on a map.
*
* The map is a MKMapView.
* The pins are represented by MKPointAnnotation instances.
*
* The view controller conforms to the MKMapViewDelegate so that it can receive a method 
* invocation when a pin annotation is tapped. It accomplishes this using two delegate 
* methods: one to put a small "info" button on the right side of each pin, and one to
* respond when the "info" button is tapped.
*/

class MapView: UIViewController, MKMapViewDelegate
{
   var common : Common!
   var parse : ParseClient!
    
   var appDelegate: AppDelegate!
   var students : [StudentInformation] = [StudentInformation]()
   var annotations = [MKPointAnnotation]()
    
    // The map. See the setup in the Storyboard file. Note particularly that the view controller
    // is set up as the map view's delegate.
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        common = Common()
        common.debug( message: "MapView::viewDidLoad()" )
        
        NotificationCenter.default.addObserver(self, selector: #selector( self.refreshMap ), name: NSNotification.Name( rawValue: Constants.Notifications.StudentDataReloadFinished ), object: nil)
        
        // Get shared instance of parse client class and initiate load of student data
        parse = ParseClient()
        
        if parse.students.isEmpty
        {
            parse.loadStudentInformation()
        }

    }
    
    override func viewWillAppear(_ animated: Bool )
    {
        super.viewWillAppear( animated )
        common.debug( message: "MapView::viewWillAppear()" )
    }
    
    // This method gets called once the PARSE API is done via notification to refresh the map pins
    func refreshMap()
    {
        annotations.removeAll( keepingCapacity: true )
        students = parse.students
        
        common.debug( message: "MapView::refreshMap():Loading students into the Map" )
        for student in students
        {
            common.debug( message: "MapView::refreshMap():Adding \(student.firstName) to the Map" )
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees( student.latitude )
            let long = CLLocationDegrees( student.longitude )
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        performUIUpdatesOnMain {
            self.mapView.addAnnotations(self.annotations)
        }
    }

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        common.debug( message: "MapView::mapView1()" )

        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        common.debug( message: "MapView::mapView2()" )

        if control == view.rightCalloutAccessoryView
        {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!
            {
                // Check to avoid errors with some invalid media URLs in student data
                if toOpen.localizedCaseInsensitiveContains( "http" ) == true
                {
                    let options = [:] as [String : Any]
                    app.open( URL(string: toOpen)!, options: options, completionHandler: nil )
                }
                else
                {
                    common.showErrorAlert( vc: self, title: "Web Link Error", message: "This Students Pin does not have a valid web URL", button_title: "OK" )
                }
            }
        }
    }
}
