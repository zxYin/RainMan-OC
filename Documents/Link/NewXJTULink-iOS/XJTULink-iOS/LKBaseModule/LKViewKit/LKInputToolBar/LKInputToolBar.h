//
//  LKInputToolBar.h
//  LKInputToolBar
//
//  Created by Yunpeng Li on 2017/4/1.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKTextView.h"
#import "LKTextView+Draft.h"
@class LKInputToolBar;
@protocol LKInputToolBarDelegate<NSObject>
@optional
- (void)inputToolBar:(LKInputToolBar *)inputToolBar textWillBeginEditing:(NSString *)text;
- (void)inputToolBar:(LKInputToolBar *)inputToolBar textDidBeginEditing:(NSString *)text;
- (void)inputToolBar:(LKInputToolBar *)inputToolBar textDidChange:(NSString *)text;
- (void)inputToolBar:(LKInputToolBar *)inputToolBar textDidEndEditing:(NSString *)text;
- (void)inputToolBar:(LKInputToolBar *)inputToolBar returnButtonDidClickWithText:(NSString *)text;
@end

typedef void(^RightCheckButtonActionBlock)(id sender);
/**
 * 输入栏
 * 
 */
@interface LKInputToolBar : UIView
@property (weak, nonatomic) IBOutlet LKTextView *inputTextView;
@property (weak, nonatomic) IBOutlet UIButton *rightCheckButton;
@property (nonatomic, assign, getter=isResident) BOOL resident;
@property (nonatomic, copy) NSString *draftKey;
@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, copy) RightCheckButtonActionBlock rightCheckButtonActionBlock;

@property (nonatomic, weak) id<LKInputToolBarDelegate> delegate;
+ (instancetype)inputToolBar;
+ (instancetype)inputToolBarWithDraftKey:(NSString *)key;

- (CGRect)inputFieldRect;
- (CGFloat)heightOfToolBar;
- (void)removeCurrentDraft;
@end
