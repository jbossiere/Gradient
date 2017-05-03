//
//  ViewController.swift
//  Gradient
//
//  Created by Julian Bossiere
//  Copyright © 2017 Julian Bossiere. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locateMeBtn: UIButton!
    @IBOutlet weak var fab: UIButton!
    
    var locationManager : CLLocationManager!
    var userLocated = false
    
    var places: [Places] = []
    var allPlaces: [[Places]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.ratingConfirm), name: NSNotification.Name(rawValue: "supBro"), object: nil)
        
        
        // For hardcoded data
//        do {
//            if let file = Bundle.main.url(forResource: "test", withExtension: "json") {
//                let data = try Data(contentsOf: file)
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                if let object = json as? [String: Any] {
//                    // json is a dictionary
//                    print("dictionary: \(object)")
//                } else if let object = json as? [Any] {
//                    // json is an array
//                    print("array: \(object)")
//                } else {
//                    print("JSON is invalid")
//                }
//            } else {
//                print("no file")
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
        
        // For API Data
        let url = URL(string: "http://ec2-54-68-170-56.us-west-2.compute.amazonaws.com")!
        let request = URLRequest(url: url)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let response = try! JSONSerialization.jsonObject(
                    with: data, options: []) as? [String: Any] {
                        print("response: \(response)")
                        print("zones in response: \(response["zones"])")
                        let zones = response["zones"] as? NSArray
                        print("zones: \(zones)")
                        
                        for i in 0 ..< zones!.count {
                            let endpoint = zones?[i] as? [[String: Any]]
                            print("endpoint yo: \(endpoint)")
                            for j in 0 ..< endpoint!.count {
                                let place = Places.getPlaces(dictionary: (endpoint![j] as NSDictionary))
                                self.places.append(place)
                            }
                            self.allPlaces.append(self.places)
                            self.places = []
                        }
                        
                        self.addPolyline()
//                        self.addPolygon()
                        
                    }
                } else {
                    print("error: \(error)")
                }
        });
        task.resume()
        
    }
    
    func ratingConfirm() {
      
    }
    
    //Re-locates the user's current location
    @IBAction func locateMe(_ sender: Any) {
        let annotations = [mapView.userLocation]
        mapView.showAnnotations(annotations, animated: true)
    }
    
    //Mapview updating user's location
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if userLocated == false {
            userLocated = true
            let annotations = [mapView.userLocation]
            mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    //Mapview rendering polylines and polygons
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKPolyline) -> MKOverlayRenderer {
        print("overlay: \(overlay)")
//        if overlay is MKPolyline {
//            let renderer = MKPolylineRenderer(overlay: overlay)
//            renderer.strokeColor = UIColor.red
//            renderer.lineWidth = 3
//            return renderer
//        } else if overlay is MKPolygon {
//            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
//            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
//            renderer.lineWidth = 2
//            return renderer
//        }
        return MKOverlayRenderer()
    }
    
    
    // Creating polylines and polygons
    func addPolyline() {
        for endpoints in allPlaces {
            let blockface = endpoints
            print("blockface: \(blockface)")
            var locations = blockface.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: &locations, count: locations.count)
            mapView?.add(polyline)
        }
    }
//    func addPolygon() {
//        var locations = places.map { $0.coordinate }
//        let polygon = MKPolygon(coordinates: &locations, count: locations.count)
//        mapView?.add(polygon)
//        
//    }
    
    // Following two overrides lock app orientation portrait view
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }


}

