//
//  LKAvatarsView.h
//  LKDiscoverModule
//
//  Created by 湛杨梦晓 on 2017/4/15.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKAvatarsView : UIView

@property (nonatomic, strong) NSArray<NSURL *> *avatarURLs;
@property (nonatomic, assign) NSInteger maxNumOfAvatars;
@property (nonatomic, assign) NSInteger avatarWidth;
- (void)configureSubview;
- (void)insertAvatarURL:(NSString *)url;
- (void)removeAvatarURL:(NSString *)url;
@end
