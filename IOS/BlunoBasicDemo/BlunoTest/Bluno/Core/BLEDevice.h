//
//  bleDevice.h
//
//
//  Created by Seifer on 13-10-12.
//  Copyright (c) 2013年 DFRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface BLEDevice : NSObject

/// Pointer to CoreBluetooth peripheral
@property (strong,nonatomic) CBPeripheral* peripheral;
/// Pointer to CoreBluetooth manager that found this peripheral
@property (strong,nonatomic) CBCentralManager* centralManager;
/// Pointer to dictionary with device setup data
@property (strong,nonatomic) NSMutableDictionary* dicSetupData;
/// Current Devic has some resources
@property (strong,nonatomic) NSMutableArray* aryResources;

@end

