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
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
//    print(mapView.userLocation.coordinate)
    var mylocations: [CLLocationCoordinate2D] = []
//    var receiveLocation: CLLocation! = nil



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
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized, .AuthorizedWhenInUse:
            manager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        default: break
        }
    }

    func locationManager( locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print(mylocations)
        
        let cllc2d1 = mapView.userLocation.coordinate;
        if (cllc2d1.longitude != 0.0 && cllc2d1.latitude != 0.0){
            mylocations.append(mapView.userLocation.coordinate)
        }
//        print("after append", mylocations)

//        
//        let spanX = 0.007
//        let spanY = 0.007
//        let newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
//        mapView.setRegion(newRegion, animated: true)
        
        if (mylocations.count > 1){
            let sourceIndex = mylocations.count - 1
            let destinationIndex = mylocations.count - 2
            
            let c1 = mylocations[sourceIndex]
            let c2 = mylocations[destinationIndex]
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.addOverlay(polyline)
        }else{
            
        }
    }
    
    
    func mapView( mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer{
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
}

