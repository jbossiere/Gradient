//
//  Places.swift
//  Gradient
//
//  Created by Julian Bossiere on 4/9/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import MapKit


@objc class Places: NSObject {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }

    
    static func getPlaces(dictionary: NSDictionary) -> Places {
        
        print("dictionary: \(dictionary)")
        print(dictionary["latitude"]!)
        let latitude = dictionary["latitude"] as? Double
        let longitude = dictionary["longitude"] as? Double
//        let severity = Int((dictionary["severity"] as? String)!)

        let place = Places(coordinate: CLLocationCoordinate2DMake(latitude!, longitude!))
        
        return place
    }

}

