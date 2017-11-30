//
//  SingleURLModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface SingleURLModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSString *title;

+ (SingleURLModel *)singleURLModelWithURL:(NSURL *)url title:(NSString *)title;
@end
