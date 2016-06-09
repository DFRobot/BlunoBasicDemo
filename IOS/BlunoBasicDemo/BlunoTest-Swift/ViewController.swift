//
//  ViewController.swift
//  BlunoTest-Swift
//
//  Created by Joe Longstreet on 6/7/16.
//  Copyright © 2016 DFRobot. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DFBlunoDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let blunoManager = DFBlunoManager.sharedInstance() as! DFBlunoManager
    var discoveredDevices: [DFBlunoDevice] = []
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blunoManager.delegate = self;
        self.blunoManager.scan();
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
            self.tableView.reloadData()
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
    
    // MARK: TableViewDelegate and TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discoveredDevices.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let blunoDevice = self.discoveredDevices[indexPath.row]
        let cellLabel = "\(blunoDevice.name): \(blunoDevice.identifier)"
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = cellLabel
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog(self.discoveredDevices[indexPath.row].name)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog(self.discoveredDevices[indexPath.row].name)
    }
}

