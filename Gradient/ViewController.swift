//
//  ViewController.swift
//  Gradient
//
//  Created by Julian Bossiere on 4/9/17.
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
    
    let places = Places.getPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        addPolyline()
        addPolygon()
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
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        } else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(polygon: overlay as! MKPolygon)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    
    // Creating polylines and polygons
    func addPolyline() {
        var locations = places.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: &locations, count: locations.count - 1)
        mapView?.add(polyline)
    }
    func addPolygon() {
        var locations = places.map { $0.coordinate }
        let polygon = MKPolygon(coordinates: &locations, count: locations.count-1)
        mapView?.add(polygon)
        
    }


}

