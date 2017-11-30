//
//  UITableView+YLExpandable.h
//  UITableView+YLExpandable
//
//  Created by Yunpeng on 2016/11/20.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol YLExpandableDataSource <NSObject>
@required
- (UITableViewCell *)yl_tableView:(UITableView *)tableView expandCellForHostIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)yl_tableView:(UITableView *)tableView heightOfExpandCellForHostIndexPath:(NSIndexPath *)indexPath;
@end

@protocol YLExpandableDeleagte <NSObject>
@optional
- (void)yl_tableView:(UITableView *)tableView didExpandForHostIndexPath:(NSIndexPath *)indexPath;
- (void)yl_tableView:(UITableView *)tableView didUnexpandForHostIndexPath:(NSIndexPath *)indexPath;
@end


@interface UITableViewCell (YLExpandable)
@property (nonatomic, assign, setter=yl_setExpandable:) BOOL yl_expandable;
@end


@interface UITableView (YLExpandable)
@property (nonatomic, assign, setter=yl_setExpandable:) BOOL yl_expandable;
@property (nonatomic, assign, setter=yl_setExpandableDataSource:) id<YLExpandableDataSource> yl_expandableDataSource;
@property (nonatomic, assign, setter=yl_setExpandableDelegate:) id<YLExpandableDeleagte> yl_expandableDelegate;
@end
