//
//  LKAvatarsView.m
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/4/15.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import "LKAvatarsView.h"
#import "BlocksKit.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewsConfig.h"
#import "UIView+YLAutoLayoutHider.h"
@interface LKAvatarsView ()

@property (nonatomic, strong) UIView *preView;
@property (nonatomic, strong) NSMutableArray<UIImageView *> *avatarImageViews;
@end

@implementation LKAvatarsView
@synthesize avatarURLs = _avatarURLs;
- (instancetype)init {
    self = [super init];
    if (self) {
        self.maxNumOfAvatars = 3;
        self.avatarWidth = 24;
        
        [self initConfigureSubview];
    }
    return self;
}

- (void)initConfigureSubview {
    self.avatarImageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<self.maxNumOfAvatars; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        @weakify(self);
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self).with.offset(i*self.avatarWidth*0.6);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@(self.avatarWidth));
            make.width.equalTo(@(self.avatarWidth));
            
        }];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = self.avatarWidth/2.0;
        [imageView yl_setHidden:YES forType:YLHiddenTypeHorizontal];
        [self.avatarImageViews addObject:imageView];
    }
}

- (void)configureSubview {
    for (NSInteger i = 0; i<self.maxNumOfAvatars; i++) {
        if (i<[self.avatarURLs count]) {
            [self.avatarImageViews[i] yl_setHidden:NO forType:YLHiddenTypeHorizontal];
            [self.avatarImageViews[i] sd_setImageWithURL:self.avatarURLs[i] placeholderImage:[UIImage imageNamed:@"image_avatar_default"]];
            if (i == ([self.avatarURLs count] - 1)) {
                @weakify(self);
                [self.avatarImageViews[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                    @strongify(self);
                    make.right.equalTo(self);
                }];
            }else {
                @weakify(self);
                [self.avatarImageViews[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    @strongify(self);
                    make.left.equalTo(self).with.offset(i*self.avatarWidth*0.6);
                    make.centerY.equalTo(self.mas_centerY);
                    make.height.equalTo(@(self.avatarWidth));
                    make.width.equalTo(@(self.avatarWidth));
                }];
                
            }
        }else {
            [self.avatarImageViews[i] yl_setHidden:YES forType:YLHiddenTypeHorizontal];
        }
    }
}

- (void)insertAvatarURL:(NSURL *)url {
    if ([self.avatarURLs count] < self.maxNumOfAvatars) {
        NSMutableArray *tempArr = [self.avatarURLs mutableCopy];
        [tempArr addObject:url];
        self.avatarURLs = [tempArr copy];
    }
    
}
- (void)removeAvatarURL:(NSURL *)url {
    if ([self.avatarURLs containsObject:url]) {
        NSMutableArray *tempArr = [self.avatarURLs mutableCopy];
        [tempArr removeObject:url];
        self.avatarURLs = [tempArr copy];
    }
}

- (NSArray *)avatarURLs {
    if (_avatarURLs == nil) {
        _avatarURLs = [[NSArray alloc] init];
    }
    return _avatarURLs;
}


- (void)setAvatarURLs:(NSArray *)avatarURLs {
    if ([avatarURLs count] > self.maxNumOfAvatars) {
        avatarURLs = [avatarURLs objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.maxNumOfAvatars)]];
    }
    _avatarURLs = avatarURLs;
    [self configureSubview];
}

@end
