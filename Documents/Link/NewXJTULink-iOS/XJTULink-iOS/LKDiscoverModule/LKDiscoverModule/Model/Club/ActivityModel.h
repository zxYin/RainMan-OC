//
//  ActivityModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/8.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ActivityModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSURL *imageURL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *honor;
@end
