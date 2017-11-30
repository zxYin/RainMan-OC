//
//  FavoritesModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 15/10/28.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "FavoritesModel.h"
#import <objc/runtime.h>
static FavoritesModel *instance;
@interface FavoritesModel ()
@property (strong,nonatomic) NSMutableDictionary *favHub;
@end
@implementation FavoritesModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _favHub = [[NSMutableDictionary alloc]init];
        [self loadFavoritesModel];
    }
    return self;
}

+ (FavoritesModel *)shareInstance {
    if (instance == nil) {
        instance = [[FavoritesModel alloc]init];
    }
    return instance;
}

+(BOOL)fav:(id<Favoritable>)object {
    FavoritesModel *model = [FavoritesModel shareInstance];
    NSLog(@"fav 1 ----------------:%@",object);
    if (object==nil) {
        return NO;
    }
    NSString *className = NSStringFromClass([object class]);
    NSLog(@"fav 2 ----------------:%@",className);
    if ([[model.favHub allKeys] containsObject:className]) {
        NSMutableArray *list = [model.favHub objectForKey:className];
        [list addObject:object];
        NSLog(@"旧List,收藏：%@",object);
    } else {
        NSMutableArray *list = [NSMutableArray arrayWithObject:object];
        [model.favHub setObject:list forKey:className];
        NSLog(@"新List,收藏：%@",object);
    }
    [instance saveFavoritesModel];
    
    return YES;
}

+(BOOL) unFav:(id<Favoritable>)object {
    FavoritesModel *model = [FavoritesModel shareInstance];
    if (object==nil) {
        return NO;
    }
    NSString *className = NSStringFromClass([object class]);
    if ([[model.favHub allKeys] containsObject:className]) {
        NSMutableArray *list = [model.favHub objectForKey:className];
        if ([list containsObject:object]) {
            NSLog(@"取消收藏：%@",object);
            [list removeObject:object];
            [instance saveFavoritesModel];
        }
    }
    return YES;
}
+ (BOOL) containsObject:(id<Favoritable>)object {
    FavoritesModel *model = [FavoritesModel shareInstance];
    if (object==nil) {
        return NO;
    }
    NSString *className = NSStringFromClass(object.class);
    if ([[model.favHub allKeys] containsObject:className]) {
        NSMutableArray *list = [model.favHub objectForKey:className];
        return [list containsObject:object];
    }
    return NO;

}

+ (NSArray *) favListBy:(Class)cls {
    FavoritesModel *model = [FavoritesModel shareInstance];
    NSString *className = NSStringFromClass(cls);
    NSLog(@"[model.favHub allKeys]:%@",[model.favHub allKeys]);
    if ([[model.favHub allKeys] containsObject:className]) {
        return [[model.favHub objectForKey:className] copy];
    }
    return nil;
}

+ (void)save {
    [instance saveFavoritesModel];
}

- (void)saveFavoritesModel {
    if (_favHub != nil) {
        BOOL success = [NSKeyedArchiver archiveRootObject:_favHub toFile:[self filePathOfFavoritesModel]];
        if (success) {
            NSLog(@"saveFavoritesModel 保存成功");
        } else {
            NSLog(@"saveFavoritesModel 保存失败");
        }
    }
}

- (void)loadFavoritesModel {
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:[self filePathOfFavoritesModel]]) {
        NSMutableDictionary *favHub = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePathOfFavoritesModel]];
        if (favHub!= nil) {
            _favHub = favHub;
        }
    }
}

- (NSString *)filePathOfFavoritesModel
{
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"FavoritesModel.plist"];
}
@end
