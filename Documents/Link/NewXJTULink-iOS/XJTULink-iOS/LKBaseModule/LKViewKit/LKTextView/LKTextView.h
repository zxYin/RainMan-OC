//
//  LKTextView.h
//  LKInputToolBar
//
//  Created by Yunpeng Li on 2017/4/1.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface LKTextView : UITextView

@property (nonatomic, assign) NSUInteger maxNumberOfLines;
@property (nonatomic, copy) void(^textHeightChangeBlock)(LKTextView *textView,NSString *text,CGFloat textHeight);

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, copy) IBInspectable NSString *placeholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
@end
