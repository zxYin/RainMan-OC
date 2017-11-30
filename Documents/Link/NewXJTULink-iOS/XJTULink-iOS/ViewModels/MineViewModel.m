//
//  MineViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/11/26.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "MineViewModel.h"
#import "User.h"
@interface MineViewModel()
@property (nonatomic, strong) MineItemViewModel *transcriptsItemViewModel;
@property (nonatomic, strong) MineItemViewModel *idleClassroomItemViewModel;
@property (nonatomic, strong) MineItemViewModel *transferItemViewModel;
@property (nonatomic, strong) MineItemViewModel *libraryItemViewModel;
@property (nonatomic, strong) MineItemViewModel *teachingEvaluationTtemViewModel;
@property (nonatomic, strong) MineItemViewModel *favoritesItemViewModel;
@property (nonatomic, strong) MineItemViewModel *settingItemViewModel;
@end

@implementation MineViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRAC];
    }
    return self;
}

- (void)setupRAC {
    self.mineItemViewModels =
  @[self.transcriptsItemViewModel, self.idleClassroomItemViewModel,
    self.transferItemViewModel, self.libraryItemViewModel,
    self.teachingEvaluationTtemViewModel,
//    self.favoritesItemViewModel,
    self.settingItemViewModel];
    
    User *user = [User sharedInstance];
    RAC(self, nickname) = RACObserve(user, nickname);
    RAC(self, name) = RACObserve(user, name);
    RAC(self, avatarURL) = [RACObserve(user, avatarURL) map:^id(id value) {
        return [NSURL URLWithString:value];
    }];
}

#pragma mark - getter
- (MineItemViewModel *)transcriptsItemViewModel {
    if (_transcriptsItemViewModel == nil) {
        _transcriptsItemViewModel = [[MineItemViewModel alloc] init];
        _transcriptsItemViewModel.title = @"成绩查询";
        _transcriptsItemViewModel.image = [UIImage imageNamed:@"me_record_cell_normal"];
        _transcriptsItemViewModel.tag = kMineItemTranscripts;
    }
    return _transcriptsItemViewModel;
}

- (MineItemViewModel *)idleClassroomItemViewModel {
    if(_idleClassroomItemViewModel == nil) {
        _idleClassroomItemViewModel = [[MineItemViewModel alloc] init];
        _idleClassroomItemViewModel.title = @"空闲教室";
        _idleClassroomItemViewModel.image = [UIImage imageNamed:@"me_classroom_cell_normal"];
        _idleClassroomItemViewModel.tag = kMineItemIdleClassroom;
    }
    return _idleClassroomItemViewModel;
}

- (MineItemViewModel *)transferItemViewModel {
    if (_transferItemViewModel == nil) {
        _transferItemViewModel = [[MineItemViewModel alloc] init];
        _transferItemViewModel.title = @"在线圈存";
        _transferItemViewModel.image = [UIImage imageNamed:@"me_card_normal"];
        _transferItemViewModel.tag = kMineItemTransfer;
    }
    return _transferItemViewModel;
}

- (MineItemViewModel *)libraryItemViewModel {
    if (_libraryItemViewModel == nil) {
        _libraryItemViewModel = [[MineItemViewModel alloc] init];
        _libraryItemViewModel.title = @"借阅信息";
        _libraryItemViewModel.image = [UIImage imageNamed:@"me_lib_cell_normal"];
        _libraryItemViewModel.tag = kMineItemLibrary;
    }
    return _libraryItemViewModel;
}

- (MineItemViewModel *)teachingEvaluationTtemViewModel {
    if (_teachingEvaluationTtemViewModel == nil) {
        _teachingEvaluationTtemViewModel = [[MineItemViewModel alloc] init];
        _teachingEvaluationTtemViewModel.title = @"教学评价";
        _teachingEvaluationTtemViewModel.image = [UIImage imageNamed:@"me_evaluation_cell_normal"];
        _teachingEvaluationTtemViewModel.tag = kMineItemTeachingEvaluation;
    }
    return _teachingEvaluationTtemViewModel;
}

- (MineItemViewModel *)favoritesItemViewModel {
    if (_favoritesItemViewModel == nil) {
        _favoritesItemViewModel = [[MineItemViewModel alloc] init];
        _favoritesItemViewModel.title = @"收藏夹";
        _favoritesItemViewModel.image = [UIImage imageNamed:@"me_fav_cell_normal"];
        _favoritesItemViewModel.tag = kMineItemFavorites;
    }
    return _favoritesItemViewModel;
}

- (MineItemViewModel *)settingItemViewModel {
    if (_settingItemViewModel == nil) {
        _settingItemViewModel = [[MineItemViewModel alloc] init];
        _settingItemViewModel.title = @"设置";
        _settingItemViewModel.image = [UIImage imageNamed:@"me_setting_cell_normal"];
        _settingItemViewModel.tag = kMineItemSetting;
    }
    return _settingItemViewModel;
}

@end
