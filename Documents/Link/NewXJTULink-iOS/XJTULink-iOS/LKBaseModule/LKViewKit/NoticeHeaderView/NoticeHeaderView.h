//
//  NoticeHeaderView.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/3/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^NoticeHeaderViewActionBlock)();


@interface NoticeHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *textLabel;


+ (NoticeHeaderView *)noticeHeaderView;
+ (NoticeHeaderView *)noticeHeaderViewWithTarget:(id)target action:(SEL)action;
+ (NoticeHeaderView *)noticeHeaderViewActionUsingBlock:(NoticeHeaderViewActionBlock)blk;
@end
