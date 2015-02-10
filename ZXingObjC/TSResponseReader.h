//
//  TSResponseReader.h
//  ZXingObjC
//
//  Created by FABIO ARIAS on 9/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//

#import "JSONModel.h"

@interface TSResponseReader : JSONModel

@property (retain, nonatomic) NSString * state;
@property (retain, nonatomic) NSString * message;
@property (retain, nonatomic) NSString * tagid;

@end