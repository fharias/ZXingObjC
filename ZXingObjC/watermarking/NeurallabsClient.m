//
//  NeurallabsClient.m
//  ZXingObjC
//
//  Created by FABIO ARIAS on 16/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NeurallabsClient.h"


@implementation NeurallabsClient
@synthesize url, webResponse;
NSMutableString *currentElement;
NSMutableDictionary * response;
NSString * elementResponse;
NSString * elementKey;
-(id) initWithUrl:(NSString *)_url{
    self = [super init];
    url = @"http://79.148.240.227:8085/NL.NEURALService/ServiceVPAR.asmx";
    return self;
}

-(NSString *) sendWithData:(NSString *)_data withProcess:(NSString *)process withKey:(NSString *)key password:(NSString *)password{
    NSString * res = nil;
    NSString * soapMessage = [[NSString alloc] initWithFormat:@"<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:neur=\"http://neurallabs.net/\"><soapenv:Header/><soapenv:Body><neur:Read><neur:signature>%@</neur:signature><neur:countryCode>202</neur:countryCode><neur:image>%@</neur:image></neur:Read></soapenv:Body></soapenv:Envelope>", password, _data];
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:urlRequest];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"\"http://neurallabs.net/Read\"" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection =
    [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:NO];
    [theConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                             forMode:NSRunLoopCommonModes];
    [theConnection start];
    if( theConnection )
    {
        webResponse = [NSMutableData data] ;
        response = [[NSMutableDictionary alloc] init];
        if(!currentElement){
            NSLog(@"Id: %@", [response valueForKey:@"id"]);
            return currentElement;
        }
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }

    return res;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    //NSLog(@"response: %@", [response description]);
    webResponse = [[NSMutableData alloc] init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    //NSLog(@"Data: %@", [data debugDescription]);
    [webResponse appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    @synchronized(webResponse){
        NSXMLParser *parser=[[NSXMLParser alloc] initWithData:webResponse];
        [parser setDelegate:self];
        [parser parse];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Error PL : %@",[error localizedDescription]);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //NSLog(@"Parser start");
}
- (void) parser: (NSXMLParser *) parser didStartElement: (NSString *) elementName
   namespaceURI: (NSString *) namespaceURI qualifiedName: (NSString *) qName attributes: (NSDictionary *) attributeDict
{
    //NSLog(@"%@", elementName);
    elementKey = [[NSString alloc] initWithString:elementName];
    if ([elementName isEqualToString:@"ReadResult"])
    {
        
        currentElement = [[NSMutableString alloc] init];
        return;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

    
    //NSLog(@"%@ > %@", elementKey, string);
    [response setObject:string forKey:elementKey];
    if([elementKey isEqualToString:@"plate"])
        [currentElement appendString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"ReadResult"] && [elementName isEqualToString:@"ReadResult"])
    {
        
        //
        return;
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}
@end