//
//  SendArticleViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "SendArticleViewController.h"
#import "TopBtnView.h"
#import "ArticleClassCell.h"
#import "ArticleTitleCell.h"
#import "ArticleTextCell.h"
#import "BrokeURLCell.h"
#import "BrokeImageCell.h"
#import "BrokeTitleCell.h"
#import "BrokeReasonCell.h"
#import "SendBrockUrlInfoModel.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"

@interface SendArticleViewController ()<UITableViewDataSource,UITableViewDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic , strong)TopBtnView *topBtnView;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)SendBrockUrlInfoModel *urlInfoModel;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation SendArticleViewController{
    CGFloat _imageHeight;
    NSMutableArray *_imagesIDArr;
    NSMutableArray *_imagesArr;
    BOOL _notUpload;
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

- (SendBrockUrlInfoModel *)urlInfoModel{
    if (!_urlInfoModel) {
        _urlInfoModel = [[SendBrockUrlInfoModel alloc] init];
    }
    return _urlInfoModel;
}

- (TopBtnView *)topBtnView{
    
    if (!_topBtnView) {
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, -100, mScreenWidth, 44) titleBtnArr:@[@"爆料",@"文章"]];
        
        __weak typeof(self)weakSelf = self;
        _topBtnView.block = ^(NSInteger tag){
            if (tag == 1) {
                weakSelf.articleOrBroke = IS_BROKE;
                [weakSelf.sendBtn setTitle:@"发表爆料" forState:UIControlStateNormal];
                [weakSelf.cancleBtn setTitle:@"取消爆料" forState:UIControlStateNormal];
            }else{
                weakSelf.articleOrBroke = IS_ARTICLE;
                [weakSelf.sendBtn setTitle:@"发表文章" forState:UIControlStateNormal];
                [weakSelf.cancleBtn setTitle:@"取消发表" forState:UIControlStateNormal];
            }
            [weakSelf.myTableView reloadData];
        };
        if (self.articleOrBroke == IS_ARTICLE)
            [_topBtnView btnActionChange:2];
        else
            [_topBtnView btnActionChange:1];
    }
    return _topBtnView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.articleOrBroke == IS_BROKE && !_notUpload){
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        NSLog(@"%@",pab.string);
        if (pab.string && [self urlValidation:pab.string]) {
            BrokeURLCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.textView.text = pab.string;
            cell.placeholderLabel.text = @"";
            [self requestUrlInfo:pab.string];
        }
    }
    _notUpload = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview: self.topBtnView];
    self.sendBtn.backgroundColor = mAppMainColor;
    if (self.articleOrBroke == IS_ARTICLE){
        self.title = @"发表文章";
    }else{
        self.title = @"发布爆料";
    }
    _imagesIDArr = [NSMutableArray array];
    _imagesArr = [NSMutableArray array];
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
//    
}

//- (void)rightBtnClick{
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (IBAction)cancleBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendImage{
    [MBProgressHUD showMessag:@"加载中..." toView:self.view];
    
    if (!_imagesArr.count){
        [self sendBrock:nil];
    }
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"uploadimg1", @"api");
//    UserInfoModel *model = [UserInfoModel sharedUserData];
    NSLog(@"---%ld",_imagesArr.count);
    UIImage *image = _imagesArr.firstObject;
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSString *encodedImageStr = [data base64Encoding];
    
    setDickeyobj(infoDic, encodedImageStr, @"base64");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        if (SUCCESS_REQUEST(result)) {
            NSLog(@"%@---%@",result[@"data"],result[@"msg"]);
            NSDictionary *dic = @{@"url":result[@"data"]};
            [self sendBrock:[NSArray arrayWithObject:dic]];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",erro);
    } showHUD:nil];
}

- (void)sendBrock:(NSArray *)imageDicArr{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"publish_item", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    setDickeyobj(infoDic, self.urlInfoModel.url, @"url");
    setDickeyobj(infoDic, self.urlInfoModel.title, @"title");
    setDickeyobj(infoDic, self.urlInfoModel.content, @"content");
    if (self.urlInfoModel.price){
        setDickeyobj(infoDic, self.urlInfoModel.price, @"price");
    }else{
        setDickeyobj(infoDic, @"", @"price");
    }
    if (imageDicArr.count) {
        setDickeyobj(infoDic, imageDicArr, @"imgs");
    }else {
        setDickeyobj(infoDic, self.urlInfoModel.imgs, @"imgs");
    }
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS_REQUEST(result)) {
            
            NSLog(@"%@---%@",result[@"data"],result[@"msg"]);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:result[@"data"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",erro);
    } showHUD:nil];
}

- (IBAction)sendBtnClick {
    
    if (!self.urlInfoModel.url){
        [MBProgressHUD showError:@"请粘贴url" toView:nil];
        return;
    }
    
    if (!self.urlInfoModel.title.length){
        [MBProgressHUD showError:@"请输入标题" toView:nil];
        return;
    }
    
    if (!self.urlInfoModel.content){
         [MBProgressHUD showError:@"请输入推荐理由" toView:nil];
        return;
    }
    
    
    if (!self.urlInfoModel.imgs.count && !_imagesArr.count) {
        [MBProgressHUD showError:@"请选择图片" toView:self.view];
        return;
    }
    [self sendImage];
}

