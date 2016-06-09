//
//  ViewController.swift
//  BlunoTest-Swift
//
//  Created by Joe Longstreet on 6/7/16.
//  Copyright © 2016 DFRobot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DFBlunoDelegate {
    
    let blunoManager = DFBlunoManager.sharedInstance() as! DFBlunoManager
    var discoveredDevices: [DFBlunoDevice] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blunoManager.delegate = self;
        self.blunoManager.scan();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func bleDidUpdateState(bleSupported: Bool) {
        if(bleSupported)
        {
            self.blunoManager.scan()
        }
    }
    
    func didDiscoverDevice(dev: DFBlunoDevice!) {
        var deviceFound = false;
        
        for device in self.discoveredDevices {
            if device.isEqual(dev) {
                deviceFound = true
            }
        }
        
        if(!deviceFound){
            self.discoveredDevices.append(dev);
        }
    }
    
    func readyToCommunicate(dev: DFBlunoDevice!) {
        
    }
    
    func didDisconnectDevice(dev: DFBlunoDevice!) {
        
    }
    
    func didWriteData(dev: DFBlunoDevice!) {
        
    }
    
    func didReceiveData(data: NSData!, device dev: DFBlunoDevice!) {
        
    }
}

