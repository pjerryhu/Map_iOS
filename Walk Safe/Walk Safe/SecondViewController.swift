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
    
    @IBOutlet weak var NumberOfStreetCrossed: UILabel!
    @IBOutlet weak var foundDash: UILabel!
    @IBOutlet weak var addressDisp: UILabel!
    @IBOutlet weak var NumberOfDetectedIntersection: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
    var placemark: CLPlacemark!
    var FLAG_recording = 0;
    var IntersectionForServer:[[Double]] = []
    var StreetForServer:[[Double]] = []
    var AddressBook:[String] = []
    var State: Int!;
    var FirstState = 1;
    

    
    
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
        AddressBook = []
        StreetForServer = []
        addressDisp.text = "Restart"
        foundDash.text = "Restart"
        NumberOfDetectedIntersection.text = "0"
        NumberOfStreetCrossed.text = "0"
    }

    func findIntersection(){
        let location1 = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location1, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("In findIntersection(), Reverse geocoder failed with error " + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                
                
                let intersecAdd:[String] = pm.addressDictionary?["FormattedAddressLines"] as! [String]
                
                if(intersecAdd.count > 2){
                    let c = [intersecAdd[0] as! String, intersecAdd[1] as! String,intersecAdd[2] as! String]
                    self.addressDisp.text = c.joinWithSeparator(", ")
                    self.foundDash.text = "Not in intersection"
                }
                
                // Identify Intersections
                if self.addressDisp.text!.containsString("–") {
                    self.foundDash.text = "found intersection"
                    
                    //compare the CLLocation of the current intersection with previous identified intersections, if they are they same, then do not add to new intersection list
                    let tempLoc = CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
                    if(self.IntersectionDataCLL.count < 1){
                        //the first address with dash is always added to ensure that the app dont crash because of index out of bound
                        self.IntersectionDataCLL.append(tempLoc)
                        self.IntersectionForServer.append([tempLoc.coordinate.latitude, tempLoc.coordinate.longitude])
                        self.AddressBook.append(self.addressDisp.text!)
                    }else{

                        //First condition
                        //If the new intersection is farther than 30 meters away, then it's a new one
                        if(self.IntersectionDataCLL[ self.IntersectionDataCLL.endIndex-1].distanceFromLocation(tempLoc) > 30){
                            //Second condition: the address(with dash) has to be a new one in the address book
                            if(self.AddressBook.contains(self.addressDisp.text!)){
                            }else{
                                self.foundDash.text = "NewIntersectionFound"
                                self.IntersectionDataCLL.append(tempLoc)
                                self.AddressBook.append(self.addressDisp.text!)
                            
                                self.IntersectionForServer.append([tempLoc.coordinate.latitude, tempLoc.coordinate.longitude])
                                print(self.IntersectionForServer)
                                self.NumberOfDetectedIntersection.text = String(self.IntersectionForServer.count)
                                self.FirstState = 1
                            }
                        }
                    }
                }else{
                    //if no dash found, check current state is either even or odd
                    // determine address parity
                    
                    
//                    print(self.addressDisp.text!)
                    //read to space, store number for parity checking
                    let fullNameAdd = self.addressDisp.text!.characters.split{$0 == " "}.map(String.init)
                    
                    //If first string of Address line contains numbers, then we count the crossing
                    if var currState = Int(fullNameAdd[0]){
                        currState = currState%2
//                    print("currState is ", currState)
                    
                    if(self.FirstState == 1){
                        //set state based on street parity
                        //set FirstState to 0
                        self.State = currState
                        self.FirstState = 0
                    }
                    if(self.State == 0){
                        self.evenState(currState)
                        //When State is even --> call evenState with parameter of current address
                        //   - checks parity of current address.
                        //      a) if even - do nothing
                        //      b) if odd - call crossStreet function, set State to odd

                    }else{
                        self.oddState(currState)
                    //If State is odd --> call oddState with parameter of current address
                    //   - check parity of current address 
                    //     a) if even - call crossStreet function set State to even
                    //     b) if odd - do nothing
                    }
                    // crossStreet function - put down a marker at current coords, add pointto streets crossed array
                    print("self.State is ", self.State)
                    print("self.StreetForServer is ", self.StreetForServer)
                    }
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    func evenState(parity: Int){
        if (parity == 1){
            //if parity is odd
            self.State = parity;
            crossStreet()
        }
    }
    
    func oddState(parity: Int){
        if (parity == 0){
            //if parity is even
            self.State = parity;
            crossStreet()
        }
    }
    
    func crossStreet(){
        //add info into data structure
        self.StreetForServer += [[self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude]]
        self.NumberOfStreetCrossed.text = String( self.StreetForServer.count)
//        print("I'm here")
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

