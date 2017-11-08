//
//  AJNewScheduleViewController.m
//  SC
//
//  Created by 潘安静 on 2017/5/25.
//  Copyright © 2017年 anjing. All rights reserved.
//

#import "AJNewScheduleViewController.h"
#import "AJFormTextView.h"
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/PHPhotoLibrary.h>
#import "AJSchedule+HttpRequest.h"
#import "MBProgressHUD.h"
#import "AJSelectMemberTableViewController.h"
#import "AJSchoolClub+Request.h"
#import "YYModel.h"

@interface AJNewScheduleViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UIView *statusBar;
@property (nonatomic, strong) UIView *navigationBar;
//@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) AJFormTextView *textView;
@property (nonatomic, strong) UIToolbar *scheduleToolbar;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIBarButtonItem *timeButtonItem;

@property (nonatomic, assign) BOOL isDisplayToolView;

@property (nonatomic, strong) NSArray *clubArray;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSMutableArray *photoArray;

//为了方便区分0和空
@property (nonatomic, strong) NSNumber *selectRow;

@end

@implementation AJNewScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.isDisplayToolView = false;
    
    [self initNavigationBar];
    [self initScheduleToolbar];
    [self initTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[self setStatusBarBackgroundColor:AJBarColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init View
//设置状态栏背景颜色，会修改所有状态栏颜色
/*- (void)setStatusBarBackgroundColor:(UIColor *)color{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        [statusBar setBackgroundColor:color];
    }
}
 */

//设置状态栏上文字颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)initNavigationBar{
    //原型数据
    CGFloat navigationHeight = 44.0;
    CGFloat marginX = 12.0;
    CGFloat marginY = 10.0;
    CGFloat buttonWidth = navigationHeight - 2 * marginY;
    CGFloat fontSize = 16.0;
    
    self.statusBar = ({
        UIView *view = [[UIView alloc] init];
        //适配 iPhone X
        view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kStatusbarHeight);
        view.backgroundColor = AJBarColor;
        [self.view addSubview:view];
        view;
    });
    
    self.navigationBar = ({
        UIView *navigationBar = [[UIView alloc] init];
        //适配 iPhone X
        navigationBar.frame = CGRectMake(0, kStatusbarHeight, [UIScreen mainScreen].bounds.size.width, navigationHeight);
        navigationBar.backgroundColor = AJBarColor;
        [self.view addSubview:navigationBar];
        navigationBar;
    });
    
    self.closeButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(marginX, marginY, buttonWidth, buttonWidth);
        [button setBackgroundImage:[UIImage imageNamed:@"NewPage_Close_White"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSchedule) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:button];
        button;
    });
    
    self.confirmButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - buttonWidth - marginX, marginY, buttonWidth, buttonWidth);
        [button setBackgroundImage:[UIImage imageNamed:@"NewPage_Confirm_White"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(confirmSchedule) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:button];
        button;
    });
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(CGRectGetMaxX(self.closeButton.frame) + marginX, marginY, [UIScreen mainScreen].bounds.size.width - 2 * buttonWidth - 4 * marginX, buttonWidth);
        label.text = @"新建日程";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize: fontSize];
        label.textColor = [UIColor whiteColor];
        [self.navigationBar addSubview:label];
        label;
    });
    
}

- (void)initScheduleToolbar{
    
    //原型数据
    CGFloat toolbarHeight = 44.0;
    
    self.scheduleToolbar = ({
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        //适配 iPhone X
        toolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - toolbarHeight - kMarginBottom, [UIScreen mainScreen].bounds.size.width, toolbarHeight);
        toolbar.barStyle = UIBarStyleBlack;
        toolbar.backgroundColor = AJBarColor;
        
        NSArray *imageNameArray = @[@"NewPage_Photo",@"NewPage_Camera",@"NewPage_Date",@"NewPage_Location"];
        NSMutableArray *barItemArray = [NSMutableArray array];
        
        //通过添加 flexibleBarButtonItem 来调节间距
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItemArray addObject:flexibleItem];
        
        //原型数据
        CGFloat marginY = 10.0;
        CGFloat buttonHeight = toolbarHeight - 2 * marginY;
        CGFloat marginX = ([UIScreen mainScreen].bounds.size.width - imageNameArray.count * buttonHeight) / (imageNameArray.count * 2 - 2);
        for (int i = 0; i < imageNameArray.count ; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            //设置frame 后间距并没有生效
            button.frame = CGRectMake(marginX * (2 * i + 1) + buttonHeight * i, marginY, buttonHeight, buttonHeight);
            button.tag = i;
            [button setBackgroundImage:[UIImage imageNamed:imageNameArray[i]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(scheduleItemClick:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
            [barItemArray addObject:buttonItem];
            
            UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            [barItemArray addObject:flexibleItem];
        }
        
        toolbar.items = barItemArray;
        [self.view addSubview:toolbar];
        toolbar;
    });
}

- (void)initTextView{
    self.textView = ({
        //适配 iPhone X
        AJFormTextView *textView = [[AJFormTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.navigationBar.frame) - CGRectGetHeight(self.scheduleToolbar.frame) - kMarginBottom)];
        textView.placeholderText = @"日程内容";
        textView.text = self.textString ? self.textString :@"";
        textView.borderColor = [UIColor whiteColor];
        [self.view addSubview:textView];
        textView;
    });
}

