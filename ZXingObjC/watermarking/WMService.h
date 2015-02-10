//
//  WMService.h
//  ZXingObjC
//
//  Created by FABIO ARIAS on 8/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//
#import "TSRequestReader.h"


@interface WMService : NSObject <NSURLConnectionDelegate,NSXMLParserDelegate>

@property (retain, nonatomic) NSString * url;
@property (retain, nonatomic) NSMutableData * webResponse;

-(id) initWithUrl:(NSString *)_url;
-(NSString*) sendWithData:(NSString *)_data withProcess:(NSString *)process withKey:(NSString*) key password:(NSString *) password;
@end