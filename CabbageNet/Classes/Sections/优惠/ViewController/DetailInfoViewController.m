//
//  DetailInfoViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "AllCommentViewController.h"
#import "DetailImageCell.h"
#import "DetailInfoCell.h"
#import "DetailTitleCell.h"
#import "DetailCommentCell.h"
#import "DiscountDetailModel.h"
#import "AttributedStringCell.h"
#import "GoLinkWebViewController.h"
#import <UShareUI/UShareUI.h>
#import "LoginViewController.h"
#import "DiscountPrise.h"
#import "ShareView.h"
#import "DetailSignCell.h"
#import "SignSearchViewController.h"

@interface DetailInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentLeft;
@property (weak, nonatomic) IBOutlet UIButton *urlBtn;
@property (nonatomic , strong)NSMutableArray *commentArray;
@property (nonatomic , strong)DiscountDetailModel *model;
@property (nonatomic, strong) UserInfoModel *uModel;
@property (nonatomic , strong)ShareView *shareView;

@end

@implementation DetailInfoViewController{
    CGFloat _webViewHeight;
    UIImage *_currImage;
    CGFloat _rowHeight;
    NSDictionary *_adDic;
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

- (UserInfoModel *)uModel{
    return [UserInfoModel sharedUserData];
}

- (DiscountDetailModel *)model{
    if (!_model) {
        _model = [[DiscountDetailModel alloc] init];
    }
    return _model;
}

- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

- (BOOL)isLogin{
    if ([UserDefaultsGetSynchronize(@"login") isEqualToString:@"10001"]) return YES;
    
    LoginViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type.length) {
        [self.commentBtn setImage:[UIImage new] forState:UIControlStateNormal];
        [self.commentBtn setTitle:@"" forState:UIControlStateNormal];
        self.commentBtn.hidden = YES;
        self.commentLeft.constant = 0;
    }
    /*
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
    [rightBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 0);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
   */
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"分享"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    rightBtn.imageInsets = UIEdgeInsetsMake(0, 30, 15, 0);
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    self.urlBtn.backgroundColor = mAppMainColor;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    [self requestData];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"返回"]  forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    _adDic = [NSDictionary dictionary];
}

- (void)backBtnClick{
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 分享
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
        NSString *title = weakSelf.model.title;
        if (platformType == UMSocialPlatformType_Qzone || platformType == UMSocialPlatformType_WechatTimeLine){
            title = weakSelf.model.title;
        }
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:weakSelf.model.price thumImage:img_url];
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

