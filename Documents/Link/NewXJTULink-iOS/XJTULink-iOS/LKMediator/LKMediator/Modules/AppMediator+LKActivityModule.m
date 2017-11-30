//
//  AppMediator+LKActivityModule.m
//  LKMediator
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator+LKActivityModule.h"
NSString * const kAppMediatorActivityModule= @"LKActivityModule";

NSString * const kAppMediatorActivityServiceLectureSection = @"lectureSection";
NSString * const kAppMediatorActivityServiceLectureListViewController = @"lectureListViewController";
@implementation AppMediator (LKActivityModule)
- (UIViewController *)LKActivity_lectureListViewController {
    return [[self performAction:kAppMediatorActivityServiceLectureListViewController
                       onModule:kAppMediatorActivityModule
                         params:nil]
            safeType:[UIViewController class]];
}

- (YLTableViewSection *)LKActivity_lectureSection {
    return [[self performAction:kAppMediatorActivityServiceLectureSection
                       onModule:kAppMediatorActivityModule
                         params:nil]
            safeType:[YLTableViewSection class]];
}
@end
