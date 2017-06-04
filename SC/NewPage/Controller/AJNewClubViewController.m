//
//  AJNewClubViewController.m
//  SC
//
//  Created by 潘安静 on 2017/5/21.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNewClubViewController.h"
#import "AJFormTextField.h"
#import "AJFormTextView.h"
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>
#import "AJSchoolClub+Request.h"
#import "MBProgressHUD.h"

@interface AJNewClubViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;           /**< 底视图*/ //保证后期数据变多可滑动
@property(nonatomic, strong)UIImageView *iconImageView;         /**< 社团图标视图*/
@property(nonatomic, strong)AJFormTextField *clubNameTextField; /**< 社团名字输入框*/
@property(nonatomic, strong)AJFormTextView *clubIntroTextView;  /**< 社团简介输入框*/
@property(nonatomic, strong)UIButton *submitButton;             /**< 提交按钮*/
@property(nonatomic, strong)NSMutableArray *imageArray;         /**< 社团头像数组*/

@end

@implementation AJNewClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新建社团";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //点击其他地方收起键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfView)];
    tapGesture.cancelsTouchesInView = false;
    [self.view addGestureRecognizer:tapGesture];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init View
- (void)initView{
    
    //原型数据定义
    CGFloat imageViewWidth = 80.0;
    CGFloat marginX = 20.0;
    CGFloat marginMaxY = 44.0;
    CGFloat marginMinY = 16.0;
    CGFloat textFieldHeight = 60.0;
    CGFloat textViewHeight = 80.0;
    CGFloat buttonHeight = 40.0;
    
    self.scrollView = ({
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = self.view.bounds;
        scrollView.showsVerticalScrollIndicator = false;
        [self.view addSubview:scrollView];
        scrollView;
    });
    
    self.iconImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"Me_Placeholder"];
        imageView.frame = CGRectMake(0, 0, imageViewWidth, imageViewWidth);
        imageView.center = CGPointMake(self.scrollView.bounds.size.width * 0.5, marginMaxY + imageViewWidth * 0.5);
        imageView.layer.cornerRadius = imageViewWidth * 0.5;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.borderColor = AJBackGroundColor.CGColor;
        imageView.layer.masksToBounds = true;
        [self addGestureForView:imageView];
        [self.scrollView addSubview:imageView];
        imageView;
    });
    
    self.clubNameTextField = ({
        AJFormTextField *textField = [[AJFormTextField alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(self.iconImageView.frame) + marginMinY, self.scrollView.frame.size.width - 2 * marginX, textFieldHeight)];
        textField.placeholderText = @"社团名称";
        [self.scrollView addSubview:textField];
        textField;
    });
    
    
    self.clubIntroTextView = ({
        AJFormTextView *textView = [[AJFormTextView alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(self.clubNameTextField.frame) + marginMinY, self.scrollView.frame.size.width - 2 * marginX, textViewHeight)];
        textView.placeholderText = @"社团简介";
        [self.scrollView addSubview:textView];
        textView;
    });
    
    self.submitButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(marginX, CGRectGetMaxY(self.clubIntroTextView.frame) + marginMaxY, self.scrollView.bounds.size.width - 2 * marginX, buttonHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:18.0];
        button.backgroundColor = AJBarColor;
        [button setTitle:@"新建社团" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        button;
    });
}

- (void)addGestureForView:(UIImageView *)imageView{
    imageView.userInteractionEnabled = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [imageView addGestureRecognizer:tapGesture];
}

#pragma mark - Tap
- (void)tapSelfView{
    [self.clubNameTextField resignFirstResponder];
    [self.clubIntroTextView resignFirstResponder];
}

- (void)tapView{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *openCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkCameraAuthorization:^(BOOL auth) {
            if (!auth) {
                [self alertNoAuthorization:@"没有权限访问相机"];
            }else{
                UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
                cameraController.allowsEditing = YES;
                cameraController.delegate = self;
                cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:cameraController animated:YES completion:nil];
            }
        }];
    }];
    UIAlertAction *openAlbum = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkPhotosAuthorization:^(BOOL auth) {
            if (!auth) {
                [self alertNoAuthorization:@"没有权限访问相册"];
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
                }
            }];
            return ;
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
                }
            }];
            return ;
    }
    
    if (block) {
        block(status);
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *newImage = info[UIImagePickerControllerEditedImage];
    self.iconImageView.image = newImage;
    
    //先清空数组，后添加
    [self.imageArray removeAllObjects];
    [self.imageArray addObject:newImage];
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

/**
 无权限弹窗
 
 @param title 弹窗标题
 */
- (void)alertNoAuthorization:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"你可以在\"隐私设置\"中启用访问" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *set = [UIAlertAction actionWithTitle:@"前往设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([UIDevice currentDevice].systemVersion.floatValue < 10.0) {
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }else{
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:set];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Button Click
- (void)submit:(UIButton *)button{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"group_name"] = self.clubNameTextField.text;
    params[@"introduction"] = self.clubIntroTextView.text;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在新建社团";
    [AJSchoolClub newClubWithParams:params WithImageArray: self.imageArray SuccessBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"创建成功";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

- (NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    
    return _imageArray;
}

@end
