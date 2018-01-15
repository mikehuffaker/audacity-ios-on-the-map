//
//  Constants.swift
//  OnTheMap
//
//  Created by Mike Huffaker on 7/27/17 for Udacity On The Map project.
//  Copyright © 2017 Mike Huffaker.
//

import Foundation

// The file will contain any Constant values to be used across the app and reduce hard-coding of values

struct Constants
{
    struct Debug
    {
        static let Logging = true
    }
  
    struct Notifications
    {
        static let ParseClientError = "com.mikehuffaker.ParseClientErrorNotificationKey"
        static let StudentDataReloadFinished = "com.mikehuffaker.ParseClientReloadNotificationKey"
        static let UdacityClientError = "com.mikehuffaker.UdacityClientErrorNotificationKey"
        static let UdacityLoginComplete = "com.mikehuffaker.UdacityLoginCompleteNotificationKey"
        static let UdacityLogoutComplete = "com.mikehuffaker.UdacityLogoutCompleteNotificationKey"
    }
    
    struct UdacityAPI
    {
        static let SignupURL = "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated"
        static let UdacitySessionURL = "https://www.udacity.com/api/session"
        
        // MARK: TMDB Response Keys
        struct ResponseKeys
        {
            // Login/Session API response
            static let Account = "account"
            static let Registered = "registered"
            static let Key = "key"
            static let Session = "session"
            static let Id = "id"
            static let Expiration = "expiration"
        }
    }
    
    struct ParseAPI
    {
        static let ParseURL = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let ParseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ParseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        struct ParameterKeys
        {
            // Get parms
            //static let Limit = "limit=100"
            static let Limit = "limit=20"
            static let Order = "order=-updatedAt"
            static let Skip = "skip"
            static let Where = "where"
        }
        
        struct ResponseKeys
        {
            static let Results = "results"
            static let CreatedAt = "createdAt"
            static let FirstName = "firstName"
            static let LastName = "lastName"
            static let Latitude = "latitude"
            static let Longitude = "longitude"
            static let MapString = "mapString"
            static let MediaURL = "mediaURL"
            static let ObjectID = "objectId"
            static let UniqueKey = "uniqueKey"
            static let UpdateAt = "updateAt"
        }
    }
}

