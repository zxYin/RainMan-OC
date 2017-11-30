//
//  ToolsViewCell.m
//  
//
//  Created by Yunpeng on 15/8/26.
//
//

#import "ToolsViewCell.h"

#import "UIImage+Tint.h"
NSString *const ToolsViewCellIdentifier = @"ToolsViewCell";

@interface ToolsViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *flowLogo;
@property (weak, nonatomic) IBOutlet UIImageView *cardLogo;


@end

@implementation ToolsViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)drawRect:(CGRect)rect {
    CGFloat xPosition = self.frame.size.width/2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context,UIColorFromRGB(0xe5e5e5).CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,xPosition, 20);
    CGContextAddLineToPoint(context, xPosition, 40);
    CGContextStrokePath(context);
    
}

- (IBAction)leftButton:(UIButton *)sender {
    if (self.leftButtonEvent) {
        self.leftButtonEvent(self);
    }
}

- (IBAction)rightButton:(UIButton *)sender {
    if (self.rightButtonEvent) {
        self.rightButtonEvent(self);
    }
}

#pragma mark - YLTableViewCellProtocol
- (void)configWithViewModel:(id)viewModel {
    self.viewModel = viewModel;
    RAC(self.flowLabel, text) =
    [RACObserve(self.viewModel, flow) takeUntil:self.rac_prepareForReuseSignal];
    
    RAC(self.balanceLabel, text) =
    [RACObserve(self.viewModel, balance) takeUntil:self.rac_prepareForReuseSignal];
}

+ (CGFloat)height {
    return ToolsViewCellHeight;
}

@end
