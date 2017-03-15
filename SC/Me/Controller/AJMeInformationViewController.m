//
//  AJMeInformationViewController.m
//  SC
//
//  Created by mac on 17/3/9.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJMeInformationViewController.h"
#import "AJClubCollectionViewCell.h"
#import "AJClubCollectionFlowLayout.h"
#import "AJChangeInformationTableViewController.h"
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>

static NSString *const kClubCollectionViewCell = @"clubCollectionViewCell";

@interface AJMeInformationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *userIconImageView;      /**< 用户头像视图*/
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;              /**< 用户昵称标签*/
@property (strong, nonatomic) IBOutlet UILabel *userSchoolLabel;            /**< 用户学校标签*/
@property (strong, nonatomic) IBOutlet UILabel *userTitleLabel;             /**< 用户头衔标签*/
@property (strong, nonatomic) IBOutlet UILabel *userSignatureLable;         /**< 用户个性签名*/
@property (strong, nonatomic) IBOutlet UIView *clubView;                    /**< 社团底视图*/
@property (strong, nonatomic) IBOutlet UIImageView *clubIconImageView;      /**< 社团图标*/
@property (strong, nonatomic) IBOutlet UILabel *clubLabel;                  /**< 社团标签*/

@property (strong, nonatomic) UICollectionView *clubCollectionView;         /**< 社团列表*/

@end

@implementation AJMeInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    
    //头像圆形化
    self.userIconImageView.backgroundColor = [UIColor whiteColor];
    self.userIconImageView.layer.masksToBounds = YES;
    self.userIconImageView.layer.cornerRadius = 40.f; //该控件宽高为80*80，但此处获取为1000*1000
    self.userIconImageView.layer.borderWidth = 1.f;
    self.userIconImageView.layer.borderColor = [UIColor whiteColor].CGColor;

    self.userIconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertChangeIcon)];
    [self.userIconImageView addGestureRecognizer:tapIcon];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Me_Edit"] style:UIBarButtonItemStyleDone target:self action:@selector(editInformation:)];
    
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //针对storyBoard中视图在 viewDidAppear 之前大小为1000*1000
    self.clubView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height * 0.7 - 128, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height * 0.3 + 64);  //0.7为上面视图的居中约束大小
    self.clubLabel.frame = CGRectMake(8, 4, 24, 24);
    self.clubCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.clubLabel.frame), [UIScreen mainScreen].bounds.size.width, self.clubView.frame.size.height - CGRectGetMaxY(self.clubLabel.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init View
- (void)initCollectionView{
    self.clubCollectionView = ({
        UICollectionViewFlowLayout *customLayout = [[AJClubCollectionFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.clubLabel.frame), [UIScreen mainScreen].bounds.size.width, self.clubView.frame.size.height - CGRectGetMaxY(self.clubLabel.frame)) collectionViewLayout:customLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerNib:[UINib nibWithNibName:@"AJClubCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kClubCollectionViewCell];
        [self.clubView addSubview:collectionView];
        collectionView;
    });
}

#pragma mark - Button Click
- (void)editInformation:(UIBarButtonItem *)item{
    AJChangeInformationTableViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"AJChangeInformationTableViewController"];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - Gesture Tap
- (void)alertChangeIcon{
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
                photosController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
                return ;
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
                }
                return ;
            }];
    }
    
    if (block) {
        block(status);
    }
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *newImage = info[UIImagePickerControllerEditedImage];
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

#pragma mark - UiCollectionView Delegate && DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AJClubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kClubCollectionViewCell forIndexPath:indexPath];
    cell.clubImageView.image = [UIImage imageNamed:@"Me_Placeholder"];
    cell.clubNameLabel.text = @"学生会";
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
