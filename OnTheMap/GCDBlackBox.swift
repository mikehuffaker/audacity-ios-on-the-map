//
//  GCDBlackBox.swift
//  FlickFinder
//
//  Created by Mike Huffaker on 11/5/15.
//  Copyright © 2017. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void)
{
    DispatchQueue.main.async
    {
        updates()
    }
}
