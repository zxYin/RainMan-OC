//
//  MineViewModel.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 2016/11/26.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MineItemViewModel.h"

typedef NS_ENUM(NSInteger, MineItem) {
    kMineItemTranscripts = 1,
    kMineItemIdleClassroom,
    kMineItemTransfer,
    kMineItemLibrary,
    kMineItemTeachingEvaluation,
    kMineItemFavorites,
    kMineItemSetting,
    kMineItemExam,
};

@interface MineViewModel : NSObject
@property (nonatomic, copy, readonly) NSString *nickname;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSURL *avatarURL;

@property (nonatomic, copy) NSArray<MineItemViewModel *> *mineItemViewModels;
@end
