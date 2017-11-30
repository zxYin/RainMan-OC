//
//  ReferEditViewController.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/4.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ReferEditItem) {
    kReferEditItemName = 0,
    kReferEditItemAcademy,
    kReferEditItemClass,
};

typedef void (^ReferEditFinish)(BOOL finish, NSString *referName, NSString *referAcademy, NSString *referClass);

typedef void (^LKAnimation)(BOOL finish);

@interface ReferEditViewController : UIViewController
@property (nonatomic, copy) NSString *referName;
@property (nonatomic, copy) NSString *referAcademy;
@property (nonatomic, copy) NSString *referClass;

@property (nonatomic, copy) ReferEditFinish finish;
@end
