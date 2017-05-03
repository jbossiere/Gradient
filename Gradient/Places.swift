//
//  Places.swift
//  Gradient
//
//  Created by Julian Bossiere on 4/9/17.
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import MapKit


@objc class Places: NSObject {
    var name: String?
    var coordinate: CLLocationCoordinate2D
    
    init(name: String?, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.coordinate = coordinate
    }

    
    static func getPlaces(dictionary: NSDictionary) -> Places {
        
        print("dictionary: \(dictionary)")
        let name = dictionary["name"] as? String
        let latitude = (dictionary["latitude"] as? NSString)?.doubleValue
        let longitude = (dictionary["longitude"] as? NSString)?.doubleValue
//        let severity = Int((dictionary["severity"] as? String)!)

        let place = Places(name: name, coordinate: CLLocationCoordinate2DMake(latitude!, longitude!))
        
        return place
    }

}

