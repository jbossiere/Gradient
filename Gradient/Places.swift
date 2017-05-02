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
    var severity: Int?
    var coordinate: CLLocationCoordinate2D
    
    init(name: String?, severity: Int?, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.severity = severity
        self.coordinate = coordinate
    }
    
    
//    init(dictionary: NSDictionary) {
//        print(dictionary)
//        self.name = dictionary["name"] as? String
//       
//        print(self.name)
//        print(dictionary["latitude"]!)
//        print(dictionary["longitude"]!)
//        
//        let lat = dictionary["latitude"] as? Double ?? 0
//        let long = dictionary["longitude"] as? Double ?? 0
//       
//        print(lat)
//        print(long)
//        
//        self.severity = dictionary["severity"]! as? Int
//        self.coordinate = CLLocationCoordinate2DMake(lat, long)
//       
//    }
    
    static func getPlaces(dictionary: NSDictionary) -> Places {
//        guard let path = Bundle.main.path(forResource: "places", ofType: "json"), let array = NSArray(contentsOfFile: path) else { return [] }
        
//        var places = [Places]()
        
        print("dictionary: \(dictionary)")
        let arr = dictionary as? [String: Any]
        print("array: \(arr!)")
        let name = dictionary["name"] as? String
        let latitude = (dictionary["latitude"] as? NSString)?.doubleValue
        let longitude = (dictionary["longitude"] as? NSString)?.doubleValue
        let severity = Int((dictionary["severity"] as? String)!)

        let place = Places(name: name, severity: severity, coordinate: CLLocationCoordinate2DMake(latitude!, longitude!))
//        places.append(place)
//
//        for i in 0 ..< dictionary.count {
//            print("dictionary: \(dictionary)")
//            let arr = dictionary as? [String: Any]
//            print("array: \(arr!)")
//            let name = arr?["name"] as? String
//            let latitude = dictionary?["latitude"] as? Double ?? 0, longitude = arr?["longitude"] as? Double ?? 0
//            let severity = arr?["severity"] as? Int
//            
//            let place = Places(name: name, severity: severity, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
//            places.append(place)
//        }
        
        return place
    }

}

