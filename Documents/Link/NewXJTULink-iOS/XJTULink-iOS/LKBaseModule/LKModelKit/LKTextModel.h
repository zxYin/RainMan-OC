//
//  LKTextModel.h
//  LKBaseModule
//
//  Created by Yunpeng on 2017/3/27.
//  Copyright © 2017年 Yunpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface LKTextModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *textColor;
@property (nonatomic, assign) NSInteger textSize;

@property (nonatomic, assign) BOOL hasBorder;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, copy) NSString *borderColor;

@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, copy) NSString *backgroundColor;

@property (nonatomic, copy) NSString *padding;
@end
