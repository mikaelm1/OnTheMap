//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Mikael Mukhsikaroyan on 2/15/16.
//  Copyright © 2016 msquared. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
