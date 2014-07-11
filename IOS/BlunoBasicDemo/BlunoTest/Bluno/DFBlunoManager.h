//
//  DFBlunoManager.h
//
//  Created by Seifer on 13-12-1.
//  Copyright (c) 2013年 DFRobot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEUtility.h"
#import "BLEDevice.h"
#import "DFBlunoDevice.h"

@protocol DFBlunoDelegate <NSObject>
@required

/**
[""] *	@brief	Invoked whenever the central manager's state has been updated.
[""] *
[""] *	@param 	bleSupported 	Boolean
[""] *
[""] *	@return	void
[""] */
-(void)bleDidUpdateState:(BOOL)bleSupported;

/**
[""] *	@brief	Invoked whenever the Device has been Discovered.
[""] *
[""] *	@param 	dev 	DFBlunoDevice
[""] *
[""] *	@return	void
[""] */
-(void)didDiscoverDevice:(DFBlunoDevice*)dev;

/**
[""] *	@brief	Invoked whenever the Device is ready to communicate.
[""] *
[""] *	@param 	dev 	DFBlunoDevice
[""] *
[""] *	@return	void
[""] */
-(void)readyToCommunicate:(DFBlunoDevice*)dev;

/**
[""] *	@brief	Invoked whenever the Device has been disconnected.
[""] *
[""] *	@param 	dev 	DFBlunoDevice
[""] *
[""] *	@return	void
[""] */
-(void)didDisconnectDevice:(DFBlunoDevice*)dev;

/**
[""] *	@brief	Invoked whenever the data has been written to the BLE Device.
[""] *
[""] *	@param 	dev 	DFBlunoDevice
[""] *
[""] *	@return	void
[""] */
-(void)didWriteData:(DFBlunoDevice*)dev;

/**
[""] *	@brief	Invoked whenever the data has been received from the BLE Device.
[""] *
[""] *	@param 	data 	Data
[""] *	@param 	dev 	DFBlunoDevice
[""] *
[""] *	@return	void
[""] */
-(void)didReceiveData:(NSData*)data Device:(DFBlunoDevice*)dev;


@end

@interface DFBlunoManager : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,weak) id<DFBlunoDelegate> delegate;

/**
[""] *	@brief	Singleton
[""] *
[""] *	@return	DFBlunoManager
[""] */
+ (id)sharedInstance;

/**
[""] *	@brief	Scan the BLUNO device
[""] *
[""] *	@return	void
[""] */
- (void)scan;

/**
[""] *	@brief	Stop scanning
[""] *
[""] *	@return	void
[""] */
- (void)stop;

/**
[""] *	@brief	Clear the list of the discovered device
[""] *
[""] *	@return	void
[""] */
- (void)clear;

/**
[""] *	@brief	Connect to device
[""] *
[""] *	@param 	dev 	DFBlunoDevice
[""] *
[""] *	@return	void
[""] */
- (void)connectToDevice:(DFBlunoDevice*)dev;

/**
[""] *	@brief	Disconnect from the device
[""] *
[""] *	@param 	dev 	DFBlunoDevice
[""] *
[""] *	@return	void
[""] */
- (void)disconnectToDevice:(DFBlunoDevice*)dev;

/**
[""] *	@brief	Write the data to the device
[""] *
[""] *	@param 	data 	Daya
[""] *	@param 	dev 	DFBlunoDevice
[""] *
[""] *	@return	void
[""] */
- (void)writeDataToDevice:(NSData*)data Device:(DFBlunoDevice*)dev;

@end
