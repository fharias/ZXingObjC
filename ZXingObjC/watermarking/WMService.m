//
//  WMService.m
//  ZXingObjC
//
//  Created by FABIO ARIAS on 8/02/15.
//  Copyright (c) 2015 zxing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMService.h"
#import "TSRequestReader.h"


@implementation WMService

@synthesize url, webResponse;

NSMutableString *currentElement;
NSDictionary * response;
NSString * elementResponse;
NSString * elementKey;

-(id) initWithUrl:(NSString*)_url{
    self = [super init];
    url = _url;
    return self;
}


-(NSString*) sendWithData:(NSString *)_data withProcess:(NSString *)process withKey:(NSString*) key password:(NSString *) password{
    NSString * soapMessage = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service.threesignals.co/\"><soap:Header></soap:Header><soap:Body><ser:process><request><data>%@</data><process>%@</process><key>%@</key><password>%@</password></request></ser:process></soap:Body></soap:Envelope>", _data, process, key, password];
    NSURL *urlRequest = [NSURL URLWithString:url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:urlRequest];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"\"http://service.threesignals.co/process\"" forHTTPHeaderField:@"SOAPAction"];
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
        //webResponse = [NSMutableData data] ;
        if(!isNull(currentElement)){
            NSLog(@"%@",currentElement);
            return currentElement;
        }
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    return nil;
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
    NSLog(@"Error : %@",[error localizedDescription]);
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
    if ([elementName isEqualToString:@"data"])
    {
        response = [[NSDictionary alloc] init];
        currentElement = [[NSMutableString alloc] init];
        return;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if([elementKey isEqualToString:@"data"])
    [currentElement appendString:string];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"data"] && [elementName isEqualToString:@"state"])
    {
        
        [response setValue:elementResponse forKey:elementName];
        return;
    }
}
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

@end