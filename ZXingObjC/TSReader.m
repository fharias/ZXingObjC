//
//  TSReader.m
//  ZXingObjC
//
//  Created by FABIO ARIAS on 3/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "TSReader.h"
#import "ZXBinaryBitmap.h"
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

@implementation TSReader

- (TSReader *)init {
    if (self = [super init]) {
    }
    return self;
}


- (ZXResult *)decode:(ZXBinaryBitmap *)image error:(NSError **)error {
    return [self decode:image hints:nil error:error];
}

- (ZXResult *)decode:(ZXBinaryBitmap *)image hints:(ZXDecodeHints *)hints error:(NSError **)error {
    NSLog(@"LLegamos");
    
    return nil;
}


- (ZXResult *)decodeWithImage:(CGImageRef )image error:(NSError *__autoreleasing *)error {
    //NSLog(@"LLegamos con Imagen");
    ZXResult *result = nil;
    @synchronized(self){
        
        TSRequestReader* request = [[TSRequestReader alloc] init];
        TSData * data = [[TSData alloc] init];
        TSDataDevice * device = [[TSDataDevice alloc] init];
        TSDataCoords * coords = [[TSDataCoords alloc] init];
        [data setUserId:@"12345"];
        [data setImage:[self base64EncodeImageRef:image]];
        [device setModel:@"iPhone"];
        [device setPlatform:@"iOS"];
        [device setUuid:@"X"];
        [device setVersion:@"8.1,1"];
        [coords setLatitude:0];
        [coords setLongitude:0];
        [data setCoords:coords];
        [data setDevice:device];
        NSString *jsonString = [data toJSONString];
        //NSLog(@"JSON Output: %@", jsonString);
        [request setData:jsonString];
        [request setPassword:@"xt01epr4"];
        [request setKey:@"f2796643176da5cf868348e9c1381df4fbfcf46e"];
        [request setProcess:@"CheckTag"];
        
        WMService * service = [[WMService alloc] initWithUrl:@"http://www.3signals.co:8080/WMService/WMService"];
        NSString *responseSoap = [service sendWithData:jsonString withProcess:@"CheckTag" withKey:@"f2796643176da5cf868348e9c1381df4fbfcf46e" password:@"xt01epr4"];
        if(!isNull(responseSoap)){
            NSError * error = [[NSError alloc] init];
            TSResponseReader * responseReader = [[TSResponseReader alloc] initWithString:responseSoap
        error:&error];
            if([responseReader.state isEqualToString:@"0"]){
                NSLog(@"Error: %@", responseReader.message);
            }else{
               result = [[ZXResult alloc] initWithText:responseReader.tagid rawBytes:nil resultPoints:nil format:kThreeSignalsFormat];
            }
        }
    }
    return result;
}

// Create Base64 from CGImageRef

- (NSString*) base64EncodeImageRef:(CGImageRef)input{
    UIImage *scannedImage = [[UIImage alloc] initWithCGImage:input];
    
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