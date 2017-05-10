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
    var innerArray: Array<Any> = []
    var allPlaces: Array<Any> = []
    
    var highlightColor: UIColor = UIColor(red:1.00, green:0.25, blue:0.23, alpha:1.0)
    
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
//        let url = URL(string: "http://ec2-34-208-240-230.us-west-2.compute.amazonaws.com")
        let url = URL(string: "https://kek7dmzh50.execute-api.us-west-2.amazonaws.com/prod/formatted_json")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if let data = data {
                    if let response = try! JSONSerialization.jsonObject(
                    with: data, options: []) as? [String: Any] {
                        print("response: \(response)")
//                        print("zones in response: \(response["zones"])")
                        let zones = response["zones"] as? NSArray
//                        print("zones: \(zones)")
                        
                        for i in 0 ..< zones!.count {
                            let blockface = zones?[i] as? [String: Any]
                            print("blockface yo: \(blockface)")
                            for endpoint in (blockface?.values)! {
                                print(endpoint)
                                if let arr = endpoint as? Array<Any> {
                                    for dict in arr {
                                        print(dict)
                                        let endpoint = Places.getPlaces(dictionary: dict as! NSDictionary)
                                        self.places.append(endpoint)
                                    }
                                } else {
                                    self.innerArray.append(endpoint)
                                }
                            }
                            self.innerArray.append(self.places)
                            self.allPlaces.append(self.innerArray)
                            self.places = []
                            self.innerArray = []
                        }
                        
                        self.addPolyline()
                        
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
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("overlay: \(overlay)")
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = highlightColor
            renderer.lineWidth = 3
            return renderer
        } 
        return MKOverlayRenderer()
    }
    
    
    // Creating polylines
    func addPolyline() {
        for places in allPlaces {
//            print(places)
            for item in places as! Array<Any> {
//                print("item: \(item)")
                if item as? Int == 0 {
                    highlightColor = UIColor(red:0.47, green:0.89, blue:0.27, alpha:1.0)
                } else if item as? Int == 1 {
                    highlightColor = UIColor(red:1.00, green:0.25, blue:0.23, alpha:1.0)
                } else if let blockface = item as? [Places] {
                    var locations = blockface.map { $0.coordinate }
                    let polyline = MKPolyline(coordinates: &locations, count: locations.count)
                    mapView?.add(polyline)
                }
            }
        }
    }
    
    // Following two overrides lock app orientation portrait view
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var shouldAutorotate: Bool {
        return false
    }


}

