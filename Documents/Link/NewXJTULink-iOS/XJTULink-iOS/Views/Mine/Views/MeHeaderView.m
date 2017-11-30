//
//  MeHeaderView.m
//  
//
//  Created by Yunpeng on 15/9/8.
//
//

#import "MeHeaderView.h"

@implementation MeHeaderView


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self!=nil) {
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = _headImageView.frame.size.width / 2;
    _headImageView.layer.borderWidth = 3.0;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.masksToBounds = YES;
}



+ (MeHeaderView *)meHeaderView {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"MeHeaderView" owner:self options:nil];
    UIView *view = nibViews.lastObject;
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, -MeHeaderViewHeight, [UIScreen mainScreen].bounds.size.width, MeHeaderViewHeight);
    return (MeHeaderView *)view;
}

@end
