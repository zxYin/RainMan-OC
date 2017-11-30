//
//  NoticeHeaderView.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/3/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "NoticeHeaderView.h"
#import "Masonry.h"
@interface NoticeHeaderView()

@property (strong,nonatomic) NoticeHeaderViewActionBlock actionBlock;
@end
@implementation NoticeHeaderView

- (void)viewDidClick:(id)sender {
    self.actionBlock();
}



+ (NoticeHeaderView *)noticeHeaderView {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NoticeHeaderView" owner:nil options:nil];
    return nibs.lastObject;
}

+ (NoticeHeaderView *)noticeHeaderViewWithTarget:(id)target action:(SEL)action {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NoticeHeaderView" owner:nil options:nil];
    NoticeHeaderView *header = nibs.lastObject;
    [header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    return header;
}

+ (NoticeHeaderView *)noticeHeaderViewActionUsingBlock:(NoticeHeaderViewActionBlock)blk {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"NoticeHeaderView" owner:nil options:nil];
    NoticeHeaderView *header = nibs.lastObject;
    header.actionBlock = [blk copy];
    [header addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:header action:@selector(viewDidClick:)]];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
        make.height.equalTo(@30);
    }];
    return header;
}
@end
