//
//  PersonalSettingViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "PersonalSettingHeadCell.h"
#import "PersonalSettingCell.h"
#import "SecurityViewController.h"
#import "AddressViewController.h"
#import "SettingNameOrSexViewController.h"
#import "FeelBackViewController.h"
#import "SDImageCache.h"
#import "PushViewController.h"
#import "ShareView.h"

#import <UShareUI/UShareUI.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZImagePickerController.h"
#import "TZLocationManager.h"


@interface PersonalSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic , strong)ShareView *shareView;

@end

@implementation PersonalSettingViewController

- (ShareView *)shareView{
    if (!_shareView) {
        _shareView = [ShareView getShareView];
        _shareView.frame = CGRectMake(0, mScreenHeight, mScreenWidth, mScreenHeight);
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:_shareView];
    }
    return _shareView;
}

- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePicker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePicker.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePicker;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestHeadImage];
}

- (void)requestHeadImage{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"getimg", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            PersonalSettingHeadCell *cell = [self.myTableView cellForRowAtIndexPath:path];
            if (![result[@"data"] hasPrefix:@"http://"]) {
                NSString *headImageUrl = [NSString stringWithFormat:@"http://www.baicaio.com%@",result[@"data"]];
                [cell.titleLabel sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    NSLog(@"%@",error);
                }];
            }else{
                [cell.titleLabel sd_setImageWithURL:[NSURL URLWithString:result[@"data"]] placeholderImage:[UIImage imageNamed:@"头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    NSLog(@"%@",error);
                }];

            }
//            [cell.titleLabel sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
        }
        else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
    
}

- (void)setHeadImage:(UIImage *)image{
    [MBProgressHUD showMessag:@"加载中" toView:self.view];
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"setimg", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    
    NSData *data = UIImageJPEGRepresentation(image, 0);
    
    NSString *encodedImageStr = [data base64Encoding];
    NSString *encodedImageStrAddHead = [NSString stringWithFormat:@"data:image/%@;base64,%@",[self imageTypeWithData:data],encodedImageStr];
    setDickeyobj(infoDic, encodedImageStrAddHead, @"base64");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
        }];
        [[SDImageCache sharedImageCache] clearMemory];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS_REQUEST(result)) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
            PersonalSettingHeadCell *cell = [self.myTableView cellForRowAtIndexPath:path];
            [cell.titleLabel setImage:image];
            UserInfoModel *model = [UserInfoModel sharedUserData];
            model.imageBase64Code = encodedImageStr;
            [UserInfoModel storeUserWithModel:model];
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }else{
            [MBProgressHUD showError:@"修改失败" toView:nil];
        }
        
        
    } failure:^(NSError *erro) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"修改失败" toView:nil];
        NSLog(@"%@", erro);
    } showHUD:nil];
    
}

/** 根据图片二进制流获取图片格式 */
- (NSString *)imageTypeWithData:(NSData *)data {
    uint8_t type;
    [data getBytes:&type length:1];
    switch (type) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

#pragma mark -- 打开相机拍照
- (void)takePhoto{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
        // 拍照之前还需要检查相册权限
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    } else if ([TZImageManager authorizationStatus] == 0) { // 正在弹框询问用户是否允许访问相册，监听权限状态
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            return [self takePhoto];
        });
    } else { // 调用相机

        // 提前定位
        [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
            _location = location;
        } failureBlock:^(NSError *error) {
            _location = nil;
        }];
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = sourceType;
            if(iOS8Later) {
                _imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePicker animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }

    }
}

#pragma mark - 打开相册
- (void)pushImagePickerController {
//    if (self.maxCountTF.text.integerValue <= 0) {
//        return;
//    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
//    if (self.imageIdArray.count > 0) {
//        // 1.设置目前已经选中的图片数组
//        imagePickerVc.selectedAssets = self.imageIdArray; // 目前已经选中的图片数组
//    }
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    imagePickerVc.needCircleCrop = NO;
    imagePickerVc.circleCropRadius = 100;
    imagePickerVc.isStatusBarDefault = NO;
    
#pragma mark - 到这里为止
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        //        [self.ImageArray addObjectsFromArray:photos];
        //        [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        //        NSLog(@"--------%ld-----%ld--",assets.count,photos.count);
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        // 允许裁剪,去裁剪
                        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
#warning 获取到的图片
                                if (image) [self setHeadImage:image];
                        }];
                        imagePicker.needCircleCrop = NO;
                        imagePicker.circleCropRadius = 100;
                        [self presentViewController:imagePicker animated:YES completion:nil];
                        
                    }];
                }];
            }
        }];
    }
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
#warning 获取到的图片
    if (photos.count) [self setHeadImage:photos.firstObject];
    
}