#pragma mark - Button Click
- (void)closeSchedule{
    [self.textView resignFirstResponder];
    if (self.textView.hasText) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定离开" message:@"离开后将不保存输入的文本" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:confirm];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)confirmSchedule{
    [self.textView resignFirstResponder];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
    hud.label.text = @"正在上传日程";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (self.groupID == nil) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请选择社团后提交";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:true];
        });
        return;
    }
    
    if (!self.textView.hasText) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请填写内容后提交";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:true];
        });
        return;
    }
    
    params[@"group_id"] = self.groupID;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:self.datePicker.date ? : [NSDate date]];
    params[@"schedule_time"] = dateString;
    params[@"content"] = self.textView.text;
    
    [AJSchedule newScheduleRequestWithParams:params WithImageArray:self.photoArray SuccessBlock:^(id object) {
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"上传成功";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:true];
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    } FailBlock:^(NSError *error) {
        [self failErrorWithView:self.view error:error];
    }];
}

- (void)scheduleItemClick:(UIButton *)button{
    
    [self.textView resignFirstResponder];
    
    
    //switch中不能定义
    NSDate *date = [NSDate date];
    
    switch (button.tag) {
        case 0:
            //图片选择
            [self showPhotoPicker];
            break;
        case 1:
            //摄像
            [self takePhoto];
            break;
        case 2:
            //时间选择
            self.isDisplayToolView = true;
            [self showDatePicker:date];
            break;
        case 3:
            //位置选择(暂时替换为社团选择页面)
            break;
        default:
            break;
    }
    
    if (button.tag == 3) {
        AJSelectMemberTableViewController *selectVC = [[AJSelectMemberTableViewController alloc] init];
        selectVC.selectType = selectTypeClub;
        
        //请求社团数据
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        hud.label.text = @"正在加载社团";
        [AJSchoolClub getSelfClubRequestWithParams:params SuccessBlock:^(id object) {
            [MBProgressHUD hideHUDForView:self.view animated:true];
            
            self.clubArray = [NSArray yy_modelArrayWithClass:[AJSchoolClub class] json:object[@"data"]];
            selectVC.dataArray = self.clubArray;
            
            if (self.selectRow) {
                selectVC.selectIndexPathArray = [NSMutableArray arrayWithObject:self.selectRow];
            }
            [self presentViewController:selectVC animated:true completion:nil];
            
        } FailBlock:^(NSError *error) {
            [self failErrorWithView:self.view error:error];
        }];
        
        
        //选择界面回调
        selectVC.selectMemberBlock = ^(NSMutableArray *array){
            self.selectRow = array[0];
            self.groupID = ((AJSchoolClub *)self.clubArray[[array[0] integerValue]]).Groupid;
        };
        
    }
}


