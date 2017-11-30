//
//  AppDelegate+HotFix.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2017/4/20.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "AppDelegate+Patch.h"
#import "VendorConstants.h"
#import <JSPatchPlatform/JSPatch.h>
#import "User.h"
//#import ""

@implementation AppDelegate (Patch)
- (void)setupJSPatch {
    [JSPatch startWithAppKey:JSPatchAppKey];
    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDeWRLFSw1hLcL/UNKBX8ojaRSm\nFpZ12y/W4OgPQCmlXZhoG6gyffEZaVAt8159XJpIsSSSYNlH0lf5B+Nlsej8BzNx\nGbWSKyET4OZyBkfeUhL2kVrBY8XY16ooDuCVttlRdHqnNImhYkkZx7WFQR6dRspj\naUzxJk5O0k2h7vgJiQIDAQAB\n-----END PUBLIC KEY-----"];
    NSString *userId = [User sharedInstance].userId;
    if ([NSString notBlank:userId]) {
        [JSPatch setupUserData:@{
            @"userId": userId,
        }];
    }
#if DEBUG
    [JSPatch setupDevelopment];
#endif
    [JSPatch sync];
}
@end
