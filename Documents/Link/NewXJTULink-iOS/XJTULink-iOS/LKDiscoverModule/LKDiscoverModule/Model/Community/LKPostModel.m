//
//  ConfessionModel.m
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/3/19.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKPostModel.h"
#import "MTLValueTransformer+Community.h"

@implementation LKPostModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"postId":@"id",
             @"content":@"content",
             @"timestamp":@"timestamp",
             @"liked":@"is_like",
             @"likeCount":@"like_count",
             @"readCount":@"read_count",
             @"commentCount":@"comment_count",
             @"relation":@"relation",
             @"accepted":@"is_accepted",
             @"hot":@"is_hot",
             @"likeUserAvatars":@"like_users",
             @"referName":@"refer_student.name",
             @"referAcademy":@"refer_student.academy",
             @"referClass":@"refer_student.class",
             
             @"backgroundColor":@"style.bg_color",
             @"textColor":@"style.text_color",
             @"bottomColor":@"style.bottom_color",
             @"tag":@"tag",
             @"user":@"user",
             };
}

+ (NSValueTransformer *)relationJSONTransformer {
    return [MTLValueTransformer transformerOfConfessionReleation];
}

- (void)updateFromModel:(LKPostModel *)model {
    self.content = model.content;
    self.timestamp = model.timestamp;
    self.liked = model.liked;
    self.likeCount = model.likeCount;
    self.readCount = model.readCount;
    self.commentCount = model.commentCount;
    self.relation = model.relation;
    self.accepted = model.accepted;
    self.hot = model.hot;
    self.likeUserAvatars = model.likeUserAvatars;
    self.tag = model.tag;
    self.referName = model.referName;
    self.referClass = model.referClass;
    self.referAcademy = model.referAcademy;
}

- (NSArray<NSString *> *)likeUserAvatars {
    if (_likeUserAvatars == nil) {
        _likeUserAvatars = [NSArray array];
    }
    return _likeUserAvatars;
}

@end
