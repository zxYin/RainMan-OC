//
//  LKCardHeader.m
//  LKCardModule
//
//  Created by Yunpeng on 2016/9/19.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CardHeaderView.h"
#import "ViewsConfig.h"
@implementation CardHeaderView



+ (instancetype)cardHeaderView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CardHeaderView" owner:nil options:nil];
    
    CardHeaderView *header = [nibView objectAtIndex:0];
    header.frame = CGRectMake(0,0,MainScreenSize.width,CardHeaderViewHeight);
    return header;
}

@end
