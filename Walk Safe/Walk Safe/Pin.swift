//
//  Pin.swift
//  Walk Safe
//
//  Created by mac-p on 2/10/16.
//  Copyright © 2016 Tufts University. All rights reserved.
//

import MapKit
class Pin: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}