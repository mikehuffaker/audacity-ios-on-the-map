//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 9/3/17.
//  Copyright © 2017 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct StudentInformation
{
    let createdAt : String
    let firstName : String
    let lastName  : String
    let latitude  : Double
    let longitude : Double
    let mapString : String
    let mediaURL  : String
    let objectId  : String
    let uniqueKey : String
    let updatedAt : String
    
    init( dictionary: [String:AnyObject] )
    {
        print ( "Called init" )
        // Do to bad data - sometimes null values being returned - added checks to handle that
        createdAt = dictionary[Constants.ParseAPI.ResponseKeys.CreatedAt] != nil ?
                    dictionary[Constants.ParseAPI.ResponseKeys.CreatedAt] as! String : ""
        
        firstName = dictionary[Constants.ParseAPI.ResponseKeys.FirstName] != nil ?
                    dictionary[Constants.ParseAPI.ResponseKeys.FirstName] as! String : ""

        lastName = dictionary[Constants.ParseAPI.ResponseKeys.LastName] != nil ?
                   dictionary[Constants.ParseAPI.ResponseKeys.LastName] as! String : ""
        
        latitude  = dictionary[Constants.ParseAPI.ResponseKeys.Latitude] != nil ?
                    dictionary[Constants.ParseAPI.ResponseKeys.Latitude] as! Double : 0.0
        
        longitude = dictionary[Constants.ParseAPI.ResponseKeys.Longitude] != nil ?
                    dictionary[Constants.ParseAPI.ResponseKeys.Longitude] as! Double : 0.0
        
        mapString = dictionary[Constants.ParseAPI.ResponseKeys.MapString] != nil ?
                    dictionary[Constants.ParseAPI.ResponseKeys.MapString] as! String : ""
        
        mediaURL  = dictionary[Constants.ParseAPI.ResponseKeys.MediaURL] != nil ?
                    dictionary[Constants.ParseAPI.ResponseKeys.MediaURL] as! String : ""
        
        objectId  = dictionary[Constants.ParseAPI.ResponseKeys.ObjectID] != nil ?
                    dictionary[Constants.ParseAPI.ResponseKeys.ObjectID] as! String : ""
        
        uniqueKey = dictionary[Constants.ParseAPI.ResponseKeys.UniqueKey] != nil ?
                    dictionary[Constants.ParseAPI.ResponseKeys.UniqueKey] as! String : ""
        
        updatedAt = dictionary[Constants.ParseAPI.ResponseKeys.UpdateAt] != nil ?
                    dictionary[Constants.ParseAPI.ResponseKeys.UpdateAt] as! String : ""
    }
    
    static func loadDictionaryFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation]
    {
        print ( "Loading students from dictionary" )
        var students = [StudentInformation]()
        
        for student in results
        {
            print ( "Loading students: \( student["firstName"] ) " )
            students.append( StudentInformation( dictionary: student ) )
        }
        
        return students
    }
    
    // For testing only - load from hard coded values
    static func hardCodedLocationData() -> [[String : Any]]
    {
        let tempDictionary =
        [
        [
        "createdAt" : "2015-02-24T22:27:14.456Z",
        "firstName" : "Jessica",
        "lastName" : "Uelmen",
        "latitude" : 28.1461248,
        "longitude" : -82.75676799999999,
        "mapString" : "Tarpon Springs, FL",
        "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
        "objectId" : "kj18GEaWD8",
        "uniqueKey" : "872458750",
        "updatedAt" : "2015-03-09T22:07:09.593Z"
        ], [
        "createdAt" : "2015-02-24T22:35:30.639Z",
        "firstName" : "Gabrielle",
        "lastName" : "Miller-Messner",
        "latitude" : 35.1740471,
        "longitude" : -79.3922539,
        "mapString" : "Southern Pines, NC",
        "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
        "objectId" : "8ZEuHF5uX8",
        "uniqueKey" : "2256298598",
        "updatedAt" : "2015-03-11T03:23:49.582Z"
        ], [
        "createdAt" : "2015-02-24T22:30:54.442Z",
        "firstName" : "Jason",
        "lastName" : "Schatz",
        "latitude" : 37.7617,
        "longitude" : -122.4216,
        "mapString" : "18th and Valencia, San Francisco, CA",
        "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
        "objectId" : "hiz0vOTmrL",
        "uniqueKey" : "2362758535",
        "updatedAt" : "2015-03-10T17:20:31.828Z"
        ], [
        "createdAt" : "2015-03-11T02:48:18.321Z",
        "firstName" : "Jarrod",
        "lastName" : "Parkes",
        "latitude" : 34.73037,
        "longitude" : -86.58611000000001,
        "mapString" : "Huntsville, Alabama",
        "mediaURL" : "https://linkedin.com/in/jarrodparkes",
        "objectId" : "CDHfAy8sdp",
        "uniqueKey" : "996618664",
        "updatedAt" : "2015-03-13T03:37:58.389Z"
        ]
        ]
        
        return tempDictionary
    }
}

