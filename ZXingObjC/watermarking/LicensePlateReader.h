//
//  LicensePlateReader.h
//  ZXingObjC
//
//  Created by FABIO ARIAS on 16/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//
#import <ImageIO/ImageIO.h>
#import "ZXReader.h"
#import <CoreLocation/CoreLocation.h>

@class ZXBinaryBitmap, ZXDecodeHints, ZXResult;

/**
 * This implementation can detect and decode Aztec codes in an image.
 */
@interface LicensePlateReader : NSObject <CLLocationManagerDelegate, ZXReader>
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation * location;
- (ZXResult *)decodeWithImage:(CGImageRef )image error:(NSError *__autoreleasing *)error;

@end