//
//  LicensePlateReader.m
//  ZXingObjC
//
//  Created by FABIO ARIAS on 16/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TSReader.h"
#import "ZXBinaryBitmap.h"
#import "ZXImage.h"
#import "ZXDecodeHints.h"
#import "ZXDecoderResult.h"
#import "ZXReader.h"
#import "ZXResult.h"
#import "ZXResultPointCallback.h"
#import "TSRequestReader.h"
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import "WMService.h"
#import "TSResponseReader.h"
#import "ZXHybridBinarizer.h"
#import "ZXCGImageLuminanceSource.h"
#import "LicensePlateReader.h"
#import "NeurallabsClient.m"

@implementation LicensePlateReader

@synthesize password, key, userId, url;
- (LicensePlateReader *)init {
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    NSLog(@"OldLocation %f %f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.location = newLocation;
    //NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    //NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}


- (ZXResult *)decode:(ZXBinaryBitmap *)image error:(NSError **)error {
    return [self decode:image hints:nil error:error];
}

- (ZXResult *)decode:(ZXBinaryBitmap *)image hints:(ZXDecodeHints *)hints error:(NSError **)error {
    //NSLog(@"LLegamos");
    //CGImageRef * imageToRead =nil;
    return nil;
}

- (ZXResult *)decode:(ZXBinaryBitmap *)image imageRef:(CGImageRef*)imageRef hints:(ZXDecodeHints *)hints error:(NSError **)error{
    ZXResult *result = nil;
    @synchronized(self){
        [self.locationManager setDelegate:self];
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        //NSLog(@"URL-3: %@", self.url);
        NSString * jsonStringPl = [self base64EncodeImageRef:imageRef];
        NeurallabsClient * servicePl = [[NeurallabsClient alloc] initWithUrl:[self url]];
        NSString *responseSoapPl = [servicePl sendWithData:jsonStringPl withProcess:nil withKey:nil password:@"BRAINWINNER2015"];
        if(!isNull(responseSoapPl)){
            NSLog(@"Response Plate: %@", responseSoapPl);
        }
    }
    return result;
}


- (ZXResult *)decodeWithImage:(CGImageRef )image error:(NSError *__autoreleasing *)error {
    //NSLog(@"LLegamos con Imagen");
    return nil;
}

// Create Base64 from CGImageRef

- (NSString*) base64EncodeImageRef:(CGImageRef*)input{
    UIImage *scannedImage = [[UIImage alloc] initWithCGImage:*input];
    
    return [self imageToNSString:scannedImage];
}

-(NSString *)imageToNSString:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (void)reset {
    // do nothing
}


@end