#pragma mark -- 请求商品详情数据
- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"shopitem", @"api");
    setDickeyobj(infoDic, self.shopid, @"shopid");
    if (self.type.length) setDickeyobj(infoDic, self.type, @"type")
    if (self.uModel.userid.length) setDickeyobj(infoDic, self.uModel.userid, @"userid");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {

        if (SUCCESS_REQUEST(result)) {
            
            [self.model mj_setKeyValues:result[@"data"]];
            self.praiseBtn.selected = [DiscountPrise selectedDiscountID:self.shopid andUser:self.uModel.userid andIsDiscount:YES];
            if (self.praiseBtn.selected) {
                [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld", self.model.zan] forState:UIControlStateSelected];
            }else{
                [self.praiseBtn setTitle:[NSString stringWithFormat:@"%ld", self.model.zan] forState:UIControlStateNormal];
            }
            [self.collectionBtn setTitle:[NSString stringWithFormat:@"%ld", self.model.likes] forState:UIControlStateNormal];
            [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",self.model.comments] forState:UIControlStateNormal];
            
            if (self.model.mylike) {
                [self.collectionBtn setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
                self.collectionBtn.selected = YES;
            }else{
                [self.collectionBtn setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
                self.collectionBtn.selected = NO;
            }

            [self requestADdata];
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [self.myTableView.mj_header endRefreshing];
        NSLog(@"%@",erro);
    } showHUD:nil];

}

#pragma mark -- 广告
-(void)requestADdata{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"adb", @"api");
    setDickeyobj(infoDic, @"20", @"adid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        if (SUCCESS_REQUEST(result)) {
            NSArray *array = result[@"data"];
            _adDic = array.firstObject;
        }else{
        //    [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        [self.myTableView reloadData];
        [self.myTableView.mj_header endRefreshing];
    } failure:^(NSError *erro) {
        [self.myTableView.mj_header endRefreshing];
        NSLog(@"%@",erro);
    } showHUD:nil];
}


- (NSAttributedString *)stringToAttributedString:(NSString *)string{
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}

#pragma mark -- UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([_adDic[@"content"] length]) return 4;
    else return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        
        DetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailInfoCell"];
        cell.model = self.model;
        return cell;
        
    }else if (indexPath.section == 1){
        
        AttributedStringCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attributedStringCell"];
        cell.htmlString = self.model.content;
        cell.block = ^(CGFloat webViewHeight){

            if (_webViewHeight != webViewHeight) {
                _webViewHeight = webViewHeight;
                NSLog(@"XXXXXX");
                [tableView reloadData];
            }
        };
        cell.urlBlock = ^(NSString *url) {
            if([url rangeOfString:@"taobao.com"].location != NSNotFound || [url rangeOfString:@"tmall.com"].location != NSNotFound){
                NSString *taobao_schema = url;
                if([taobao_schema rangeOfString:@"https"].location != NSNotFound){
                    taobao_schema = [taobao_schema stringByReplacingOccurrencesOfString:@"https" withString:@"taobao"];
                }
                if([taobao_schema rangeOfString:@"http"].location != NSNotFound){
                    taobao_schema = [taobao_schema stringByReplacingOccurrencesOfString:@"http" withString:@"taobao"];
                }
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:(taobao_schema)]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(taobao_schema)]];
                }
                else{
                    GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
                    controller.webUrl = url;
                    controller.title = @"返回白菜哦";//model.go_link[@"name"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
            else{
            GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
            controller.webUrl = url;
            controller.title = @"返回白菜哦";
            [self.navigationController pushViewController:controller animated:YES];
            }
        };
        return cell;
        
    }else if (indexPath.section == 2){
        DetailSignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailSignCell"];
        NSMutableArray *signArr = [NSMutableArray arrayWithArray:[self.model.tag_cache componentsSeparatedByString:@"|"]];
        for (int i = (int)signArr.count - 1; i >= 0; i --) {
            NSString *string = signArr[i];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (!string.length) {
                [signArr removeObjectAtIndex:i];
            }
        }
        [cell.origBtn setTitle:self.model.orig[@"name"] forState:UIControlStateNormal];
        cell.btnWidth.constant = [self.model.orig[@"name"] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width + 20;
        cell.backHeight = ^(CGFloat height) {
            if (_rowHeight != height) {
                _rowHeight = height;
                NSLog(@"ccccccccc");
//                [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView reloadData];
            }
        };
        cell.array = signArr;
        if (self.type.length) cell.xinagguanLabel.text = @"";
        cell.btnBlock = ^{
            SignSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signSearchViewController"];
            controller.title = self.model.orig[@"name"];
            controller.orig_id = self.model.orig[@"id"];
            controller.block = ^(NSString *shopid) {
                self.shopid = shopid;
                [self.myTableView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:controller animated:YES];
        };
        cell.block = ^(NSInteger tag) {
            SignSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signSearchViewController"];
            controller.title = signArr[tag];
            controller.type = 1;
            controller.block = ^(NSString *shopid) {
                self.shopid = shopid;
                [self.myTableView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:controller animated:YES];
            
        };
        return cell;
    }else{
        DetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailImageCell"];
        if (_currImage) {
            cell.fillImageView.image = _currImage;
        }else {
            [cell.fillImageView sd_setImageWithURL:_adDic[@"content"] placeholderImage:[UIImage imageNamed:@"正方形占位图"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error && !_currImage) {
                    _currImage = image;
                    NSLog(@"=============");
//                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [tableView reloadData];
                }
            }];
        }
        return cell;
    }
//    else if (indexPath.section == 2){
//        if (indexPath.row == 0){
//            
//            DetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailTitleCell"];
//            return cell;
//        }
//    }
//    DetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCommentCell"];
//    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 1){
        CGFloat height = Max(0.01, _webViewHeight);
        return height + 10;
    }else if (indexPath.section == 3){
        if (_currImage) {
            CGFloat height = MAX(0.01,mScreenWidth*_currImage.size.height/_currImage.size.width);
            return height;
        }
        return mScreenWidth;
    }
    CGFloat height = MAX(0.01, _rowHeight);
    if (self.type.length) return height + 60;
    return height + 100;
//    else if (indexPath.section == 2){
//        if (indexPath.row == 0) return 20;
//    }
//        //计算文字高度和图片数量
//        return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3 && _adDic[@"url"]) {
        GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
        controller.webUrl = _adDic[@"url"];
        controller.title = @"返回白菜哦";
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIButton *btn = [[UIButton alloc] init];
//    if (section == 2) {
//        [btn setTitle:@"点击查看所有评论" forState:UIControlStateNormal];
//        [btn setTitleColor:toPCcolor(@"666666") forState:UIControlStateNormal];
//        
//        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [btn addTarget:self action:@selector(seeallComment) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return btn;
//}

- (void)seeallComment{
    
    AllCommentViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"allCommentViewController"];
    controller.shopid = self.shopid;
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

//点赞
- (IBAction)praiseBtnClick:(UIButton *)sender {
    
    if ([self isLogin]) {
        if (sender.selected) {
            [DiscountPrise deletedDiscountID:self.shopid andUser:self.uModel.userid andIsDiscount:YES];
            sender.selected = NO;
            self.model.zan -= 1;
            [sender setTitle:[NSString stringWithFormat:@"%ld", self.model.zan] forState:UIControlStateNormal];
            return;
        }
        NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
        setDickeyobj(infoDic, @"zan", @"api");
        setDickeyobj(infoDic, self.shopid, @"id");
        setDickeyobj(infoDic, @"1", @"type");
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        setDickeyobj(param, infoDic, @"reqBody");
        
        [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
            
            if (SUCCESS_REQUEST(result)) {
                
                sender.selected = [DiscountPrise insertDiscountID:self.shopid andUser:self.uModel.userid andIsDiscount:YES];
                self.model.zan += 1;
                [sender setTitle:[NSString stringWithFormat:@"%ld", self.model.zan] forState:UIControlStateSelected];
                
                NSLog(@"%@----%@", result[@"data"], result[@"msg"]);
            }
            
            
        } failure:^(NSError *erro) {
            NSLog(@"%@", erro);
        } showHUD:nil];
    }
}

