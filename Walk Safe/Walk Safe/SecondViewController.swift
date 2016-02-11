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

class SecondViewController: UIViewController, MKMapViewDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dropPin: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        mapView.scrollEnabled = false
        mapView.setUserTrackingMode(.Follow, animated: true)
        createTestPolyLine()

    }
    
    @IBAction func dropPin(sender: UIBarButtonItem) {
        let pin = Pin(coordinate: mapView.userLocation.coordinate)
        mapView.addAnnotation(pin)
    }
    
    func createTestPolyLine(){
        let locations = [
            CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude),
//            CLLocation(latitude: 32.7767, longitude: -96.7970),         /* San Francisco, CA */
//            CLLocation(latitude: 37.7833, longitude: -122.4167),        /* Dallas, TX */
//            CLLocation(latitude: 42.2814, longitude: -83.7483),         /* Ann Arbor, MI */
//            CLLocation(latitude: 32.7767, longitude: -96.7970),          /* San Francisco, CA */
            CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude),
        ]
        
        addPolyLineToMap(locations)
    }

    func addPolyLineToMap(locations: [CLLocation!])
    {
        var coordinates = locations.map({ (location: CLLocation!) -> CLLocationCoordinate2D in
            return location.coordinate
        })
        
        let polyline = MKPolyline(coordinates: &coordinates, count: locations.count)
        self.mapView.addOverlay(polyline)
    }
    
    func mapView(mapView: MKMapView!, viewForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay);
            pr.strokeColor = UIColor.redColor().colorWithAlphaComponent(0.5);
            pr.lineWidth = 5;
            return pr;
        }
        
        return nil
    }
//    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation:
        MKUserLocation) {
            let center = CLLocationCoordinate2D(latitude:
                userLocation.coordinate.latitude,
                longitude: userLocation.coordinate.longitude)
            let width = 1000.0 // meters
            let height = 1000.0
            let region = MKCoordinateRegionMakeWithDistance(center, width,
                height)
            mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(animated: Bool){
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

