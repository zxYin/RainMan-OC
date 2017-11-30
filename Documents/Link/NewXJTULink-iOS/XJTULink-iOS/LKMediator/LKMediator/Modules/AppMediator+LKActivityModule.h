//
//  AppMediator+LKActivityModule.h
//  LKMediator
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AppMediator.h"
#import "YLTableView.h"
@interface AppMediator (LKActivityModule)
- (UIViewController *)LKActivity_lectureListViewController;
- (YLTableViewSection *)LKActivity_lectureSection;
@end
