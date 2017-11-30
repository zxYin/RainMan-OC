//
//  CASHTMLFetcher.m
//  LKLoginModule
//
//  Created by Yunpeng on 16/9/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CASHTMLFetcher.h"
#import "Constants.h"

@implementation CASHTMLFetcher
#pragma mark - YLAPIManager

- (NSString *)host {
    return kCASURL;
}

- (NSString *)path {
    return @"login";
}

- (NSString *)apiVersion {
    return @"";
}

- (BOOL)isAuth {
    return NO;
}

- (YLRequestType)requestType {
    return YLRequestTypeGet;
}


- (BOOL)isResponseJSONable {
    return NO;
}

- (BOOL)isRequestUsingJSON {
    return NO;
}


@end
