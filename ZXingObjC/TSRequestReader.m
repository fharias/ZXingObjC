//
//  TSRequestReader.m
//  ZXingObjC
//
//  Created by FABIO ARIAS on 5/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSRequestReader.h"

@implementation TSRequestReader

@synthesize data, process, key, password;


@end

@implementation TSDataDevice
@synthesize name, uuid, model, version, platform;

@end

@implementation TSDataCoords

@synthesize latitude, longitude;

@end

@implementation TSData

@synthesize image, userId, coords, device;

@end