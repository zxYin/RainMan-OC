//
//  Foundation+LKNewsExtension.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/9/4.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsItemViewModel.h"
@interface NSDictionary (LKNewsExtension)
- (NewsItemViewModel *)newsItemViewModelForKey:(NSString *)key;
- (NewsModel *)newsModelForKey:(NSString *)key;
@end
