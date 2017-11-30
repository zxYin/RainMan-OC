//
//  TodayViewController.h
//  XJTULink-Widget
//
//  Created by Yunpeng on 15/11/11.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
