//
//  LKSharePanel.h
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/2.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLAlertPanel.h"
#import "LKShareModel.h"
@interface LKSharePanel : YLAlertPanel
@property (nonatomic, strong) LKShareModel *shareModel;
- (instancetype)initWithShareModel:(LKShareModel *)model;
@end
