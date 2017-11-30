//
//  ToolsItemViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/10/9.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsItemViewModel : NSObject
@property (nonatomic, assign, getter=isLoaded) BOOL loaded;
@property (nonatomic, strong) RACCommand *rac_setNeedUpdateCommand;

@property (nonatomic, copy) NSString *flow;
@property (nonatomic, copy) NSString *balance;

@end
