//
//  TranscriptsItemModel.h
//  LKCourseModule
//
//  Created by Yunpeng on 2016/11/24.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Mantle/Mantle.h>
@interface TranscriptsItemModel :MTLModel<MTLJSONSerializing>
/**
 *  学期
 *  eg：2014-2015学年 第二学期
 */
@property (copy,nonatomic) NSString *semester;

/**
 *  课程类型
 *  eg: 基础通识类核心课
 */
@property (copy,nonatomic) NSString *type;

/**
 *  状态
 *  eg: 正常
 */
@property (copy,nonatomic) NSString *testNature;

/**
 *  课程代码
 *  eg: C00301
 */
@property (copy,nonatomic) NSString *code;

/**
 *  课程名称
 *  eg: 社会学概论
 */
@property (copy,nonatomic) NSString *name;

/**
 *  课程属性
 *  eg: 选修
 */
@property (copy,nonatomic) NSString *nature;

/**
 *  xxu
 */
@property (copy,nonatomic) NSString *schoolYear;

@property (copy,nonatomic) NSString *score;

@property (copy,nonatomic) NSString *credit;

@property (copy,nonatomic) NSString *isValid;
@end
