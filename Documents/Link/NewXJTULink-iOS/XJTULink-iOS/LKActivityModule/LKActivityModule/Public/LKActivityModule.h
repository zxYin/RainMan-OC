//
//  LKActivityModule.h
//  LKActivityModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKService.h"
#import "LKLectureSection.h"
@interface LKActivityModule : NSObject

@end


@interface LKActivityService : LKService
- (UIViewController *)LKActivity_lectureListViewController:(NSDictionary *)params;
- (YLTableViewSection *)LKActivity_lectureSection:(NSDictionary *)params;
@end
