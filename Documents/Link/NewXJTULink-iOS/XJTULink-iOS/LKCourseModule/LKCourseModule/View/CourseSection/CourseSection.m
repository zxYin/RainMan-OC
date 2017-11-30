//
//  CourseSection.m
//  LKCourseModule
//
//  Created by Yunpeng on 2016/10/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "CourseSection.h"
#import "CourseAdViewModel.h"
#import "CourseManager.h"
#import "CourseViewModel.h"
#import "NSDate+LKTools.h"
#import <BlocksKit/BlocksKit.h>
#import "WeekManager.h"
#import "CourseListItemCell.h"
#import "Macros.h"

@interface CourseSection()
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) CourseAdViewModel *viewModel;
@property (nonatomic, strong) NSMutableSet *usedColorSet;
@property (nonatomic, strong) NSMutableDictionary *courseColorDict;
@end
@implementation CourseSection

#pragma mark - override

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    @weakify(self);
    
    if (self.viewModel.networkingRAC == nil) {
        NSLog(@"[CourseSection] did Load.");
        self.loaded = YES;
    } else {
        [[RACSignal merge:@[[self.viewModel.networkingRAC executionSignal],
                            [self.viewModel.networkingRAC requestErrorSignal]
                            ]] subscribeNext:^(id x) {
            @strongify(self);
            NSLog(@"[CourseSection] did Load.");
            self.loaded = YES;
        }];
    }

    CourseManager *manager = [CourseManager sharedInstance];
    [RACObserve(manager, courseTable)
     subscribeNext:^(NSArray<NSArray<CourseModel *> *> *courseTable) {
         @strongify(self);
         NSInteger weekday = [[NSDate date] weekdayAbsolute];
         NSMutableArray *courseViewModels = [NSMutableArray array];
         [courseTable[weekday] enumerateObjectsUsingBlock:^(CourseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([obj.weekFormatter.indexSet containsIndex:[WeekManager sharedInstance].week]) {
                 [courseViewModels addObject:[[CourseViewModel alloc]initWithModel:obj]];
             }
         }];
         
         
         
         if (courseViewModels.count == 0) {
             self.viewModels = @[self.viewModel];
         } else {
             self.viewModels = [courseViewModels copy];
         }
     }];
}

- (void)configCell:(UITableViewCell *)cell forRowIndex:(NSInteger)rowIndex {
    if ([cell isKindOfClass:[CourseListItemCell class]]) {
        CourseListItemCell *cCell = (CourseListItemCell *)cell;
         CourseViewModel *viewModel = self.viewModels[rowIndex];
        cCell.tintColor = [self tryFetchColorFromSetForKey:viewModel.model.uuid];
    }
    
}

- (NSString *)title {
    return @"课管阿姨";
}

+ (NSDictionary *)cellClassForViewModelClass {
    return @{
             @"CourseListItemCell":@"CourseViewModel",
             @"CourseAdCell":@"CourseAdViewModel",
             };
}

- (id)objectForSelectRowIndex:(NSInteger)rowIndex {
    return nil;
}

- (void)setNeedUpdate {
    if (self.viewModel.networkingRAC != nil) {
        self.loaded = NO;
    }
    [[self.viewModel.networkingRAC requestCommand] execute:nil];
}

- (UIColor *)tryFetchColorFromSetForKey:(NSString *)key {
    UIColor *selectedColor = self.courseColorDict[key];
    if (selectedColor != nil) {
        return selectedColor;
    }
    
    NSInteger begin = arc4random() % self.colors.count;
    
    for (NSInteger i=0; i<self.colors.count; i++) {
        // 每次从随机的一个位置开始读
        begin = (begin + 1) % self.colors.count;
        UIColor *color = self.colors[begin];
        if (![self.usedColorSet containsObject:color]) {
            selectedColor = color;
            break;
        }
    }
    
    if(selectedColor == nil) {
        [self.usedColorSet removeAllObjects];
        selectedColor = self.colors[arc4random() % self.colors.count];
    }
    [self.usedColorSet addObject:selectedColor];
    self.courseColorDict[key] = selectedColor;
    return selectedColor;
}

#pragma mark - getter
- (CourseAdViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[CourseAdViewModel alloc] init];
    }
    return _viewModel;
}

- (NSArray *)colors {
    if (_colors == nil) {
        _colors = @[UIColorFromRGB(0x63BA8E),
                    UIColorFromRGB(0x8FA6C7),
                    UIColorFromRGB(0xC78783),
                    UIColorFromRGB(0x8EB94B),
                    UIColorFromRGB(0xC2AF71),
                    UIColorFromRGB(0x4FBDEA),
                    UIColorFromRGB(0xFE8783),];
    }
    return _colors;
}

- (NSMutableSet *)usedColorSet {
    if (_usedColorSet == nil) {
        _usedColorSet = [[NSMutableSet alloc] init];
    }
    return _usedColorSet;
}

- (NSMutableDictionary *)courseColorDict {
    if (_courseColorDict == nil) {
        _courseColorDict = [[NSMutableDictionary alloc] init];
    }
    return _courseColorDict;
}
@end
