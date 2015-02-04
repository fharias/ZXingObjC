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
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@implementation TSReader


- (ZXResult *)decode:(ZXBinaryBitmap *)image error:(NSError **)error {
    return [self decode:image hints:nil error:error];
}

- (ZXResult *)decode:(ZXBinaryBitmap *)image hints:(ZXDecodeHints *)hints error:(NSError **)error {
    NSLog(@"LLegamos");
    
    return nil;
}

- (ZXResult *)decodeWithImage:(CGImageRef *)image error:(NSError *__autoreleasing *)error {
    NSLog(@"LLegamos con Imagen");
    ZXResult *result = [[ZXResult alloc] initWithText:@"OK" rawBytes:nil resultPoints:nil format:kThreeSignalsFormat];
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