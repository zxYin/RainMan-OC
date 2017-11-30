//
//  MeHeaderView.h
//  
//
//  Created by Yunpeng on 15/9/8.
//
//

#import <UIKit/UIKit.h>
#define MeHeaderViewHeight 265
@interface MeHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


+ (MeHeaderView *)meHeaderView;
@end