- (void)requestUrlInfo:(NSString *)url{
    [_imagesArr removeAllObjects];
    [_imagesIDArr removeAllObjects];
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"fetch_item", @"api");
    setDickeyobj(infoDic, url, @"url");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [MBProgressHUD showMessag:@"加载中..." toView:self.view];
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS_REQUEST(result)) {
            
            [self.urlInfoModel mj_setKeyValues:result[@"data"]];
            [self.myTableView reloadData];
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",erro);
    } showHUD:nil];

}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.articleOrBroke == IS_ARTICLE){
        return 3;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.articleOrBroke == IS_ARTICLE){
        return 1;
    }
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.articleOrBroke == IS_ARTICLE){
        if (indexPath.section == 0){
            ArticleClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleClassCell"];
            return cell;
        }else if (indexPath.section == 1){
            ArticleTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleTitleCell"];
            return cell;
        }else if (indexPath.section == 2){
            ArticleTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleTextCell"];
            cell.textViewChangeBlock = ^(NSString *text, CGFloat height){
//                textCellHeight = height;
//                cellText = text;
                NSLog(@"%@---",text);
                
            };

            return cell;
        }
    }
    if (indexPath.section == 0){
        BrokeURLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brokeURLCell"];
        cell.contentView.backgroundColor = tableView.backgroundColor;
        cell.block = ^(NSString *urlStr) {
            NSLog(@"%@=======",urlStr);
            [self requestUrlInfo:urlStr];
        };
        return cell;
    }else if (indexPath.section == 1){
        BrokeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brokeImageCell"];
        cell.contentView.backgroundColor = tableView.backgroundColor;
        if (_imagesArr.count) {
            UIImage *image =  _imagesArr.lastObject;
            cell.fillImageView.image = image;
            CGFloat cellHeight = (mScreenWidth - 20) / image.size.width * image.size.height;
            if (_imageHeight != cellHeight) {
                _imageHeight = cellHeight;
                [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        }else if (self.urlInfoModel.img.length){
            [cell.fillImageView sd_setImageWithURL:[NSURL URLWithString:self.urlInfoModel.img] placeholderImage:[UIImage imageNamed:@"占位图片21"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    CGFloat cellHeight = (mScreenWidth - 20) / image.size.width * image.size.height;
                    if (_imageHeight != cellHeight) {
                        _imageHeight = cellHeight;
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
            }];
        }
        return cell;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            BrokeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brokeTitleCell"];
            cell.contentView.backgroundColor = tableView.backgroundColor;
            cell.nameField.text = self.urlInfoModel.title;
            cell.block = ^(NSString *string) {
                self.urlInfoModel.title = string;
            };
            return cell;
        }else if (indexPath.row == 1){
            BrokeReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"brokeReasonCell"];
            cell.contentView.backgroundColor = tableView.backgroundColor;
            cell.block = ^(NSString *reason) {
                self.urlInfoModel.content = reason;
            };
            return cell;
        }
    }
        
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.articleOrBroke == IS_ARTICLE){
        if (indexPath.section == 0){
            return 30;
        }else if (indexPath.section == 1){
            return 44;
        }else if (indexPath.section == 2){
            return 240;//计算输入文本的高度
//            return MAX(44, textCellHeight);
        }
    }
    if (indexPath.section == 0){
        return 60;//计算URL高度
    }else if (indexPath.section == 1){
        if (_imageHeight != 0) return _imageHeight;
        return (mScreenWidth - 20)/2;//计算Image高度
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return  80;
        }else if (indexPath.row == 1){
            return 160;//计算输入文本高度
        }
    }

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.articleOrBroke == IS_ARTICLE){
        return 10;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.articleOrBroke == IS_ARTICLE){
        return 5;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && self.articleOrBroke == IS_BROKE){
        _notUpload = YES;
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
    }
}

- (void)reloadSelImage{
    
    BrokeImageCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.contentView.backgroundColor = self.myTableView.backgroundColor;
    
    if (_imagesArr.count){
        UIImage *image =  _imagesArr.lastObject;
        cell.fillImageView.image = image;
        CGFloat cellHeight = (mScreenWidth - 20) / image.size.width * image.size.height;
        if (_imageHeight != cellHeight) {
            _imageHeight = cellHeight;
            [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark -- 相册选择完成处理
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    
    [_imagesArr removeAllObjects];
    [_imagesArr addObjectsFromArray:photos];
    
    [_imagesIDArr removeAllObjects];
    [_imagesIDArr addObjectsFromArray:assets];
    
    [self reloadSelImage];
}
#pragma mark --将相机返回的照片添加得到数组
- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_imagesArr removeAllObjects];
    [_imagesIDArr removeAllObjects];
    [_imagesIDArr addObject:asset];
    [_imagesArr addObject:image];
    [self reloadSelImage];
}

#pragma mark - 打开相册
- (void)pushImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
//    imagePickerVc.selectedAssets = _imagesIDArr; // 目前已经选中的图片数组    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = NO;
    
#pragma mark - 到这里为止
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark -- 打开相机拍照
- (void)takePhoto{
    if (_imagesIDArr.count > 2) {
        [MBProgressHUD showError:@"选择数量已达到限制" toView:nil];
        return;
    }
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
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
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = sourceType;
            if(iOS8Later) {
                self.imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    }
}

#pragma mark --相机拍照返回处理
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = NO;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
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
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

/**
 * 网址正则验证 1或者2使用哪个都可以
 *
 *  @param string 要验证的字符串
 *
 *  @return 返回值类型为BOOL
 */
- (BOOL)urlValidation:(NSString *)string {
    //    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    // 正则2
    regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regulaStr options:0 error:nil];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch = [string substringWithRange:match.range];
        return YES;
    }
    return NO;
}

@end
