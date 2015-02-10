//
//  TSReader.h
//  ZXingObjC
//
//  Created by FABIO ARIAS on 3/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//
#import <ImageIO/ImageIO.h>
#import "ZXReader.h"

@class ZXBinaryBitmap, ZXDecodeHints, ZXResult;

/**
 * This implementation can detect and decode Aztec codes in an image.
 */
@interface TSReader : NSLock<NSLocking>
{
    NSMutableArray *list;
}
- (ZXResult *)decodeWithImage:(CGImageRef )image error:(NSError *__autoreleasing *)error;

@end
