//
//  NSEtcHosts.m
//  NSEtcHosts
//
//  Created by 崔 明辉 on 15/4/23.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "NSEtcHosts.h"
#import <objc/runtime.h>

#ifdef DEBUG

static NSDictionary *hostTable;
static char NSURLRequestNEH_Host;

@interface NSURLRequest (NSEtcHosts)

@property (nonatomic, strong) NSString *NEH_Host;

@end

@implementation NSURLRequest (NSEtcHosts)

- (instancetype)NEH_initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval {
    NSURLRequest *request;
    if (URL.host != nil && URL.host.length && hostTable[URL.host] != nil) {
        NSString *myURLString = URL.absoluteString;
        myURLString = [myURLString
                       stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"//%@", URL.host]
                       withString:[NSString stringWithFormat:@"//%@", hostTable[URL.host]]];
        NSURL *myURL = [NSURL URLWithString:myURLString];
        request = [self NEH_initWithURL:myURL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    }
    else {
        request = [self NEH_initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    }
    return request;
}

- (NSDictionary *)NEH_AllHTTPHeaderFields {
    if (self.NEH_Host != nil) {
        NSMutableDictionary *fields = [[self NEH_AllHTTPHeaderFields] mutableCopy];
        if (fields == nil) {
            fields = [NSMutableDictionary dictionary];
        }
        [fields setObject:self.NEH_Host forKey:@"Host"];
        return [fields copy];
    }
    else {
        return [self NEH_AllHTTPHeaderFields];
    }
}

- (void)setNEH_Host:(NSString *)NEH_Host {
    objc_setAssociatedObject(self, &NSURLRequestNEH_Host, NEH_Host, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)NEH_Host {
    return objc_getAssociatedObject(self, &NSURLRequestNEH_Host);
}

@end

@implementation NSEtcHosts

+ (void)load {
    {
        Method ori_Method = class_getInstanceMethod([NSURLRequest class], @selector(initWithURL:cachePolicy:timeoutInterval:));
        Method my_Method = class_getInstanceMethod([NSURLRequest class], @selector(NEH_initWithURL:cachePolicy:timeoutInterval:));
        method_exchangeImplementations(ori_Method, my_Method);
    }
    {
        Method ori_Method = class_getInstanceMethod([NSURLRequest class], @selector(allHTTPHeaderFields));
        Method my_Method = class_getInstanceMethod([NSURLRequest class], @selector(NEH_AllHTTPHeaderFields));
        method_exchangeImplementations(ori_Method, my_Method);
    }
}

+ (void)addHost:(NSString *)host ipAddress:(NSString *)ipAddress {
    NSMutableDictionary *mutableHostTable = hostTable == nil ? [NSMutableDictionary dictionary] : [hostTable mutableCopy];
    [mutableHostTable setObject:ipAddress forKey:host];
    hostTable = [mutableHostTable copy];
}

@end

#endif