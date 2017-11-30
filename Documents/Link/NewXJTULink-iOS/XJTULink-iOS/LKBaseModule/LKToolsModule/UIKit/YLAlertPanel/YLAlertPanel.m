//
//  YLAlertPanel.m
//  YLAlertPanel
//
//  Created by Yunpeng on 2016/12/1.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "YLAlertPanel.h"
@interface YLAlertPanel()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<YLAlertPanelLine *> *lines;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UILabel *headerView;
@property (strong, nonatomic) UIButton *footerView;
@end

@implementation YLAlertPanel
- (instancetype)init {
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
//    CGRect frame = self.view.frame;
//    frame.origin.x = statusBarHeight;
//    frame.size.height = [UIScreen mainScreen].bounds.size.height - statusBarHeight;
//    self.view.frame = frame;
    
//    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.view.backgroundColor = // [UIColor clearColor];
    [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:self.tableView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidClick:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"Touch View:%@",touch.view);
    if ([touch.view isDescendantOfView:self.tableView]) {
        return NO;
    }
    return YES;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
//    CGFloat offset = []
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGRect frame = CGRectZero;
    frame.size.width = screenSize.width;
    frame.size.height = self.headerView.frame.size.height + YLAlertPanelLineHeight * self.lines.count + self.footerView.frame.size.height;
    frame.origin.x = 0;
    frame.origin.y = screenSize.height - frame.size.height;
    self.tableView.frame = frame;
    
}

- (void)dismiss {
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)())completion {
    if (completion) {
        self.completion = completion;
    }
    
    CGRect frame = self.tableView.frame;
    NSLog(@"ORIGIN:%@",NSStringFromCGRect(frame));
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"FRAME: %@",NSStringFromCGRect(frame));
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:15.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //        self.view.alpha = 1;
        NSLog(@"ORIGIN 2:%@",NSStringFromCGRect(self.tableView.frame));
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        self.window = nil;
        if (self.completion) {
            self.completion();
        }
    }];

}

- (void)backgroundViewDidClick:(UITapGestureRecognizer*)tap {
    CGRect frame = self.tableView.frame;
    NSLog(@"ORIGIN:%@",NSStringFromCGRect(frame));
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"FRAME: %@",NSStringFromCGRect(frame));
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:15.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //        self.view.alpha = 1;
        NSLog(@"ORIGIN 2:%@",NSStringFromCGRect(self.tableView.frame));
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        self.window = nil;
    }];
    
}


- (NSInteger)addButtonWithTitle:(NSString *)title atLine:(NSInteger)line handler:(void (^)(YLAlertPanelButton *button))handler {
//    YLAlertPanelButton *button = [YLAlertPanelButton buttonWithTitle:title image:image handler:handler];
    return 0;
}

- (NSInteger)addLine:(YLAlertPanelLine *)line {
    [self.lines addObject:line];
    return self.lines.count;
}

- (void)show {
    [self setupNewWindow];
    
    CGRect originFrame = self.tableView.frame;
    CGRect frame = self.tableView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.tableView.frame = frame;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:15.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.frame = originFrame;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)setupNewWindow {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.windowLevel = UIWindowLevelAlert;
    window.backgroundColor = [UIColor clearColor];
    window.rootViewController = self;
    window.opaque = NO;
    self.window = window;
    
    [window makeKeyAndVisible];
}


#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.lines[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return YLAlertPanelLineHeight;
}


#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.95];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}

- (NSMutableArray<YLAlertPanelLine *> *)lines {
    if (_lines == nil) {
        _lines = [[NSMutableArray alloc] init];
    }
    return _lines;
}


- (UILabel *)headerView {
    if (_headerView == nil) {
        _headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 30)];
        _headerView.font = [UIFont systemFontOfSize:14];
        _headerView.textColor = [UIColor grayColor];
        _headerView.textAlignment = NSTextAlignmentCenter;
        _headerView.text = self.title;
    }
    return _headerView;
}

- (UIButton *)footerView {
    if (_footerView == nil) {
        _footerView = [UIButton buttonWithType:UIButtonTypeSystem];
        _footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
        _footerView.backgroundColor = [UIColor whiteColor];
        _footerView.titleLabel.font = [UIFont systemFontOfSize:17];
        [_footerView setTitle:@"取消" forState:UIControlStateNormal];
        [_footerView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_footerView addTarget:self action:@selector(backgroundViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}


- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.headerView.text = title;
}



+ (YLAlertPanel *)currentPanel {
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = currentWindow.rootViewController;
    if ([vc isKindOfClass:[YLAlertPanel class]]) {
        return vc;
    } else {
        return nil;
    }
}
@end
