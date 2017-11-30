//
//  ClubViewModel.m
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "ClubViewModel.h"
#import "ClubDetailAPIManager.h"
#import "ClubModel.h"
//#import "OUser.h"
@interface ClubViewModel()<YLAPIManagerDataSource>
@property (nonatomic, copy) NSString *clubId;

//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *type;
//@property (nonatomic, copy) NSString *summary;
//@property (nonatomic, copy) NSString *honor;
//@property (nonatomic, copy) NSString *showType;
//@property (nonatomic, copy) NSURL *imageURL;
//@property (nonatomic, copy) NSString *locale;
//@property (nonatomic, copy) NSURL *applyURL;
//@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, strong) ClubDetailAPIManager *clubDetailAPIManager;
@end
@implementation ClubViewModel

- (instancetype)initWithClubModel:(ClubModel *)model {
    self = [self initWithClubId:model.clubId];
    if (self) {
        [self configWithModel:model];
    }
    return self;
}

- (instancetype)initWithClubId:(NSString *)clubId {
    self = [super init];
    if (self) {
        [self setupRAC];
        self.clubId = clubId;
    }
    return self;
}

- (void)setupRAC {
    @weakify(self);
    [self.networkingRAC.executionSignal subscribeNext:^(id x) {
        @strongify(self);
        ClubModel *model = [self.clubDetailAPIManager fetchDataFromModel:ClubModel.class];
        [self configWithModel:model];
    }];
}

- (void)configWithModel:(ClubModel *)model {
    self.name = model.name;
    self.honor = [model.titles firstObject];
    self.type = model.type;
    self.summary = model.summary;
    self.imageURL = [model.images firstObject];
    self.locale = model.locale;
    self.applyURL = model.applyURL;
    self.introduction = model.introduction;
    self.showType = model.showType;
    self.webURL = model.webURL;
    self.shareURLString = model.shareURLString;
    self.isAllowApply = model.isAllowApply;
    
    DepartmentsViewModel *departmentsViewModel = [[DepartmentsViewModel alloc] init];
    departmentsViewModel.type = model.departmentType;
    departmentsViewModel.url = model.departmentURL;
    departmentsViewModel.departments = model.departments;
    self.departmentsViewModel = departmentsViewModel;
}


- (NSDictionary *)paramsForAPI:(YLBaseAPIManager *)manager {
    NSDictionary *params = @{};
    if (manager == self.clubDetailAPIManager) {
        params = @{
                   kClubDetailAPIManagerParamsKeyClubId:self.clubId
                   };
    }
    return params;
    
}

- (id<YLNetworkingRACOperationProtocol>)networkingRAC {
    return self.clubDetailAPIManager;
}

#pragma mark - getter
- (ClubDetailAPIManager *)clubDetailAPIManager {
    if (_clubDetailAPIManager == nil) {
        _clubDetailAPIManager = [ClubDetailAPIManager new];
        _clubDetailAPIManager.dataSource = self;
    }
    return _clubDetailAPIManager;
}

- (NSString *)applyPageJS {
    NSString *name = @"";//[OUser sharedInstance].name?:@"";
    NSString *number = @"";//[OUser sharedInstance].number?:@"";
    NSString *major = @"";//[OUser sharedInstance].major?:@"";
    NSString *college = @"";//[OUser sharedInstance].college?:@"";
    NSString *academy = @"";//[OUser sharedInstance].academy?:@"";
    return [NSString stringWithFormat:@"var datas = ['%@','%@','%@','%@','%@']; var keys = ['姓名','学号','学院','专业','书院'];  $('.field') .each(function(){ var field_id = '#entry_' + $(this).attr('data-api-code'); var text = $(this).text(); for (var i=0;i<keys.length;i++) { if (text.indexOf(keys[i])>0) { if ($(field_id).is('input')) { $(field_id).val(datas[i]); } else if($(field_id).is('select')) { $(field_id).children().each(function(){ if($(this).text() == datas[i]){ $(this).attr('selected',true); } }) } } } });$('.published').children().remove();",name,number,academy,major,college];
    
}

- (LKShareModel *)shareModel {
    LKShareModel *model = [[LKShareModel alloc] init];
    model.title = [self.name stringByAppendingString:@"等你加入！"];
    model.summary = self.summary;
    model.url = self.shareURLString;
    return model;
}
@end
