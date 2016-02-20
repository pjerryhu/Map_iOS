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
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager!
    var placemark: CLPlacemark!

//    print(mapView.userLocation.coordinate)
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
    @IBAction func GeoCoderSwitch(sender: AnyObject) {
//        print("GeoCoderSwitch triggered")
//        self.geocoder.cancelGeocode()
//        let location1 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        

//        let longitude :CLLocationDegrees = -71.116746
//        let latitude :CLLocationDegrees = 42.406995
//        
        let location1 = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
//        let location1 = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
//        print("switching this location: ",location1)

        
        
        geocoder.reverseGeocodeLocation(location1, completionHandler: {(placemarks, error) -> Void in
//            print(location1)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark

//                print("pm.location", pm.location)
//                print("pm.name", pm.name)
                let intersecAdd = pm.addressDictionary?["FormattedAddressLines"]
//                let intersecAdd1 = pm.addressDictionary?["FormattedAddressLines"]?[1]
//                let intersecAdd2 = pm.addressDictionary?["FormattedAddressLines"]?[2]
//                let intersecAdd3 = pm.addressDictionary?["FormattedAddressLines"]?[3]

                let c = [intersecAdd?[0] as! String, intersecAdd?[1] as! String,intersecAdd?[2] as! String]
                self.addressDisp.text = c.joinWithSeparator(", ")
                print( "self.addressDisp.text:", self.addressDisp.text!)
                self.foundDash.text = "Not in intersection"
                if self.addressDisp.text!.containsString("–") {
                    self.foundDash.text = "intersection found!!"
                }


                
//                let intersecAdd2 = (FormattedAddressLines: pm.addressDictionary)
//                print("intersecAdd2", intersecAdd2)
//                print("pm.ISOcountryCode", pm.ISOcountryCode)
//                print("pm.country", pm.country)
//                print("pm.postalCode", pm.postalCode)
//                print("pm.administrativeArea", pm.administrativeArea)
//                print("pm.subAdministrativeArea", pm.subAdministrativeArea)
//                print("pm.locality", pm.locality)
//                print("pm.subLocality", pm.subLocality)
//                print("pm.thoroughfare", pm.thoroughfare)
//                print("pm.subThoroughfare", pm.subThoroughfare)
//                print("pm.region", pm.region)
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
//        print(mylocations)

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

