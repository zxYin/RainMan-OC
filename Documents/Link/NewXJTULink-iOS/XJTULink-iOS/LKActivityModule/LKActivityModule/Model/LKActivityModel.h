//
//  ActivityModel.h
//  LKActivityModule
//
//  Created by Yunpeng on 16/9/7.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LKActivityModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *locale;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *url;


+ (NSDictionary *)JSONKeyPathsByPropertyKey;
@end
