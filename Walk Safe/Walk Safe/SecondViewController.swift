//
//  ViewController.swift
//  Walk Safe
//
//  Created by mac-p on 2/8/16.
//  Copyright © 2016 Tufts University. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager!
    var mylocations: [CLLocation] = []



    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var dropPin: UIToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
//        mapView.mapType = MKMapType.Satellite
        mapView.showsUserLocation = true

        

    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print(userLocation)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized, .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        default: break
        }
    }

    func locationManager( locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]){

        mylocations.append(CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude:mapView.userLocation.coordinate.longitude))
        
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        
        if (locations.count > 1){
            var sourceIndex = locations.count - 1
            var destinationIndex = locations.count - 2
            
            let c1 = locations[sourceIndex].coordinate
            let c2 = locations[destinationIndex].coordinate
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.addOverlay(polyline)
        }
    }
    
    
    func mapView( mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer{
        
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
}
    
    
    
//    //
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation:
//        MKUserLocation) {
//            let center = CLLocationCoordinate2D(latitude:
//                userLocation.coordinate.latitude,
//                longitude: userLocation.coordinate.longitude)
//            let width = 1000.0 // meters
//            let height = 1000.0
//            let region = MKCoordinateRegionMakeWithDistance(center, width,
//                height)
//            mapView.setRegion(region, animated: true)
//    }


