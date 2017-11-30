//
//  ToolsViewCell.h
//  
//
//  Created by Yunpeng on 15/8/26.
//
//

#import <UIKit/UIKit.h>
#import "ToolsItemViewModel.h"
#import <LKBaseModule/YLTableView.h>
extern NSString *const ToolsViewCellIdentifier;
#define ToolsViewCellHeight 57

@class ToolsViewCell;
@protocol ToolsViewDelegate <NSObject>
- (void)leftButtonDidClick:(ToolsViewCell *)cell;
- (void)rightButtonDidClick:(ToolsViewCell *)cell;
@end

typedef void (^RightButtonEvent)();

@interface ToolsViewCell : UITableViewCell<YLTableViewCellProtocol>
@property (assign,nonatomic) BOOL enable;
@property (nonatomic, strong) ToolsItemViewModel *viewModel;

@property (nonatomic, copy) void (^rightButtonEvent)(ToolsViewCell *cell);
@property (nonatomic, copy) void (^leftButtonEvent)(ToolsViewCell *cell);

@property (weak, nonatomic) IBOutlet UILabel *flowLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak,nonatomic) id<ToolsViewDelegate> delegate;
@end
