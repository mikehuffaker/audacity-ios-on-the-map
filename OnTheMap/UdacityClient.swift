//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 10/8/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

class UdacityClient : NSObject
{
    var common : Common!
    var lastError : String!
    var sessionID : String!
    
    override init ()
    {
        super.init()
        self.common = Common()
        self.lastError = ""
    }
    
    class func sharedInstance() -> UdacityClient
    {
        struct Singleton
        {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    // Login to Udacity
    func login( email: String, password: String )
    {
        common.debug( message: "LoginView::loginToUdacity()" )
        
        var loggedIn = false
        
        //setUIEnabled(false)
        
        //let request = NSMutableURLRequest( url: URL(string: Constants.UdacityAPI.UdacitySessionURL)! )
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // Error handling, set error code, log error if debugging is on, and notify calling View Controller
            func handleError( error: String, debug_error: String )
            {
                self.lastError = error
                self.common.debug( message: debug_error )
                NotificationCenter.default.post( name: Notification.Name( rawValue: Constants.Notifications.UdacityClientError ), object: self )
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                handleError( error: "There was a timeout connecting, please check internet connection", debug_error: "\(error!)" )
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            if let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if ( statusCode >= 200 && statusCode <= 299 )
                {
                    self.common.debug( message: "Your request returned a non-error status code: \(statusCode)" )
                }
                else
                {
                    handleError( error: "Invalid user ID or Password, please try again",  debug_error: "Status code was: \(statusCode)" )
                    // To do, 403 is bad login, display a message
                    return
                }
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                handleError( error: "There was a problem validating your login", debug_error: "Repoonse Data object was null" )
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            self.common.debug( message: NSString( data: newData, encoding: String.Encoding.utf8.rawValue )! as String )
            
            print ( "LoginView::loginToUdacity() - parsing data" )
            let parsedResult: [String:AnyObject]!
            do
            {
                parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            } catch
            {
                handleError( error: "There was a problem validating your login", debug_error: "Could not parse the data as JSON: '\(newData)'" )
                return
            }
            
            /* GUARD: Is the session id key in parsedResult? */
            guard let sessionDictionary = parsedResult[Constants.UdacityAPI.ResponseKeys.Session] as? [String:AnyObject] else
            {
                handleError( error: "There was a problem validating your login", debug_error: "Cannot find key '\(Constants.UdacityAPI.ResponseKeys.Session )' in \(parsedResult)" )
                return
            }
            
            // Get Session ID from dictionary and set at the class level
            guard let sessionID = sessionDictionary[Constants.UdacityAPI.ResponseKeys.Id] as? String else
            {
                handleError( error: "There was a problem validating your login", debug_error: "Cannot find key '\(Constants.UdacityAPI.ResponseKeys.Id) ' in \(parsedResult)" )
                return
            }
            
            print ( "Session ID is: \(sessionID)" )

            // Notification that login is complete, since sometimes it takes a few seconds/
            // to get data back and the view controllers can know to continue with the login
            self.common.debug( message: "UdacityClient::login():login successful, session ID obtained, notifiying view controllers" )
            NotificationCenter.default.post( name: Notification.Name(rawValue: Constants.Notifications.UdacityLoginComplete ), object: self)

            //let controller = self.storyboard!.instantiateViewController( withIdentifier: "MapAndListTabVC" ) as! UITabBarController
            //    let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapView" )
            //self.present(controller, animated: true, completion: nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return
    }
    
}