//评论
- (IBAction)commentBtnClick:(UIButton *)sender {
    
    if ([self isLogin]) {
        AllCommentViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"allCommentViewController"];
        controller.shopid = self.shopid;
        controller.xid = @"1";
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//收藏
- (IBAction)collectionBtnClick:(UIButton *)sender {
    
    if ([self isLogin]) {
        NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
        setDickeyobj(infoDic, @"setlikes", @"api");
        setDickeyobj(infoDic, self.uModel.userid, @"userid");
        setDickeyobj(infoDic, self.shopid, @"id");
        setDickeyobj(infoDic, @"1", @"xid");
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        setDickeyobj(param, infoDic, @"reqBody");
        [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
            
            NSLog(@"%@------%@", result[@"data"], result[@"msg"]);
            if (SUCCESS_REQUEST(result)) {
                if ([sender isSelected]) {
                    [sender setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
                    sender.selected = NO;
                    self.model.likes--;
                    [sender setTitle:[NSString stringWithFormat:@"%ld", self.model.likes] forState:UIControlStateNormal];
                    
                }
                else{
                    [sender setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
                    sender.selected = YES;
                    self.model.likes++;
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

- (IBAction)goToLinkBtnClick {
    if([self.model.go_link[@"link"] rangeOfString:@"taobao.com"].location != NSNotFound || [self.model.go_link[@"link"] rangeOfString:@"tmall.com"].location != NSNotFound){
        NSString *taobao_schema = self.model.go_link[@"link"];
        if([taobao_schema rangeOfString:@"https"].location != NSNotFound){
            taobao_schema = [taobao_schema stringByReplacingOccurrencesOfString:@"https" withString:@"taobao"];
        }
        if([taobao_schema rangeOfString:@"http"].location != NSNotFound){
            taobao_schema = [taobao_schema stringByReplacingOccurrencesOfString:@"http" withString:@"taobao"];
        }
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:(taobao_schema)]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(taobao_schema)]];
        }
        else{
            GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
            controller.webUrl = self.model.go_link[@"link"];
            controller.title = @"返回白菜哦";//model.go_link[@"name"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    else{
    
    GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
    controller.webUrl = self.model.go_link[@"link"];
    controller.title = @"返回白菜哦";
    [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
