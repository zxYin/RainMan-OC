//
//  News.m
//  
//
//  Created by Yunpeng on 15/8/29.
//
//

#import "NewsModel.h"
//#import "NewsHelper.h"
@interface NewsModel()
@property (assign,nonatomic) BOOL isReaded;
@end
@implementation NewsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title":@"news_title",
             @"date":@"published_date",
             @"urlString":@"news_url",
             @"originURLString":@"news_origin_url",
             @"newsId":@"news_id",
             @"hasAccessory":@"has_accessory",
             };
}


+ (NSValueTransformer *)newsIdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

- (BOOL)isReaded {
    return _isReaded;
}

- (BOOL)isFaved {
    return [FavoritesModel containsObject:self];
}

- (void)setFav:(BOOL)isFav {
    if (isFav) {
        [FavoritesModel fav:self];
    } else {
        [FavoritesModel unFav:self];
    }
}
@end
