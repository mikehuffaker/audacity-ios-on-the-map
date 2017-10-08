//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 9/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
//import UIKit

class ParseClient : NSObject
{
    var common : Common!
    var lastError : String!
    var students : [StudentInformation] = [StudentInformation]()
    
    override init ()
    {
        super.init()
        self.common = Common()
        self.lastError = ""
    }
    
    func loadStudentInformation()
    {
        common.debug( message: "ParseClient::loadStudentInformation()" )
        
        let request = NSMutableURLRequest(
            url: URL( string: Constants.ParseAPI.ParseURL + "?" +
                Constants.ParseAPI.ParameterKeys.Limit + "&" +
                Constants.ParseAPI.ParameterKeys.Order
            )!
        )
        request.addValue( Constants.ParseAPI.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id" )
        request.addValue( Constants.ParseAPI.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // Error handling, set error code, log error if debugging is on, and notify calling View Controller
            func handleError( error: String, debug_error: String )
            {
                self.lastError = error
                self.common.debug( message: debug_error )
                NotificationCenter.default.post( name: Notification.Name( rawValue: Constants.Notifications.ParseClientError ), object: self )
            }
            
            /* GUARD: Was there an error? */
            guard ( error == nil ) else
            {
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
                    handleError( error: "HTTP Error status code returned: \(statusCode)",  debug_error: "Status code was: \(statusCode)" )
                    return
                }
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else
            {
                handleError( error: "There was a problem retrieving the student list", debug_error: "Repoonse Data object was null" )
                return
            }
            
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedResult: [String:AnyObject]!
            do
            {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch
            {
                handleError( error: "Could not parse the data as JSON'", debug_error: "Could not parse the data as JSON: '\(data)'" )
                return
            }
            
            self.common.debug( message: "Parsed JSON: \(parsedResult)" )
            
            /* GUARD: Is the "results" key in parsedResult? */
            guard let results = parsedResult[Constants.ParseAPI.ResponseKeys.Results] as? [[String:AnyObject]] else
            {
                handleError( error: "Error parsing results", debug_error: "Cannot find key '\(Constants.ParseAPI.ResponseKeys.Results)' in \(parsedResult)" )
                return
            }

            self.students = StudentInformation.loadDictionaryFromResults( results )
            
            // Notification that student objects are reloaded, since sometimes it takes a few seconds/
            // to get data back and the view controllers can know to refresh the views.
            self.common.debug( message: "ParseClient::loadStudentInformation():Student Information parsed and loaded, notifiying view controllers" )
            NotificationCenter.default.post( name: Notification.Name(rawValue: Constants.Notifications.StudentDataReloadFinished ), object: self)
            
        }
        
        task.resume()
    }
    
    class func sharedInstance() -> ParseClient
    {
        struct Singleton
        {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }

}
