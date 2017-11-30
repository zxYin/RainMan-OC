//
//  DynamicConfig.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/12.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "DynamicConfig.h"


static NSString *_kServerURL = kLinkDefaultServerURL;

NSString * kServerURLFunc() {
    return _kServerURL;
}

void __CHANGE_SERVER_URL(NSString *url) {
    NSLog(@"改变服务器URL:%@",url);
    _kServerURL = url;
}
