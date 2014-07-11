//
//  DFBlunoManager.m
//
//  Created by Seifer on 13-12-1.
//  Copyright (c) 2013年 DFRobot. All rights reserved.
//

#import "DFBlunoManager.h"

#define kBlunoService @"dfb0"
#define kBlunoDataCharacteristic @"dfb1"

@interface DFBlunoManager ()
{
    BOOL _bSupported;
}

@property (strong,nonatomic) CBCentralManager* centralManager;
@property (strong,nonatomic) NSMutableDictionary* dicBleDevices;
@property (strong,nonatomic) NSMutableDictionary* dicBlunoDevices;

@end

@implementation DFBlunoManager

#pragma mark- Functions

+ (id)sharedInstance
{
	static DFBlunoManager* this	= nil;
    
	if (!this)
    {
		this = [[DFBlunoManager alloc] init];
        this.dicBleDevices = [[NSMutableDictionary alloc] init];
        this.dicBlunoDevices = [[NSMutableDictionary alloc] init];
        this->_bSupported = NO;
        this.centralManager = [[CBCentralManager alloc]initWithDelegate:this queue:nil];
    }
    
	return this;
}

- (void)configureSensorTag:(CBPeripheral*)peripheral
{
    
    CBUUID *sUUID = [CBUUID UUIDWithString:kBlunoService];
    CBUUID *cUUID = [CBUUID UUIDWithString:kBlunoDataCharacteristic];
    
    [BLEUtility setNotificationForCharacteristic:peripheral sCBUUID:sUUID cCBUUID:cUUID enable:YES];
    NSString* key = [peripheral.identifier UUIDString];
    DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
    blunoDev->_bReadyToWrite = YES;
    if ([((NSObject*)_delegate) respondsToSelector:@selector(readyToCommunicate:)])
    {
        [_delegate readyToCommunicate:blunoDev];
    }
    
}

- (void)deConfigureSensorTag:(CBPeripheral*)peripheral
{
    
    CBUUID *sUUID = [CBUUID UUIDWithString:kBlunoService];
    CBUUID *cUUID = [CBUUID UUIDWithString:kBlunoDataCharacteristic];
    
    [BLEUtility setNotificationForCharacteristic:peripheral sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    
}

- (void)scan
{
    [self.centralManager stopScan];
    //[self.dicBleDevices removeAllObjects];
    //[self.dicBlunoDevices removeAllObjects];
    if (_bSupported)
    {
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kBlunoService]] options:nil];
    }

}

- (void)stop
{
    [self.centralManager stopScan];
}

- (void)clear
{
    [self.dicBleDevices removeAllObjects];
    [self.dicBlunoDevices removeAllObjects];
}

- (void)connectToDevice:(DFBlunoDevice*)dev
{
    BLEDevice* bleDev = [self.dicBleDevices objectForKey:dev.identifier];
    [bleDev.centralManager connectPeripheral:bleDev.peripheral options:nil];
}

- (void)disconnectToDevice:(DFBlunoDevice*)dev
{
    BLEDevice* bleDev = [self.dicBleDevices objectForKey:dev.identifier];
    [self deConfigureSensorTag:bleDev.peripheral];
    [bleDev.centralManager cancelPeripheralConnection:bleDev.peripheral];
}

- (void)writeDataToDevice:(NSData*)data Device:(DFBlunoDevice*)dev
{
    if (!_bSupported || data == nil)
    {
        return;
    }
    else if(!dev.bReadyToWrite)
    {
        return;
    }
    BLEDevice* bleDev = [self.dicBleDevices objectForKey:dev.identifier];
    [BLEUtility writeCharacteristic:bleDev.peripheral sUUID:kBlunoService cUUID:kBlunoDataCharacteristic data:data];
}

#pragma mark - CBCentralManager delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn)
    {
        _bSupported = NO;
        NSArray* aryDeviceKeys = [self.dicBlunoDevices allKeys];
        for (NSString* strKey in aryDeviceKeys)
        {
            DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:strKey];
            blunoDev->_bReadyToWrite = NO;
        }
        
    }
    else
    {
        _bSupported = YES;
        
    }
    
    if ([((NSObject*)_delegate) respondsToSelector:@selector(bleDidUpdateState:)])
    {
        [_delegate bleDidUpdateState:_bSupported];
    }
    
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString* key = [peripheral.identifier UUIDString];
    BLEDevice* dev = [self.dicBleDevices objectForKey:key];
    if (dev !=nil )
    {
        //if ([dev.peripheral isEqual:peripheral])
        {
            dev.peripheral = peripheral;
            if ([((NSObject*)_delegate) respondsToSelector:@selector(didDiscoverDevice:)])
            {
                DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
                [_delegate didDiscoverDevice:blunoDev];
            }
        }
    }
    else
    {
        BLEDevice* bleDev = [[BLEDevice alloc] init];
        bleDev.peripheral = peripheral;
        bleDev.centralManager = self.centralManager;
        [self.dicBleDevices setObject:bleDev forKey:key];
        DFBlunoDevice* blunoDev = [[DFBlunoDevice alloc] init];
        blunoDev.identifier = key;
        blunoDev.name = peripheral.name;
        [self.dicBlunoDevices setObject:blunoDev forKey:key];

        if ([((NSObject*)_delegate) respondsToSelector:@selector(didDiscoverDevice:)])
        {
            [_delegate didDiscoverDevice:blunoDev];
        }
    }
}


-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSString* key = [peripheral.identifier UUIDString];
    DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
    blunoDev->_bReadyToWrite = NO;
    if ([((NSObject*)_delegate) respondsToSelector:@selector(didDisconnectDevice:)])
    {
        [_delegate didDisconnectDevice:blunoDev];
    }
}

#pragma  mark - CBPeripheral delegate
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *s in peripheral.services) [peripheral discoverCharacteristics:nil forService:s];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kBlunoService]])
    {
        [self configureSensorTag:peripheral];
    }

}


-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    if ([((NSObject*)_delegate) respondsToSelector:@selector(didReceiveData:Device:)])
    {
        NSString* key = [peripheral.identifier UUIDString];
        DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
        [_delegate didReceiveData:characteristic.value Device:blunoDev];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([((NSObject*)_delegate) respondsToSelector:@selector(didWriteData:)])
    {
        NSString* key = [peripheral.identifier UUIDString];
        DFBlunoDevice* blunoDev = [self.dicBlunoDevices objectForKey:key];
        [_delegate didWriteData:blunoDev];
    }
    
}

@end
