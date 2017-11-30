//
//  LKSearchBar.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/7/26.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
@class LKSearchBar;


typedef NS_ENUM(NSInteger, LKSearchBarStyle) {
    kLKSearchBarStyleDefault, // white
    kLKSearchBarStyleGray,
    kLKSearchBarStyleBlack,
};

@protocol LKSearchBarDelegate <NSObject>

@optional
- (BOOL)searchBarShouldBeginEditing:(LKSearchBar *)searchBar;
- (BOOL)searchBarShouldEndEditing:(LKSearchBar *)searchBar;
- (void)searchBarDidEndEditing:(LKSearchBar *)searchBar;

- (void)searchBarSearchButtonClicked:(LKSearchBar *)searchBar;
- (void)searchBarCancelButtonClicked:(LKSearchBar *)searchBar;
@end

@interface LKSearchBar : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, assign) LKSearchBarStyle style;

@property (nonatomic) UIEdgeInsets edgeInsets;

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) id<LKSearchBarDelegate> delegate;
@end
