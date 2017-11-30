//
//  TodayViewController.m
//  XJTULink-Widget
//
//  Created by Yunpeng on 15/11/11.
//  Copyright © 2015年 Yunpeng. All rights reserved.
//

#import "TodayViewController.h"
#import "CourseWidgetCell.h"
#import "NSString+Date.h"
#import "UIImage+Tint.h"
#import <NotificationCenter/NotificationCenter.h>
static NSString * const XJTULinkSharedDefaults = @"group.XJTULinkSharedDefaults";
static NSInteger const HeaderHeight = 100;

static NSString * const kClassroomURL = @"xjtulink://classroom/#mine";
static NSString * const kCourseTableURL = @"xjtulink://#course";
static NSString * const kTransferURL = @"xjtulink://card/transfer/";
static NSString * const kLibraryURL = @"xjtulink://library/#mine";

#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface TodayViewController () <NCWidgetProviding> {
    NSArray *_todayCourses;
    NSURLSessionDataTask *_dataTask;
}
@property (copy,nonatomic) NSArray<NSArray *> *courseTable;
@property (assign, nonatomic) NSInteger currentWeek;
@property (strong, nonatomic) NSURLSession *session;


@property (weak, nonatomic) IBOutlet UILabel *currentWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIButton *transferButton;
@property (weak, nonatomic) IBOutlet UILabel *transferLabel;
@property (weak, nonatomic) IBOutlet UIButton *classroomButton;
@property (weak, nonatomic) IBOutlet UILabel *classroomLabel;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet UILabel *libraryLabel;


@end

@implementation TodayViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setupData];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
    
    UINib *nib = [UINib nibWithNibName:@"CourseWidgetCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CourseWidgetCellIdentifier];
    
    if(SystemVersion >= 10) {
        UIColor *defaultColor = [UIColor blackColor];
        self.currentWeekLabel.textColor = defaultColor;
        self.weekdayLabel.textColor = defaultColor;
        self.lineView.backgroundColor = defaultColor;
        UIImage *transferImage = [UIImage imageNamed:@"widget_transfer"];
        [self.transferButton setImage:[transferImage imageWithTintColor:defaultColor] forState:UIControlStateNormal];
        self.transferLabel.textColor = [UIColor blackColor];
        
        UIImage *classroomImage = [UIImage imageNamed:@"widget_classroom"];
        [self.classroomButton setImage:[classroomImage imageWithTintColor:defaultColor] forState:UIControlStateNormal];
        self.classroomLabel.textColor = [UIColor blackColor];
        
        UIImage *libraryImage = [UIImage imageNamed:@"widget_library"];
        [self.libraryButton setImage:[libraryImage imageWithTintColor:defaultColor] forState:UIControlStateNormal];
        self.libraryLabel.textColor = [UIColor blackColor];
    }
    
    
    if(SystemVersion >= 10) {
        self.preferredContentSize = CGSizeMake(self.view.frame.size.width, HeaderHeight);
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
    
    self.lineView.hidden = YES;
}

- (void)setupWeekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    
    long weekday = [dateComponent weekday];
    if (weekday==1) {
        weekday = 6;
    } else {
        weekday = weekday - 2;
    }
    self.weekdayLabel.text = [NSString weekdayStringFrom:weekday];
}

