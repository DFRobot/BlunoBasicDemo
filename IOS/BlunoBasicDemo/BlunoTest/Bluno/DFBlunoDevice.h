//
//  DFBlunoDevice.h
//
//  Created by Seifer on 13-12-1.
//  Copyright (c) 2013年 DFRobot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFBlunoDevice : NSObject
{
@public
    BOOL _bReadyToWrite;
}

@property(strong, nonatomic) NSString* identifier;
@property(strong, nonatomic) NSString* name;
@property(assign, nonatomic, readonly) BOOL bReadyToWrite;

@end
