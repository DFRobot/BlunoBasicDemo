//
//  DFBlunoDevice.m
//
//  Created by Seifer on 13-12-1.
//  Copyright (c) 2013年 DFRobot. All rights reserved.
//

#import "DFBlunoDevice.h"

@implementation DFBlunoDevice

@synthesize bReadyToWrite = _bReadyToWrite;

-(id)init
{
    self = [super init];
    _bReadyToWrite = NO;
    return self;
}

@end