- (NSArray *)fetchTodayCoursesFormTable {
    NSMutableArray *courses = [NSMutableArray array];
    [_courseTable[[self weekday]] enumerateObjectsUsingBlock:^(NSDictionary *course, NSUInteger idx, BOOL* stop) {
        if ([course[@"week_set"] containsObject:@(_currentWeek)]) {
            [courses addObject:course];
        }
    }];
    NSLog(@"Course Table:%@",courses);
    return [courses copy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 这里一定要调重置数据，因为不是每次都会调用ViewDidLoad
    [self setupData];

    [self.tableView reloadData];
    
}


- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
                         withMaximumSize:(CGSize)maxSize {
    switch (activeDisplayMode) {
        case NCWidgetDisplayModeExpanded: {
            if (_todayCourses.count != 0) {
                self.lineView.hidden = NO;
                self.preferredContentSize = CGSizeMake(0,HeaderHeight+_todayCourses.count*CourseWidgetCellHeight);
            } else {
                self.lineView.hidden = YES;
            }
            break;
        }
        case NCWidgetDisplayModeCompact: {
            self.lineView.hidden = YES;
            self.preferredContentSize = CGSizeMake(0, HeaderHeight);
            break;
        }
    }
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    NSURL *url = [NSURL URLWithString:@"https://link.xjtu.edu.cn/api/1.0/campusInfo/getCurrentWeek/"];
//    let request = NSMutableURLRequest all
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [_dataTask cancel];
    __weak __typeof(self) weakSelf = self;
    _dataTask = [self.session dataTaskWithRequest:request
                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                __strong __typeof(weakSelf) strongSelf = weakSelf;
                                if (error != nil) {
                                    completionHandler(NCUpdateResultNoData);
                                    return;
                                }
                                
                                NSError *nerror = nil;
                                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                                                       options:NSJSONReadingMutableLeaves
                                                                                         error:&nerror];
                                if (nerror != nil) {
                                    completionHandler(NCUpdateResultNoData);
                                    return;
                                }
                                
                                if([result isKindOfClass:[NSDictionary class]]) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        strongSelf.currentWeek = [result[@"data"][@"current_week"] integerValue];
                                        NSUserDefaults *sharedUserDafaults = [[NSUserDefaults alloc] initWithSuiteName:XJTULinkSharedDefaults];
                                        [sharedUserDafaults setInteger:strongSelf.currentWeek forKey:@"current_week"];
                                        [sharedUserDafaults synchronize];
                                        strongSelf.currentWeekLabel.text = [NSString stringWithFormat:@"第%@周",[NSString weekStringFrom:_currentWeek]];
                                    });
                                    
                                    
                                }
                                completionHandler(NCUpdateResultNewData);
                            }];

    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
    [_dataTask resume];
}


- (void)setupData {
    NSUserDefaults *sharedUserDafaults = [[NSUserDefaults alloc] initWithSuiteName:XJTULinkSharedDefaults];
    _courseTable = [sharedUserDafaults objectForKey:@"course_table"];
    _currentWeek = [sharedUserDafaults integerForKey:@"current_week"];
    _todayCourses = [self fetchTodayCoursesFormTable];

    self.currentWeekLabel.text = [NSString stringWithFormat:@"第%@周",[NSString weekStringFrom:_currentWeek]];
    [self setupWeekday];
}

- (long)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    
    long weekday = [dateComponent weekday];
    if (weekday==1) {
        weekday = 6;
    } else {
        weekday = weekday - 2;
    }
    return weekday;
}


- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 35, 0, 10);
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseWidgetCell *cell = [tableView dequeueReusableCellWithIdentifier:CourseWidgetCellIdentifier forIndexPath:indexPath];
    NSDictionary *course = _todayCourses[indexPath.row];
    cell.nameLabel.text = course[@"name"];
    cell.timeLabel.text = course[@"time"];
    cell.localeLabel.text = course[@"locale"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self openLinkAt:kCourseTableURL];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_todayCourses count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CourseWidgetCellHeight;
}


- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return _session;
}

- (IBAction)tranferButtonDidClick:(UIButton *)sender {
    [self openLinkAt:kTransferURL];
}
- (IBAction)classrootButtonDidClick:(UIButton *)sender {
    [self openLinkAt:kClassroomURL];
}
- (IBAction)libraryButtonDidClick:(UIButton *)sender {
    [self openLinkAt:kLibraryURL];
}

- (void)openLinkAt:(NSString *)func {
    [self.extensionContext openURL:[NSURL URLWithString:func] completionHandler:^(BOOL success) {
        NSLog(@"调用西交Link");
    }];
}

@end
