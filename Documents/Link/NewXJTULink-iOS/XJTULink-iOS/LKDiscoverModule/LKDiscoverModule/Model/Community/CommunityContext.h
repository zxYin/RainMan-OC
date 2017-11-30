//
//  ConfessionContext.h
//  LKDiscoverModule
//
//  Created by Yunpeng on 2017/4/10.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@import UIKit.UIColor;


@interface ConfessionEditorContext : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
@end

@interface CommunityOption : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *optionId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL allowPost;
@property (nonatomic, assign) BOOL allowRefer;
@property (nonatomic, strong) ConfessionEditorContext *editorContext;
@end

@interface CommunityContext : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *communityId;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, weak) CommunityOption *currentOption;
@property (nonatomic, copy) NSArray<CommunityOption *> *options;

+ (instancetype)currentContext;
+ (void)setupCurrentContext:(CommunityContext *)context;
@end