//计算目录大小
- (NSString *)folderSizeAtPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *path = [paths lastObject];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 目录下的文件计算大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        //SDWebImage的缓存计算
        size += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        // 将大小转化为M
        return [NSString stringWithFormat:@"%.2lfM",size / 1024.0 / 1024.0];
    }
    return @"0.0M";
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 4;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        PersonalSettingHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalSettingHeadCell"];
        return cell;
        
    }
    PersonalSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personalSettingCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        UserInfoModel *model = [UserInfoModel sharedUserData];
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.titleLabel.text = @"用户名";
            cell.infoLabel.text = model.username;
        }else if (indexPath.row == 2){
            cell.titleLabel.text = @"性别";
            if (model.gender == 0) {
                cell.infoLabel.text = @"女";
            }else{
                cell.infoLabel.text = @"男";
            }
            
        }else if (indexPath.row == 3){
            cell.titleLabel.text = @"收货信息";
            cell.infoLabel.text = @"";
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
//            cell.titleLabel.text = @"推送设置";
//            cell.infoLabel.text = @"";
//        }else if (indexPath.row == 1) {
            cell.titleLabel.text = @"分享推广";
            cell.infoLabel.text = @"";
        }else if (indexPath.row == 1){
            cell.titleLabel.text = @"问题反馈";
            cell.infoLabel.text = @"";
        }else if (indexPath.row == 2){
            cell.titleLabel.text = @"安全设置";
            cell.infoLabel.text = @"";
        }else if (indexPath.row == 3){
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.titleLabel.text = @"清除缓存";
            cell.infoLabel.text = [self folderSizeAtPath];
        }else if (indexPath.row == 4){
            cell.titleLabel.text = @"退出";
            cell.infoLabel.text = @"";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) return 70;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self takePhoto];
            }];
            UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"去相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pushImagePickerController];
            }];
            [alertController addAction:cancel];
            [alertController addAction:actionCamera];
            [alertController addAction:actionPhoto];
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (indexPath.row == 1){
            
//            SettingNameOrSexViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"settingNameOrSexViewController"];
//            controller.nameOrSex = EDIT_NAME;
//            [self.navigationController pushViewController:controller animated:YES];
            
        }else if (indexPath.row == 2){
            
            SettingNameOrSexViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"settingNameOrSexViewController"];
            controller.nameOrSex = EDIT_SEX;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if (indexPath.row == 3){
            AddressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addressViewController"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            
            self.shareView.ishidenView = NO;
            __weak typeof(self)weakSelf = self;
            self.shareView.block = ^(NSInteger tag) {
                weakSelf.shareView.ishidenView = YES;
                
                if (tag == 6) {
                    UIPasteboard *pab = [UIPasteboard generalPasteboard];
                    pab.string = @"http://www.baicaio.com/item/275534.html";
                    if ([pab.string isEqualToString:@"http://www.baicaio.com/item/275534.html"]) {
                        [MBProgressHUD showError:@"复制链接成功。" toView:nil];
                    }else
                    {
                        [MBProgressHUD showError:@"复制链接失败！" toView:nil];
                        
                    }
                    return ;
                }
                UMSocialPlatformType platformType = UMSocialPlatformType_Sina;
                switch (tag) {
                    case 1:
                        platformType = UMSocialPlatformType_Sina;
                        break;
                    case 2:
                        platformType = UMSocialPlatformType_WechatSession;
                        break;
                    case 3:
                        platformType = UMSocialPlatformType_WechatTimeLine;
                        break;
                    case 4:
                        platformType = UMSocialPlatformType_QQ;
                        break;
                    case 5:
                        platformType = UMSocialPlatformType_Qzone;
                        break;
                    default:
                        break;
                }
                // 根据获取的platformType确定所选平台进行下一步操作
                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                
                //创建网页内容对象
                NSString *title = @"白菜哦";
                
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:title thumImage:[UIImage imageNamed:@"tubiao"]];
                //设置网页地址
                
                shareObject.webpageUrl = @"http://www.baicaio.com/item/275534.html";
                
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:weakSelf completion:^(id data, NSError *error) {
                    if (error) {
                        UMSocialLogInfo(@"************Share fail with error %@*********",error);
                    }else{
                        if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                            UMSocialShareResponse *resp = data;
                            //分享结果消息
                            UMSocialLogInfo(@"response message is %@",resp.message);
                            //第三方原始返回的数据
                            UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                            
                        }else{
                            UMSocialLogInfo(@"response data is %@",data);
                        }
                    }
                }];
                
            };
//            PushViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"pushViewController"];
//            [self.navigationController pushViewController:controller animated:YES];
//        }else if (indexPath.row == 1) {
        }else if (indexPath.row == 1){
            
            FeelBackViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"feelBackViewController"];;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if (indexPath.row == 2){
            
            SecurityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"securityViewController"];
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if (indexPath.row == 3){
            
            NSString *message = [self folderSizeAtPath];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除缓存" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
                NSString *path = [paths lastObject];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                if ([fileManager fileExistsAtPath:path]) {
                    NSArray *childrenFiles = [fileManager subpathsAtPath:path];
                    for (NSString *fileName in childrenFiles) {
                        // 拼接路径
                        NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
                        // 将文件删除
                        [fileManager removeItemAtPath:absolutePath error:nil];
                    }
                }
                //SDWebImage的清除功能
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{}];
                [[SDImageCache sharedImageCache] clearMemory];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            [alertController addAction:action];
            [alertController addAction:cancel];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else if (indexPath.row == 4){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出登陆" message:@"您确定退出当前帐号？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UserDefaultsSynchronize(@"", @"login");
                UserDefaultsSynchronize(@"1", @"openjpush");
                UserDefaultsSynchronize(@"1", @"opensound");
                UserDefaultsSynchronize(@"1", @"openshock");
                UserDefaultsSynchronize(@"1", @"opensettime");
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:cancle];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

@end
