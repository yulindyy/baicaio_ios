//
//  OriginalDetailViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "OriginalDetailViewController.h"
#import "OriginalDetailInfoCell.h"
#import "OriginalDetailTextCell.h"
#import "OriginalDetailImageCell.h"
#import "OriginalDetailModel.h"
#import "GoLinkWebViewController.h"
#import "AllCommentViewController.h"
#import "LoginViewController.h"
#import "DiscountPrise.h"
#import <UShareUI/UShareUI.h>
#import "ShareView.h"

@interface OriginalDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)OriginalDetailModel *model;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *browseBtn;
@property (nonatomic , strong)ShareView *shareView;

@end

@implementation OriginalDetailViewController{
    UIImage *_curimage;
    CGFloat _webViewHeight;
}

- (ShareView *)shareView{
    if (!_shareView) {
        _shareView = [ShareView getShareView];
        _shareView.frame = CGRectMake(0, mScreenHeight, mScreenWidth, mScreenHeight);
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:_shareView];
    }
    return _shareView;
}

- (OriginalDetailModel *)model{
    if (!_model){
        _model = [[OriginalDetailModel alloc] init];
    }
    return _model;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _curimage = [UIImage imageNamed:@"正方形占位图"];
    _webViewHeight = 0.01;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"分享"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    rightBtn.imageInsets = UIEdgeInsetsMake(15, 30, 15, 0);
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    
        [self requestData];
    }];
    [self requestData];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"返回"]  forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backBtnClick{
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)rightBtnClick{
    
    self.shareView.ishidenView = NO;
    __weak typeof(self)weakSelf = self;
    self.shareView.block = ^(NSInteger tag) {
        weakSelf.shareView.ishidenView = YES;

        if (tag == 6) {
            UIPasteboard *pab = [UIPasteboard generalPasteboard];
            pab.string = weakSelf.model.fenxiang;
            if (pab.string.length) {
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
        NSString *img_url = @"";
        if ([weakSelf.model.img hasPrefix:@"http://"]) {
            img_url = weakSelf.model.img;
        }else {
            img_url = [NSString stringWithFormat:@"http://www.baicaio.com%@",weakSelf.model.img];
        }
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"白菜哦" descr:weakSelf.model.title thumImage:img_url];
        //设置网页地址
        
        shareObject.webpageUrl = weakSelf.model.fenxiang;
        
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
}

- (void)requestData{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"articleitem", @"api");
    setDickeyobj(infoDic, self.articleid, @"articleid");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    if (model.userid.length) setDickeyobj(infoDic, model.userid, @"userid");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_ORIGINAL_API WithParam:param withMethod:POST success:^(id result) {
        
        [self.myTableView.mj_header endRefreshing];
        if (SUCCESS_REQUEST(result)) {
            
            [self.model mj_setKeyValues:result[@"data"]];
            
            self.self.browseBtn.selected = [DiscountPrise selectedDiscountID:self.articleid andUser:model.userid andIsDiscount:NO];
            if (self.self.browseBtn.selected) {
                [self.self.browseBtn setTitle:[NSString stringWithFormat:@"%ld", self.model.zan] forState:UIControlStateSelected];
            }else{
                [self.self.browseBtn setTitle:[NSString stringWithFormat:@"%ld", self.model.zan] forState:UIControlStateNormal];
            }
            [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",self.model.comments] forState:UIControlStateNormal];
            [self.collectionBtn setTitle:[NSString stringWithFormat:@"%ld",self.model.likes] forState:UIControlStateNormal];
            if (self.model.mylike) {
                [self.collectionBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
                self.collectionBtn.selected = YES;

            }else{
                [self.collectionBtn setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
                self.collectionBtn.selected = NO;

            }
            [self.myTableView reloadData];
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
        
    } failure:^(NSError *erro) {
        [self.myTableView.mj_header endRefreshing];
        NSLog(@"%@",erro);
    } showHUD:nil];
}

- (IBAction)browseBtnClick:(UIButton *)sender {
    
    if ([self isLogin]) {
        if (sender.selected) {
            UserInfoModel *userinfoModel = [UserInfoModel sharedUserData];
            [DiscountPrise deletedDiscountID:self.articleid andUser:userinfoModel.userid andIsDiscount:NO];
            sender.selected = NO;
            self.model.zan -= 1;
            [sender setTitle:[NSString stringWithFormat:@"%ld", self.model.zan] forState:UIControlStateNormal];
            return;
        }
        NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
        setDickeyobj(infoDic, @"zan", @"api");
        setDickeyobj(infoDic, self.articleid, @"id");
        setDickeyobj(infoDic, @"2", @"type");
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        setDickeyobj(param, infoDic, @"reqBody");
        
        [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
            
            if (SUCCESS_REQUEST(result)) {
                UserInfoModel *userinfoModel = [UserInfoModel sharedUserData];
                sender.selected = [DiscountPrise insertDiscountID:self.articleid andUser:userinfoModel.userid andIsDiscount:NO];
                self.model.zan += 1;
                [sender setTitle:[NSString stringWithFormat:@"%ld", self.model.zan] forState:UIControlStateSelected];
                NSLog(@"%@----%@", result[@"data"], result[@"msg"]);
            }else{
                [MBProgressHUD showError:result[@"msg"] toView:nil];
            }
            
            
        } failure:^(NSError *erro) {
            NSLog(@"%@", erro);
        } showHUD:nil];
    }
}

- (IBAction)commentBtnClick:(UIButton *)sender {
    if ([self isLogin]) {
        AllCommentViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"allCommentViewController"];
        controller.shopid = self.articleid;
        controller.xid = @"3";
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)collectionBtnClick:(UIButton *)sender {
    if ([self isLogin]) {
        NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
        setDickeyobj(infoDic, @"setlikes", @"api");
        UserInfoModel *model = [UserInfoModel sharedUserData];
        setDickeyobj(infoDic, model.userid, @"userid");
        setDickeyobj(infoDic, self.articleid, @"id");
        setDickeyobj(infoDic, @"3", @"xid");
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        setDickeyobj(param, infoDic, @"reqBody");
        [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
            
            NSLog(@"%@------%@", result[@"data"], result[@"msg"]);
            if (SUCCESS_REQUEST(result)) {
                
                if ([sender isSelected]) {
                    [sender setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
                    sender.selected = NO;
                    self.model.likes--;
                    self.model.mylike = NO;
                    [sender setTitle:[NSString stringWithFormat:@"%ld", self.model.likes] forState:UIControlStateNormal];
                    
                }
                else{
                    [sender setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
                    sender.selected = YES;
                    self.model.likes++;
                    self.model.mylike = YES;
                    [sender setTitle:[NSString stringWithFormat:@"%ld", self.model.likes] forState:UIControlStateSelected];
                }

            }else{
                [MBProgressHUD showError:result[@"msg"] toView:nil];
            }
        } failure:^(NSError *erro) {
            NSLog(@"%@", erro);
        } showHUD:nil];
    }
}

- (BOOL)isLogin{
    if ([UserDefaultsGetSynchronize(@"login") isEqualToString:@"10001"]) return YES;
    
    LoginViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
    
}


- (NSAttributedString *)stringToAttributedString:(NSString *)string{
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

#pragma  mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        OriginalDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"originalDetailInfoCell"];
        cell.model = self.model;
        return cell;
    }else if (indexPath.section == 1){
        OriginalDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"originalDetailTextCell"];
        cell.htmlString = self.model.info;
        cell.block = ^(CGFloat webViewHeight) {

            if (_webViewHeight != webViewHeight) {
                _webViewHeight = webViewHeight;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

            }
        };
        cell.urlBlock = ^(NSString *url) {
            GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
            controller.webUrl = url;
            controller.title = @"返回白菜哦";
            [self.navigationController pushViewController:controller animated:YES];
        };
        return cell;
    }
    
    OriginalDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"originalDetailImageCell"];
    [cell.fillImageView sd_setImageWithURL:[NSURL URLWithString:self.model.img] placeholderImage:[UIImage imageNamed:@"正方形占位图"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        if (!error) _curimage = image;
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1){

        return _webViewHeight;
    }else if (indexPath.section == 2){

        return mScreenWidth * _curimage.size.height / _curimage.size.width;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

@end
