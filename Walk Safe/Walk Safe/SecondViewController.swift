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
    
    @IBOutlet weak var foundDash: UILabel!
    @IBOutlet weak var addressDisp: UILabel!
    @IBOutlet weak var NumberOfDetectedIntersection: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
    var placemark: CLPlacemark!
    var FLAG_recording = 0;
    var IntersectionForServer:[[Double]] = []
    

    
    
    //    print(mapView.userLocation.coordinate)
    var IntersectionDataCLL: [CLLocation] = []
    var mylocations: [CLLocationCoordinate2D] = []
    var geoLocations: [String] = []
    let geocoder = CLGeocoder()
    @IBOutlet weak var Geocoderswtich: UIButton!
    
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
        mapView.addSubview(addressDisp)
        addressDisp.translatesAutoresizingMaskIntoConstraints=false
    }
    @IBAction func StartRecording(sender: AnyObject) {
        FLAG_recording = 1
    }
    @IBAction func FinishRecording(sender: AnyObject) {
        FLAG_recording = 0
        let overlay = mapView.overlays
        mapView.removeOverlays(overlay)
        /*
        Need to send the information to the server
        */
        
        mylocations=[]
        IntersectionDataCLL = []
        IntersectionForServer = []
        
    }
//    @IBAction func GeoCoderSwitch(sender: AnyObject) {
//        
//        let location1 = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
//        
//        geocoder.reverseGeocodeLocation(location1, completionHandler: {(placemarks, error) -> Void in
//            
//            if error != nil {
//                print("Reverse geocoder failed with error" + error!.localizedDescription)
//                return
//            }
//            if placemarks!.count > 0 {
//                let pm = placemarks![0] as CLPlacemark
//                
//                let intersecAdd = pm.addressDictionary?["FormattedAddressLines"]
//                
//                let c = [intersecAdd?[0] as! String, intersecAdd?[1] as! String,intersecAdd?[2] as! String]
//                self.addressDisp.text = c.joinWithSeparator(", ")
////                print( "self.addressDisp.text:", self.addressDisp.text!)
//                self.foundDash.text = "Not in intersection"
//                if self.addressDisp.text!.containsString("–") {
//                    
//                    
//                    self.foundDash.text = "found intersection"
//                    let tempLoc = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
//                    if(self.IntersectionDataCLL.count < 1){
//                        self.IntersectionDataCLL.append(tempLoc)
//                    }else{
//                        if(self.IntersectionDataCLL[ self.IntersectionDataCLL.endIndex-1].distanceFromLocation(tempLoc) > 30){
//                            self.foundDash.text = "NewIntersectionFound"
//                            self.IntersectionDataCLL.append(tempLoc)
//                        }
//                    }
//                }
//            }
//            else {
//                print("Problem with the data received from geocoder")
//            }
//        })
//        
//    }
//    
    func findIntersection(){
        let location1 = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location1, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("In findIntersection(), Reverse geocoder failed with error " + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                
                
                let intersecAdd = pm.addressDictionary?["FormattedAddressLines"]
                let c = [intersecAdd?[0] as! String, intersecAdd?[1] as! String,intersecAdd?[2] as! String]
                self.addressDisp.text = c.joinWithSeparator(", ")
//                print( "self.addressDisp.text:", self.addressDisp.text!)
                self.foundDash.text = "Not in intersection"
                
                // Identify Intersections
                if self.addressDisp.text!.containsString("–") {
                    self.foundDash.text = "found intersection"
                    
                    //compare the CLLocation of the current intersection with previous identified intersections, if they are they same, then do not add to new intersection list
                    let tempLoc = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                    if(self.IntersectionDataCLL.count < 1){
                        self.IntersectionDataCLL.append(tempLoc)
                        self.IntersectionForServer.append([tempLoc.coordinate.latitude, tempLoc.coordinate.longitude])
                    }else{
                        
                        //If the new intersection is farther than 30 meters away, then it's a new one
                        //also need to check if the formatted address is the same, it would probably significantly lower the false positive number
                        if(self.IntersectionDataCLL[ self.IntersectionDataCLL.endIndex-1].distanceFromLocation(tempLoc) > 30){
                            self.foundDash.text = "NewIntersectionFound"
                            self.IntersectionDataCLL.append(tempLoc)
                            self.IntersectionForServer.append([tempLoc.coordinate.latitude, tempLoc.coordinate.longitude])
                            print(self.IntersectionForServer)
                            self.NumberOfDetectedIntersection.text = String(self.IntersectionForServer.count)
                        }
                    }
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
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
        
        
        if (FLAG_recording == 1) {
            let cllc2d1 = mapView.userLocation.coordinate;
            //        let cllc2d1CLL = CLLocation(latitude: cllc2d1.latitude, longitude: cllc2d1.longitude )
            if (cllc2d1.longitude != 0.0 && cllc2d1.latitude != 0.0){
                mylocations.append(mapView.userLocation.coordinate)
                
                //            IntersectionDataCLL.append(cllc2d1CLL)
            }
            //        print("after append", mylocations)
            
            //
            //        let spanX = 0.007
            //        let spanY = 0.007
            //        let newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
            //        mapView.setRegion(newRegion, animated: true)
            
            if (mylocations.count > 5){
                let sourceIndex = mylocations.count - 1
                let destinationIndex = mylocations.count - 2
                
                let c1 = mylocations[sourceIndex]
                let c2 = mylocations[destinationIndex]
                var a = [c1, c2]
                let polyline = MKPolyline(coordinates: &a, count: a.count)
                mapView.addOverlay(polyline)
                findIntersection()
                
            
            }
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

