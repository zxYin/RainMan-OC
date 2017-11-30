//
//  LectureListViewModel.h
//  LKActivityModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LectureItemViewModel.h"
#import "LKNetworking.h"

@interface LectureListViewModel : NSObject<YLNetworkingListRACProtocol>
@property (nonatomic, assign, readonly) BOOL hasNextPage;
@property (nonatomic, copy) NSArray<LectureItemViewModel *> *lectureItemViewModels;

- (instancetype)initWithPageSize:(NSInteger)pageSize;
@end
