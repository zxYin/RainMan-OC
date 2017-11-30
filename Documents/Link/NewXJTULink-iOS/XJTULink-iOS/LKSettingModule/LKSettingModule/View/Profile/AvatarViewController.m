//
//  AvatarViewController.m
//  LKSettingModule
//
//  Created by Yunpeng on 2016/12/6.
//  Copyright © 2016年 Yunpeng. All rights reserved.
//

#import "AvatarViewController.h"
#import "ViewsConfig.h"
#import "AFNetworking.h"
#import "Macros.h"
#import "User+Auth.h"
#import "SVProgressHUD.h"
#import "UIImage+LKExpansion.h"
#import <Photos/Photos.h>
@interface AvatarViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    CGRect _defaultFrame;
}
@property (nonatomic, strong) UIImageView *avatarImageView;
@end

@implementation AvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    
    [self.view addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    
    [self.avatarImageView addGestureRecognizer:pinch];
    self.avatarImageView.userInteractionEnabled = YES;
    self.avatarImageView.multipleTouchEnabled = YES;
    
    
    NSURL *avatarURL = [NSURL URLWithString:[User sharedInstance].avatarURL];
    [self.avatarImageView sd_setImageWithURL:avatarURL placeholderImage:[UIImage imageNamed:@"image_avatar_default"]];
    
    
    @weakify(self);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"nav_more_item_normal"] style:UIBarButtonItemStyleDone handler:^(id sender) {
        @strongify(self);
        
        TBActionSheet *actionSheet = [[TBActionSheet alloc] init];
        [actionSheet addButtonWithTitle:@"拍照" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            [self showImagePickerController:UIImagePickerControllerSourceTypeCamera];
        }];
        
        [actionSheet addButtonWithTitle:@"从手机相册选择" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            [self showImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        
        [actionSheet addButtonWithTitle:@"保存图片" style:TBActionButtonStyleDefault handler:^(TBActionButton * _Nonnull button) {
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImage:self.avatarImageView.image];
                [AppContext showProgressLoadingWithMessage:@"正在保存"];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [AppContext showProgressFinishHUDWithMessage:@"保存成功"];
                } else {
                    [AppContext showProgressFailHUDWithMessage:@"保存失败，请检查相册访问权限。"];
                }
                
            }];
            
            
        }];
        
        [actionSheet addButtonWithTitle:@"取消" style:TBActionButtonStyleCancel];
        [actionSheet show];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)showImagePickerController:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = type;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (void)panGestureRecognized:(UIPinchGestureRecognizer *)pinch {
    static CGRect originFrame;
    UIView *view = pinch.view;
    
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan: {
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                originFrame = view.frame;
            });
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            view.transform = CGAffineTransformScale(view.transform, pinch.scale, pinch.scale);
            pinch.scale = 1;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (view.frame.size.width < MainScreenSize.width) {
                [UIView animateWithDuration:0.5 animations:^{
                    view.frame = originFrame;
                }];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info[UIImagePickerControllerEditedImage] lk_imageScaledToSize:CGSizeMake(200, 200)];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [AppContext showProgressLoadingWithMessage:@"正在上传"];
    [self uploadImage:image finish:^(NSString *message, NSError *error) {
        self.avatarImageView.image = image;
        if (error == nil) {
            [AppContext showProgressFinishHUDWithMessage:message];
        } else {
            [AppContext showProgressFailHUDWithMessage:message];
            NSLog(@"%@",error);
        }
    }];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - upload Image 
- (void)uploadImage:(UIImage *)image finish:(void (^)(NSString *message, NSError *error))finish{
    NSMutableURLRequest *request =
    [[AFHTTPRequestSerializer serializer]
     multipartFormRequestWithMethod:@"POST"
     URLString:[kServerURL stringByAppendingString:@"/1.0/stuInfo/uploadPortrait/"]
     parameters:nil
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
         [formData appendPartWithFileData:[NSData dataWithData:UIImagePNGRepresentation(image)]
                                     name:@"portrait"
                                 fileName:@"touxiang.png"
                                 mimeType:@"image/png"];
         NSDictionary *request_info = @{
                                        @"user_id":[User sharedInstance].userId,
                                        @"user_token":[User sharedInstance].userToken,
                                        };
         
         [formData appendPartWithFormData:
          [NSJSONSerialization dataWithJSONObject:request_info options:NSJSONWritingPrettyPrinted error:nil]
                                     name:@"other"];
     } error:nil];
    
    NSLog(@"request:%@",request);
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            finish(@"网络超时",error);
        } else {
            NSLog(@"%@",responseObject);
            NSString *message = @"";
            if ([responseObject[@"status"] integerValue] == 200) {
                NSString *avatarURL = [responseObject[@"data"] stringForKey:@"portrait"];
                if (avatarURL != nil) {
                    [User sharedInstance].avatarURL = avatarURL;
                }
                message = @"上传成功";
            } else {
                message = @"上传失败";
            }
            finish(message,nil);
        }
    }];
    
    [uploadTask resume];
}


#pragma mark - getter

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _avatarImageView;
}

@end
