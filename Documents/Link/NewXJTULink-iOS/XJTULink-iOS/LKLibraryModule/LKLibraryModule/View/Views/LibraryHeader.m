//
//  LibraryHeader.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/5/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "LibraryHeader.h"

@implementation LibraryHeader

+ (LibraryHeader *)libraryHeader {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"LibraryHeader" owner:self options:nil];
    UIView *view = nibViews.lastObject;
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, -LibraryHeaderHeight, [UIScreen mainScreen].bounds.size.width, LibraryHeaderHeight);
    return (LibraryHeader *)view;
}

@end
