//
//  AJChangeInformationTableViewController.m
//  SC
//
//  Created by mac on 17/3/13.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJChangeInformationTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>
#import "MBProgressHUD.h"

#define kUserIconIndexpath [NSIndexPath indexPathForRow:0 inSection:0]  //用户头像indexPath

@interface AJChangeInformationTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *userIconImageView;  /**< 用户头像*/
@property (strong, nonatomic) IBOutlet UILabel *nickNameLabel;          /**< 昵称标签*/
@property (strong, nonatomic) IBOutlet UILabel *signtureLable;          /**< 签名标签*/

@end

@implementation AJChangeInformationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"修改个人信息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath isEqual:kUserIconIndexpath]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *openCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self checkCameraAuthorization:^(BOOL auth) {
                if (!auth) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有权限拍照" message:@"你可以在\"隐私设置\"中启用访问" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *set = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:set];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
                    cameraController.allowsEditing = NO;
                    cameraController.delegate = self;
                    cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:cameraController animated:YES completion:nil];
                }
            }];
        }];
        UIAlertAction *openAlbum = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self checkPhotosAuthorization:^(BOOL auth) {
                if (!auth) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"没有权限访问相册" message:@"你可以在\"隐私设置\"中启用访问" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *set = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:set];
                    [alert addAction:cancel];
                    [self presentViewController:alert animated:YES completion:nil];
                }else{
                    UIImagePickerController *photosController = [[UIImagePickerController alloc] init];
                    //导航栏和应用中其他页面统一
                    if ([photosController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
                        [photosController.navigationBar setBarTintColor:[UIColor blackColor]];
                        [photosController.navigationBar setBarStyle:UIBarStyleBlack];
                        [photosController.navigationBar setTintColor:[UIColor whiteColor]];
                    }
                    photosController.allowsEditing = YES;
                    photosController.delegate = self;
                    photosController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                    [self presentViewController:photosController animated:YES completion:nil];
                }
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:openCamera];
        [alert addAction:openAlbum];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Check Authorization
//检查并获取相机权限
- (void)checkCameraAuthorization:(void (^)(BOOL auth))block{
    BOOL status = NO;
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusDenied:
            status = NO;
            break;
        case AVAuthorizationStatusRestricted:
            status = NO;
            break;
        case AVAuthorizationStatusAuthorized:
            status = YES;
            break;
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (block) {
                    block(granted);
                    return ;
                }
            }];
            break;
    }
    
    if (block) {
        block(status);
    }
}


//检测并获取相册权限
- (void)checkPhotosAuthorization:(void (^)(BOOL auth))block{
    BOOL status = NO;
    PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoStatus) {
        case PHAuthorizationStatusDenied:
            status = NO;
            break;
        case PHAuthorizationStatusRestricted:
            status = NO;
            break;
        case PHAuthorizationStatusAuthorized:
            status = YES;
            break;
        case PHAuthorizationStatusNotDetermined:
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (block) {
                    block(status);
                    return ;
                }
            }];
    }
    
    if (block) {
        block(status);
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *newImage = info[UIImagePickerControllerOriginalImage];
    self.userIconImageView.image = newImage;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (error) {
        hud.labelText = @"保存失败";
    }else{
        hud.labelText = @"保存成功";
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

@end
