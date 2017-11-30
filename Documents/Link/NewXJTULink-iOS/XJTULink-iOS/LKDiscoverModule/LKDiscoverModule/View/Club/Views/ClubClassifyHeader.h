//
//  ClubClassifyHeader.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/14.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClubClassifyHeader;

@protocol ClubClassifyHeaderDelegate <NSObject>
- (void)clubClassifyHeader:(ClubClassifyHeader *)header didTapIndex:(NSInteger)index;
@end

static const CGFloat ClubClassifyHeaderHeight = 72;

@interface ClubClassifyHeader : UIView
@property (nonatomic, copy) NSArray<NSDictionary *> *items;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, weak) id<ClubClassifyHeaderDelegate> delegate;

- (instancetype)initWithTypes:(NSArray<NSDictionary *> *)clubTypes;
@end
