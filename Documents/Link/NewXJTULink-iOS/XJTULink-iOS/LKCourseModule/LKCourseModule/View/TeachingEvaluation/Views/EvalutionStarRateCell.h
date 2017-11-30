//
//  EvalutionStarRateCell.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/12/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
#define EvalutionStarRateCellHeight 68

@interface EvalutionStarRateCell : UITableViewCell
@property (nonatomic, assign, readonly) NSInteger rate;

@property (strong,nonatomic) IBOutlet CWStarRateView *starRateView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) id<TeachingEvaluationTableViewCellDelegate> delegate;
@end
