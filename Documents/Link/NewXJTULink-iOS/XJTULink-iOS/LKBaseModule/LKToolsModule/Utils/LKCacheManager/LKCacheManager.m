//
//  LKCacheManager.m
//  LKBaseModule
//
//  Created by Yunpeng on 2016/12/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LKCacheManager.h"
#import "Macros.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "User+Auth.h"
#import "User+Persistence.h"
@implementation LKCacheManager

+ (void)clearAllWithCompletion:(void (^)())completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [[SDImageCache sharedImageCache] cleanDisk];
        [LKCacheManager clearFilesWithPath:AppCachePath];
        [LKCacheManager clearFilesWithPath:AppDocumentPath];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

+ (void)clearCacheWithCompletion:(void (^)())completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [LKCacheManager clearFilesWithPath:AppCachePath];
        [LKCacheManager clearFilesWithPath:AppDocumentPath
                                    filter:[LKCacheManager filterSet]];
        
        [[SDImageCache sharedImageCache] cleanDisk];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}


+ (void)calculateCacheSizeWithCompletion:(void (^)(CGFloat size))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CGFloat result = [LKCacheManager fileSizeAtPath:AppCachePath];
        
        result += [LKCacheManager fileSizeAtPath:AppDocumentPath
                                          filter:[LKCacheManager filterSet]];
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(result);
            });
        }
    });
}

+ (void)clearFilesWithPath:(NSString *)path {
    [self clearFilesWithPath:path filter:nil];
}

+ (void)clearFilesWithPath:(NSString *)path filter:(NSSet *)filter {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSLog(@"发现:%@",fileName);
            if (filter == nil || ![filter containsObject:fileName]) {
                NSLog(@"清理:%@",fileName);
                [fileManager removeItemAtPath:[path stringByAppendingPathComponent:fileName]
                                        error:nil];
                
            }
        }
    }
}

+ (CGFloat)fileSizeAtPath:(NSString*)path {
    return [self fileSizeAtPath:path filter:nil];
}



+ (CGFloat)fileSizeAtPath:(NSString*)path filter:(NSSet *)filter {
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:path error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    while (fileName = [filesEnumerator nextObject]) {
        NSLog(@"发现:%@",fileName);
        if (filter == nil || ![filter containsObject:fileName]) {
            NSLog(@"计算:%@",fileName);
            NSDictionary *fileDictionary =
            [[NSFileManager defaultManager] fileAttributesAtPath:
             [path stringByAppendingPathComponent:fileName] traverseLink:YES];
            fileSize += [fileDictionary fileSize];
        }
    }
    return fileSize;
}


+ (NSSet *)filterSet {
    return [NSSet setWithObjects:kUserCacheFileName,[User sharedInstance].cachePath, nil];
}

@end
