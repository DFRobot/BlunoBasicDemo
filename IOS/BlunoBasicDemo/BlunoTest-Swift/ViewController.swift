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
    var blunoDevice = DFBlunoDevice()
    var discoveredDevices: [DFBlunoDevice] = []
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataReceivedLabel: UILabel!
    @IBOutlet var dataReceivedField: UITextField!
    @IBOutlet var dataToSendField: UITextField!
    @IBOutlet var dataToSendLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.blunoManager.delegate = self
        self.blunoManager.scan()
        
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
        var deviceFound = false
        
        for device in self.discoveredDevices {
            if device.isEqual(dev) {
                deviceFound = true
            }
        }
        
        if(!deviceFound){
            self.discoveredDevices.append(dev)
            self.tableView.reloadData()
        }
    }
    
    func readyToCommunicate(dev: DFBlunoDevice!) {
        self.blunoDevice = dev;
    }
    
    func didDisconnectDevice(dev: DFBlunoDevice!) {
        NSLog("Disconnected \(dev.name)")
    }
    
    func didWriteData(dev: DFBlunoDevice!) {
        NSLog("Writing data to \(dev.name)")
    }
    
    func didReceiveData(data: NSData!, device dev: DFBlunoDevice!) {
        let textString = NSString.init(data: data, encoding: NSUTF8StringEncoding)
        dataReceivedField.text = textString as? String
    }
    
    // MARK: UI Event Handlers
    @IBAction func buttonClick(sender: AnyObject) {
        let textString = dataToSendField.text
        let data = textString?.dataUsingEncoding(NSUTF8StringEncoding)
        self.blunoManager.writeDataToDevice(data, device: self.blunoDevice)
    }

    // MARK: TableViewDelegate and TableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.discoveredDevices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let blunoDevice = self.discoveredDevices[indexPath.row]
        let cellLabel = "\(blunoDevice.name): \(blunoDevice.identifier)"
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = cellLabel
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.blunoDevice = self.discoveredDevices[indexPath.row]
        self.blunoManager.connectToDevice(self.blunoDevice)
        
        dataReceivedField.enabled = true
        dataToSendField.enabled = true
        sendButton.enabled = true
        
        dataReceivedLabel.textColor = UIColor.blackColor()
        dataToSendLabel.textColor = UIColor.blackColor()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.blunoDevice = self.discoveredDevices[indexPath.row]
        self.blunoManager.disconnectToDevice(self.blunoDevice)
        
        dataReceivedField.enabled = false
        dataToSendField.enabled = false
        sendButton.enabled = false
        
        dataReceivedLabel.textColor = UIColor.grayColor()
        dataToSendLabel.textColor = UIColor.grayColor()
    }
}

