//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 9/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation

class ParseClient : NSObject
{
    
    func loadStudentInformation()
    {
        let request = NSMutableURLRequest(url: URL(string: Constants.ParseAPI.ParseURL + "?limit=5")!)
        request.addValue( Constants.ParseAPI.ParseAppID, forHTTPHeaderField: "X-Parse-Application-Id" )
        request.addValue( Constants.ParseAPI.ParseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedResult: [String:AnyObject]!
            do
            {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            } catch
            {
                print( "Could not parse the data as JSON: '\(data)'" )
                return
            }
            
            print( "\(parsedResult)")
            
        }
        task.resume()
    }
}
