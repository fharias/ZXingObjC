//
//  TSReader.m
//  ZXingObjC
//
//  Created by FABIO ARIAS on 3/02/15.
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

@implementation TSReader
@synthesize password, key, userId, url;
- (TSReader *)init {
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
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.location = newLocation;
    NSLog(@"OldLocation %f %f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}


- (ZXResult *)decode:(ZXBinaryBitmap *)image error:(NSError **)error {
    return [self decode:image hints:nil error:error];
}

- (ZXResult *)decode:(ZXBinaryBitmap *)image hints:(ZXDecodeHints *)hints error:(NSError **)error {
    NSLog(@"LLegamos");
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
        UIDevice * deviceInfo = [[UIDevice alloc] init];
        TSRequestReader* request = [[TSRequestReader alloc] init];
        TSData * data = [[TSData alloc] init];
        TSDataDevice * device = [[TSDataDevice alloc] init];
        TSDataCoords * coords = [[TSDataCoords alloc] init];
        [data setUserId:[self userId]];
        [data setImage:[self base64EncodeImageRef:imageRef]];
        [device setModel:[deviceInfo model]];
        [device setPlatform:[deviceInfo systemName]];
        [device setUuid:[[deviceInfo identifierForVendor] UUIDString]];
        [device setVersion:[deviceInfo systemVersion]];
        [coords setLatitude:_location.coordinate.latitude];
        [coords setLongitude:_location.coordinate.longitude];
        [data setCoords:coords];
        [data setDevice:device];
        NSString *jsonString = [data toJSONString];
        //NSLog(@"JSON Output: %@", jsonString);
        [request setData:jsonString];
        [request setPassword:self.password];
        [request setKey:self.key];
        [request setProcess:@"CheckTag"];
        //NSLog(@"URL-3: %@", self.url);
        WMService * service = [[WMService alloc] initWithUrl:[self url]];
        NSString *responseSoap = [service sendWithData:jsonString withProcess:@"CheckTag" withKey:[self key] password:[self password]];
        if(!isNull(responseSoap)){
            NSError * error = [[NSError alloc] init];
            TSResponseReader * responseReader = [[TSResponseReader alloc] initWithString:responseSoap
                                                                                   error:&error];
            if([responseReader.state isEqualToString:@"1"]){
                result = [[ZXResult alloc] initWithText:responseReader.tagid rawBytes:nil resultPoints:nil format:kThreeSignalsFormat];
            }else{
                //NSLog(@"Error: %@", responseReader.message);
            }
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