- (void)showDatePicker:(NSDate *)date{
    //原型数据
    CGFloat toolbarHeight = 40.0;
    CGFloat datePickerHeight = 210.0;
    
    if (self.toolbar == nil && self.datePicker == nil) {
        
        
        self.datePicker = ({
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - datePickerHeight, [UIScreen mainScreen].bounds.size.width, datePickerHeight)];
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            [datePicker setDate:date];
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:datePicker];
            datePicker;
        });
        
        self.toolbar = ({
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.datePicker.frame) - toolbarHeight, [UIScreen mainScreen].bounds.size.width, toolbarHeight)];
            toolbar.barStyle = UIBarStyleBlack;
            toolbar.backgroundColor = AJBarColor;
            toolbar.tintColor = [UIColor whiteColor];
            
            UIBarButtonItem *currentTimeButton = [[UIBarButtonItem alloc] initWithTitle:@"当前时间" style:UIBarButtonItemStyleDone target:self action:@selector(getCurrentTime)];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm"];
            UIBarButtonItem *timeButton = [[UIBarButtonItem alloc] initWithTitle: [dateFormatter stringFromDate:date]style:UIBarButtonItemStylePlain target:nil action:nil];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(confirmPickDate)];
            UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            NSArray *barButtonArray = [NSArray arrayWithObjects:currentTimeButton,flexibleButton,timeButton,flexibleButton,doneButton, nil];
            [toolbar setItems:barButtonArray];
            
            self.timeButtonItem = timeButton;
            [self.view addSubview:toolbar];
            toolbar;
        });
    }else{
        self.datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - datePickerHeight, [UIScreen mainScreen].bounds.size.width, datePickerHeight);
        self.toolbar.frame = CGRectMake(0, CGRectGetMinY(self.datePicker.frame) - toolbarHeight, [UIScreen mainScreen].bounds.size.width, toolbarHeight);
    }
    
}

- (void)showPhotoPicker{
    UIImagePickerController *photosController = [[UIImagePickerController alloc] init];
    //导航栏和应用中其他页面统一
    if ([photosController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        [photosController.navigationBar setBarTintColor:AJBarColor];
        [photosController.navigationBar setBarStyle:UIBarStyleBlack];
        [photosController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    photosController.allowsEditing = YES;
    photosController.delegate = self;
    photosController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:photosController animated:YES completion:nil];
}

- (void)takePhoto{
    
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
}

#pragma mark - Date Picker

- (void)dateChanged:(UIDatePicker *)datePicker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm"];
    self.timeButtonItem.title = [dateFormatter stringFromDate:datePicker.date];
}

- (void)getCurrentTime{
    [self.datePicker setDate:[NSDate date]];
    //不调用值改变方法，因此手动调用
    [self dateChanged:self.datePicker];
}

- (void)confirmPickDate{

    CGFloat toolbarHeight = 44.0;
    [UIView animateWithDuration:0.1 animations:^{
        //适配 iPhone X
        self.scheduleToolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - toolbarHeight - kMarginBottom, [UIScreen mainScreen].bounds.size.width, toolbarHeight);
        self.datePicker.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
        self.toolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0);
    } completion:nil];
}

#pragma mark - Keyboard Notification
- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //修复工具栏被文本输入框遮挡
    [self.view bringSubviewToFront:self.scheduleToolbar];
    
    CGFloat toolbarHeight = 44.0;
    [UIView animateWithDuration:0.1 animations:^{
        self.scheduleToolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - keyboardRect.size.height - toolbarHeight, [UIScreen mainScreen].bounds.size.width, toolbarHeight);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    CGFloat toolbarHeight = 44.0;
    if (!self.isDisplayToolView) {
        [UIView animateWithDuration:0.1 animations:^{
            self.scheduleToolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - toolbarHeight, [UIScreen mainScreen].bounds.size.width, toolbarHeight);
        } completion:nil];
    }
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
    
    [self addImage:newImage toTextView:self.textView];
    [self.photoArray addObject:newImage];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (error) {
        hud.label.text = @"保存失败";
    }else{
        hud.label.text = @"保存成功";
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)addImage:(UIImage *)image toTextView:(UITextView *)textView{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    textAttachment.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 2 * 12.0, [UIScreen mainScreen].bounds.size.width - 2 * 12.0);
    textAttachment.image = image;
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [text insertAttributedString:textAttachmentString atIndex:textView.selectedRange.location];
    textView.attributedText = text;
}

#pragma mark - Setter
- (void)setIsDisplayToolView:(BOOL)isDisplayToolView{
    _isDisplayToolView = isDisplayToolView;
    
    [self.view bringSubviewToFront:self.scheduleToolbar];
    CGFloat toolbarHeight = 44.0;
    if (isDisplayToolView) {
        [UIView animateWithDuration:0.1 animations:^{
            self.scheduleToolbar.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - toolbarHeight - 250.0, [UIScreen mainScreen].bounds.size.width, toolbarHeight);
        } completion:nil];
    }
}

#pragma mark - Lazy Load
- (NSMutableArray *)photoArray{
    if (_photoArray == nil) {
        _photoArray = [NSMutableArray array];
    }
    
    return _photoArray;
}

@end
