//
//  LKActivityModule.m
//  LKActivityModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKActivityModule.h"
#import "LectureListViewController.h"
@implementation LKActivityModule

@end

@implementation LKActivityService
- (UIViewController *)LKActivity_lectureListViewController:(NSDictionary *)params {
    return [[LectureListViewController alloc] init];
}
- (YLTableViewSection *)LKActivity_lectureSection:(NSDictionary *)params {
    return [[LKLectureSection alloc] init];
}
@end
