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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locateMeBtn: UIButton!
    @IBOutlet weak var fab: UIButton!
    
    var locationManager : CLLocationManager!
    
    var currLat: Double!
    var currLong: Double!
    var currDate: String!
    
    var places: [Places] = []
    var innerArray: Array<Any> = []
    var allPlaces: Array<Any> = []
    
    var highlightColor: UIColor = UIColor(red:1.00, green:0.25, blue:0.23, alpha:1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.ratingConfirm), name: NSNotification.Name(rawValue: "supBro"), object: nil)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        currDate = formatter.string(from: Date() as Date)
    }
    
    //Mapview updating user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.0035, 0.0035)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)

        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        if (currLat != location.coordinate.latitude && currLong != location.coordinate.longitude) {
            currLat = location.coordinate.latitude
            currLong = location.coordinate.longitude
        
            // For API Data
            //        let url = URL(string: "http://ec2-34-208-240-230.us-west-2.compute.amazonaws.com")
            //        let url = URL(string: "https://kek7dmzh50.execute-api.us-west-2.amazonaws.com/prod/formatted_json")
            let url = URL(string: "https://kek7dmzh50.execute-api.us-west-2.amazonaws.com/prod/find_parking")
    
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let postString = "datetime=\(currDate!)&latitude=\(currLat!)&longitude=\(currLong!)"
            print(postString)
            request.httpBody = postString.data(using: .utf8)
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
                            print("zones: \(zones)")
    
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

    }
    
    func ratingConfirm() {
//     Function for when a user submits a rating
    }
    
    //Re-locates the user's current location
    @IBAction func locateMe(_ sender: Any) {
        let annotations = [mapView.userLocation]
        mapView.showAnnotations(annotations, animated: true)
        locationManager.startUpdatingLocation()
    }
    
    //Mapview stops updating location if user triggered region change
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let view = mapView.subviews.first
        for recognizer in (view?.gestureRecognizers)! {
            if (recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended) {
                locationManager.stopUpdatingLocation()
            }
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

