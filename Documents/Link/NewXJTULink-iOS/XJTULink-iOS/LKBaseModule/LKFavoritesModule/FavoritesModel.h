//
//  FavoritesModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/28.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@protocol Favoritable <NSObject>
@required
- (BOOL)isFaved;
- (void)setFav:(BOOL)isFav;
@end

@interface FavoritesModel : MTLModel
+ (BOOL) fav:(id<Favoritable>)object;
+ (BOOL) unFav:(id<Favoritable>)object;
+ (BOOL) containsObject:(id<Favoritable>)object;
+ (NSArray *) favListBy:(Class)cls;

+ (FavoritesModel *)shareInstance;
+ (void)save;
@end
