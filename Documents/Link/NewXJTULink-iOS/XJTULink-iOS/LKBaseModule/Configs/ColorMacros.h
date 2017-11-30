//
//  ColorMacros.h
//  XJTULink-iOS
//
//  Created by Yunpeng on 16/8/10.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#ifndef ColorMacros_h
#define ColorMacros_h

#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define LKColorLightGray UIColorFromRGB(0xf7f7f7)
#define LKColorGray UIColorFromRGB(0xbdbdbd)
#define LKColorDarkGray UIColorFromRGB(0x666565)
#define LKColorLightBlue UIColorFromRGB(0x23ade5)
#define LKColorGrayBlue UIColorFromRGB(0x60788f)
#define LKColorOrange UIColorFromRGB(0xed6d00)
#define LKColorLightBrown UIColorFromRGB(0xe0d0b9)
#define LKColorPink UIColorFromRGB(0xf05181)
#define LKColorRed UIColorFromRGB(0xef6140)

#endif /* ColorMacros_h */
