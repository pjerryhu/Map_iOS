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

class ViewController: UIViewController {


    @IBOutlet var RecordButton: UIButton!
    @IBOutlet var MapInProgress: UILabel!
    @IBOutlet var StopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    

    override func viewWillAppear(animated: Bool){
        StopButton.hidden = true
        RecordButton.enabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func callMap(sender: UIButton) {
        MapInProgress.hidden = false
        StopButton.hidden = false
        RecordButton.enabled = false
        //TODO: load the map
        print("In map progress")
    }
    @IBAction func StopMap(sender: UIButton) {
        MapInProgress.hidden = true
        RecordButton.enabled = true
        print("Stopping map progress")

    }
}

