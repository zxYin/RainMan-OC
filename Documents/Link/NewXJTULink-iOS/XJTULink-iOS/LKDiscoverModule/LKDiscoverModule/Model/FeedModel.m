//
//  FeedModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "FeedModel.h"
@implementation FeedModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"searchText":@"search_text",
             @"headlineModels":@"headlines",
             @"specialColumnModel":@"special",
             @"hottestClubModel":@"hottest",
             @"communityContexts":@"community_list"
             };
}

+ (NSValueTransformer *)headlineModelsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[HeadlineModel class]];
}

+ (NSValueTransformer *)communityContextsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[CommunityContext class]];
}


@end
