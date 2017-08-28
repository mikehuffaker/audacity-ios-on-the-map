//
//  Common.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 8/5/17.
//  Copyright © 2017. All rights reserved.
//
//  Utlity class with common methods

import Foundation
import UIKit

class Common
{
    public func showErrorAlert ( vc: UIViewController, title: String, message: String, button_title: String ) ->Void
    {
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
        // add an action (button)
        alert.addAction(UIAlertAction(title: button_title, style: UIAlertActionStyle.default, handler: nil))
    
        // show the alert
        vc.present(alert, animated: true, completion: nil)
        
        return
    }
    
    // Print messages to console if debug flag is on
    public func debug( message: String )
    {
        if Constants.Debug.Logging
        {
            print ( message )
        }
    }
}
