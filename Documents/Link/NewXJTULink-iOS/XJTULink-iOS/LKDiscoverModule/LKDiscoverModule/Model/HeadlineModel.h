//
//  HeadlineModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/31.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

typedef NS_ENUM(NSInteger,HeadlineType) {
    kHeadlineTypeArticle,
    kHeadlineTypeWeb,
    kHeadlineTypeClub,
};

@interface HeadlineModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) HeadlineType type;
@property (nonatomic, copy) NSString *clubId;
@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSURL *imageURL;
@end
