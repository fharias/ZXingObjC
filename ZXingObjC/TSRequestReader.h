//
//  TSRequestReader.h
//  ZXingObjC
//
//  Created by FABIO ARIAS on 5/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//

#import "JSONModel.h"


@interface TSRequestReader : NSObject
@property (retain, nonatomic) NSString * data;
@property (retain, nonatomic) NSString * process;
@property (retain, nonatomic) NSString * key;
@property (retain, nonatomic) NSString * password;
@end

@interface TSDataCoords : JSONModel
@property (retain, nonatomic) NSNumber * latitude;
@property (retain, nonatomic) NSNumber * longitude;
@end

@interface TSDataDevice : JSONModel
@property (retain, nonatomic) NSString * model;
@property (retain, nonatomic) NSString * platform;
@property (retain, nonatomic) NSString * uuid;
@property (retain, nonatomic) NSString * version;
@property (retain, nonatomic) NSString * name;
@end

@interface TSData : JSONModel
@property (retain, nonatomic) NSString * image;
@property (retain, nonatomic) NSString * userId;
@property (retain, nonatomic) TSDataCoords * coords;
@property (retain, nonatomic) TSDataDevice * device;
@end

