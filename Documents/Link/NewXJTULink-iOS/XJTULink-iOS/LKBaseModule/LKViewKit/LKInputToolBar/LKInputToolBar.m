//
//  LKInputToolBar.m
//  LKInputToolBar
//
//  Created by Yunpeng Li on 2017/4/1.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "LKInputToolBar.h"
#import "LKTextView+Draft.h"
#import "UIView+YLAutoLayoutHider.h"
@interface LKInputToolBar()<UITextViewDelegate>
@property (strong, nonatomic) UIView *maskView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextViewHeightCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barBottomCons;

@end
@implementation LKInputToolBar

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if(!self.inputTextView.isFirstResponder
       && hitView == self) {
        return nil;
    }
    return hitView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.resident = YES;
    __weak __typeof(self) weakSelf = self;
    self.inputTextView.textHeightChangeBlock = ^(LKTextView *textView,NSString *text,CGFloat textHeight){
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.inputTextViewHeightCons.constant = textHeight;
        [self updateConstraintsIfNeeded];
    };
    
    self.inputTextView.maxNumberOfLines = 2;
    self.inputTextView.returnKeyType = UIReturnKeySend;
    self.inputTextView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundDidClick:)];
    [self addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    [self addGestureRecognizer:pan];
    [self.rightCheckButton setImage:[UIImage imageNamed:@"wall_checked"] forState:UIControlStateSelected];
    [self.rightCheckButton setImage:[UIImage imageNamed:@"wall_uncheck"] forState:UIControlStateNormal];
    [self.rightCheckButton yl_setHidden:YES forType:YLHiddenTypeVertical mode:YLPositionModeTotal];

}

- (CGFloat)heightOfToolBar {
    return self.inputTextViewHeightCons.constant + 20;
}
- (CGRect)inputFieldRect {
    return self.inputTextView.superview.frame;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputToolBar:textWillBeginEditing:)]) {
        [self.delegate inputToolBar:self textWillBeginEditing:textView.text];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputToolBar:textDidBeginEditing:)]) {
        [self.delegate inputToolBar:self textDidBeginEditing:textView.text];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputToolBar:textDidEndEditing:)]) {
        [self.delegate inputToolBar:self textDidEndEditing:textView.text];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(inputToolBar:returnButtonDidClickWithText:)]) {
            [self.delegate inputToolBar:self returnButtonDidClickWithText:textView.text];
        }
        [textView resignFirstResponder];
        [LKTextView removeDraftForKey:self.draftKey];
        return NO;
    }
    
    if (textView.text.length > self.maxLength) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputToolBar:textDidChange:)]) {
        [self.delegate inputToolBar:self textDidChange:textView.text];
    }
    
    if (self.draftKey.length > 0) {
        if (textView.text.length > 0) {
            [LKTextView setDraft:textView.text forKey:self.draftKey];
        } else {
            [LKTextView removeDraftForKey:self.draftKey];
        }
    }
}
- (IBAction)clickSecretWordsCheckButton:(id)sender {
    if (self.rightCheckButtonActionBlock) {
        self.rightCheckButtonActionBlock(sender);
    }
}

- (void)backgroundDidClick:(id)sender {
    [self endEditing:YES];
}

- (void)handlePanGesture:(id)sender {
    [self endEditing:YES];
}

#pragma mark - Override
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [self.inputTextView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.inputTextView resignFirstResponder];
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *)note {

}

- (void)keyboardWillHide:(NSNotification *)note {
    
}

- (void)keyboardDidHide:(NSNotification *)note {

}

- (void)keyboardWillChangeFrame:(NSNotification *)note {
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"[keyboardWillChangeFrame]%@", NSStringFromCGRect(endFrame));
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGRect frame = self.frame;
    if (self.isResident) {
        frame.origin.y = (endFrame.origin.y != screenH ? -endFrame.size.height : 0);
    } else {
        frame.origin.y = (endFrame.origin.y != screenH ? -(endFrame.size.height + [self heightOfToolBar]):[self heightOfToolBar]);
    }
    self.frame = frame;
}
     
- (void)applicationDidEnterBackground:(NSNotification *)note {
    [self.inputTextView resignFirstResponder];
}

- (void)setDraftKey:(NSString *)draftKey {
    if (![self.draftKey isEqualToString:draftKey]) {
        _draftKey = draftKey;
        self.inputTextView.text = [LKTextView draftForKey:draftKey];
    }
}

- (void)setResident:(BOOL)resident {
    if (_resident != resident) {
        _resident = resident;
        CGRect newFrame = self.frame;
        if (resident) {
            newFrame.size.height -= [self heightOfToolBar];
        } else {
            newFrame.size.height += [self heightOfToolBar];
        }
        self.frame = newFrame;
    }
}

- (void)removeCurrentDraft {
    [LKTextView removeDraftForKey:self.draftKey];
    self.inputTextView.text = @"";
}

#pragma mark - Private API

#pragma mark - Class Method

+ (instancetype)inputToolBar {
    return [self inputToolBarWithDraftKey:nil];
}

+ (instancetype)inputToolBarWithDraftKey:(NSString *)key {
    LKInputToolBar *bar = [[[NSBundle mainBundle] loadNibNamed:@"LKInputToolBar" owner:nil options:nil] firstObject];
    bar.draftKey = key;
    return bar;
}


#pragma mark - Getter

- (NSUInteger)maxLength {
    if (_maxLength == 0) {
        return NSUIntegerMax;
    }
    return _maxLength;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
