//
//  TSDecoder.h
//  BarcodeScanner
//
//  Created by FABIO ARIAS on 2/02/15.
//  Copyright (c) 2015 Draconis Software. All rights reserved.
//

#import "ZXReader.h"

@class ZXBinaryBitmap, ZXDecodeHints, ZXResult;

/**
 * This implementation can detect and decode Aztec codes in an image.
 */
@interface TSDecoder : NSObject <ZXReader>

@end
