//
//  Constants.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 7/27/17 for Udacity On The Map project.
//  Copyright © 2017 Mike Huffaker.
//

import Foundation

// The file will contain any Constant values to be used across the app
//
// Project Notes
//
// 1. - Login screen with email and password for Udacity account.  Prompt should be Login
//      to Udacity.  Facebook login optional.  Login button along with 2 fields.
// 2. - First screen is a map view.  
// 3. - Shows bar at top with "On The Map" title and 2 icons.
// 4. - Bottom is tab view bar with 2 icons - one for map view and one for list view.
// 5. - Map view can be moved around.
// 6. - The Map will have pins for Udacity students.  Clicking on a pin shows some info
//      About the student plus a link to a website that when clicked on will open that
//      web page on the iOS device.
// 7. - List view has pins with names of students.
// 8. - Top left button has a button to drop a pin for the logged in person.  If a pin is
//      already dropped somewhere, then a dialog box comes up which asks whether or not to
//      override the current pin, or cancel.
// 9.   To drop a pin, another dialog comes up which asks where are you studying today and
//      has a field to enter the location.  There is also a "find it on the map" button 
//      below the field that moves to another view.
// 10.  This other view has a map with the pin dropped on the location in the bottom and
//      has a field to enter a website or social media http link in the top.  There is a
//      submit button at the bottom of this 2nd view.
// 11.  Submit saves the pin on the map and pulls up the initial map view again.
//

struct Constants
{
    struct Debug
    {
        static let Logging = true
    }
    
}

