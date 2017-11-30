//
//  News.h
//  
//
//  Created by Yunpeng on 15/8/29.
//
//

#import <Mantle/Mantle.h>
#import "FavoritesModel.h"
@interface NewsModel : MTLModel <MTLJSONSerializing,Favoritable>
@property (nonatomic, copy) NSString *pageTitle;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *originURLString;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, assign) BOOL hasAccessory;

@property (readonly,assign,nonatomic) BOOL isReaded;
@end
