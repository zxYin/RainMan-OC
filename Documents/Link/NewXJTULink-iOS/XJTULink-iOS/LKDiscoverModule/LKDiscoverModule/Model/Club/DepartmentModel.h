//
//  DepartmentModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface DepartmentModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSURL *imageURL;
@end
