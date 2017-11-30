//
//  HomePageHeaderView.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/11/11.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HomePageHeaderViewHeight 40
@protocol HomePageHeaderViewDelegate <NSObject>
- (void)headerViewDidClick;
@end

@interface HomePageHeaderView : UIView
@property (assign,nonatomic) BOOL isShowMore;
@property (copy,nonatomic) NSString *title;
@property (nonatomic, assign) CGFloat lineSpaceToBottom;
@end
