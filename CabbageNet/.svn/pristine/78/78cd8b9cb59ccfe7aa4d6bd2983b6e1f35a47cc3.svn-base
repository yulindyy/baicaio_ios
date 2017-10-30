//
//  EwenTextView.m
//  0621TextViewDemo
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EwenTextView.h"
#import "Masonry.h"
#import "LLGifImageView.h"
#import "LLGifView.h"
#import "BCTextAttachment.h"

#define kScreenBounds ([[UIScreen mainScreen] bounds])
#define kScreenwidth (kScreenBounds.size.width)
#define kScreenheight (kScreenBounds.size.height)
#define UIColorRGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]

@interface EwenTextView()<UITextViewDelegate,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    BOOL statusTextView;//当文字大于限定高度之后的状态
    NSString *placeholderText;//设置占位符的文字
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *emotionButton;
@property (nonatomic, strong) UIView *emotionview;
@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) NSArray *cyArr;
@property (nonatomic , strong) NSArray *bmArr;
@property (nonatomic , strong) NSArray *ggArr;

@end


@implementation EwenTextView{
    UIButton *_cyBtn;
    UIButton *_bzBtn;
    UIButton *_ggBtn;
    NSMutableString *_resultString;
}
static NSString *const cellId = @"cellId";

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
        _resultString = [NSMutableString string];
    }
    
    /**
     点击 空白区域取消
     */
    UITapGestureRecognizer *centerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerTapClick)];
    [self addGestureRecognizer:centerTap];
    return self;
}

- (void)createUI{
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(5);
        make.bottom.mas_equalTo(-6);
        make.width.mas_equalTo(kScreenwidth-102);
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(39);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(50);
    }];
    
    [self.emotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.right.mas_equalTo(-60);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(32);
    }];

//    [self requestData];
}

//暴露的方法
- (void)setPlaceholderText:(NSString *)text{
    placeholderText = text;
    self.placeholderLabel.text = placeholderText;
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    self.frame = kScreenBounds;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (self.textView.text.length == 0) {
        self.commentPersonal.frame = CGRectMake(0, kScreenheight-height-108 - 20, mScreenWidth, 20);
        self.backGroundView.frame = CGRectMake(0, kScreenheight-height-108, kScreenwidth, 44);
    }else{
        CGRect rect = CGRectMake(0, kScreenheight - self.backGroundView.frame.size.height-height - 64, kScreenwidth, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
        self.commentPersonal.frame = CGRectMake(rect.origin.x, rect.origin.y - 20, rect.size.width, 20);
    }
    if (self.commentPersonal.text.length) self.commentPersonal.hidden = NO;
    else self.commentPersonal.hidden = YES;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    self.commentPersonal.text = nil;
    self.commentPersonal.hidden = YES;
    if (self.textView.text.length == 0) {
        self.backGroundView.frame = CGRectMake(0, 0, kScreenwidth, 49);
        self.commentPersonal.frame = CGRectMake(0, 0, kScreenwidth, 20);
        self.frame = CGRectMake(0, kScreenheight-108, kScreenwidth, 49);
    }else{
        CGRect rect = CGRectMake(0, 0, kScreenwidth, self.backGroundView.frame.size.height);
        self.backGroundView.frame = rect;
        self.commentPersonal.frame = CGRectMake(0, 0, kScreenwidth, 20);
        self.frame = CGRectMake(0, kScreenheight - rect.size.height-64, kScreenwidth, self.backGroundView.frame.size.height);
    }
}

- (void)centerTapClick{
    [self.textView resignFirstResponder];
}


//- (NSString *)disable_emoji:(NSString *)text{
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
//    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
//                                                               options:0
//                                                                 range:NSMakeRange(0, [text length])
//                                                          withTemplate:@""];
//    return modifiedString;
//}
#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    /**
     *  设置占位符
     */
    if (textView.text.length == 0) {
        self.placeholderLabel.text = placeholderText;
        self.sendButton.userInteractionEnabled = NO;
    }else{
        self.placeholderLabel.text = @"";
        self.sendButton.userInteractionEnabled = YES;
    }
    
    //---- 计算高度 ---- //
    CGSize size = CGSizeMake(kScreenwidth-65, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
//    CGFloat curheight = textView.attributedText.size.height;
    CGFloat y = CGRectGetMaxY(self.backGroundView.frame);
    if (curheight < 19.094) {
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - 44, kScreenwidth, 44);
        self.commentPersonal.frame = CGRectMake(0, y - 64, kScreenwidth, 20);
    }else if(curheight < MaxTextViewHeight){
        statusTextView = NO;
        self.backGroundView.frame = CGRectMake(0, y - textView.contentSize.height-10, kScreenwidth,textView.contentSize.height+10);
        self.commentPersonal.frame = CGRectMake(0, y - textView.contentSize.height-30, kScreenwidth,20);
    }else{
        statusTextView = YES;
        return;
    }
    if (self.commentPersonal.text.length) self.commentPersonal.hidden = NO;
    else self.commentPersonal.hidden = YES;
}

#pragma  mark -- 发送事件
- (void)sendClick:(UIButton *)sender{
    NSLog(@"%@",self.textView.text);
    if (self.EwenTextViewBlock) {
        
        self.EwenTextViewBlock([self emotionText]);//self.textView.text
    }
    [self.textView endEditing:YES];
    //---- 发送成功之后清空 ------//
    self.textView.text = nil;
    self.placeholderLabel.text = placeholderText;
    [self.sendButton setBackgroundColor:mAppMainColor];
    self.sendButton.userInteractionEnabled = NO;
    self.frame = CGRectMake(0, kScreenheight-108, kScreenwidth, 44);
    self.backGroundView.frame = CGRectMake(0, 0, kScreenwidth, 44);
    self.commentPersonal.frame = CGRectMake(0, 0, kScreenwidth, 20);
    self.commentPersonal.text = nil;
    self.commentPersonal.hidden =YES;
}

// 获取表情字符串
- (NSString *)emotionText
{
    
    NSMutableString *strM = [NSMutableString string];
    
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *str = nil;
        
        BCTextAttachment *attachment = attrs[@"NSAttachment"];
        
        if (attachment) { // 表情
            str = attachment.emotionStr;
            [strM appendString:str];
        } else { // 文字
            str = [self.textView.attributedText.string substringWithRange:range];
            [strM appendString:str];
        }
        
    }];
    return strM;
}

#pragma mark -- 表情键盘事件
- (void)emotionClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.textView.inputView = self.emotionview;
    }else{
        self.textView.inputView = nil;
    }
    [self.textView resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

#pragma mark --- 懒加载控件
- (UILabel *)commentPersonal{
    if (!_commentPersonal) {
        _commentPersonal = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 20)];
        _commentPersonal.textColor = toPCcolor(@"666666");
        _commentPersonal.backgroundColor = [UIColor whiteColor];
        _commentPersonal.font = [UIFont systemFontOfSize:14];
        [self addSubview:_commentPersonal];
    }
    return _commentPersonal;
}

- (UIView *)backGroundView{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenwidth, 44)];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backGroundView];
    }
    return _backGroundView;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = [UIColor grayColor].CGColor;
        [self.backGroundView addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)placeholderLabel{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc]init];
        _placeholderLabel.font = [UIFont systemFontOfSize:14];
        _placeholderLabel.textColor = [UIColor grayColor];
        [self.backGroundView addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc]init];
        [_sendButton setBackgroundColor:mAppMainColor];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _sendButton.userInteractionEnabled = NO;
        [self.backGroundView addSubview:_sendButton];
    }
    return _sendButton;
}

- (UIButton *)emotionButton{
    if (!_emotionButton) {
        _emotionButton = [[UIButton alloc] init];
//        [_emotionButton setBackgroundColor:[UIColor blueColor]];
        [_emotionButton setBackgroundImage:[UIImage imageNamed:@"icon_face_normal"] forState:UIControlStateNormal];
        [_emotionButton addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backGroundView addSubview:_emotionButton];
    }
    return _emotionButton;
}

- (UIView *)emotionview{
    if (!_emotionview) {
        CGFloat height = 250;
        _emotionview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, height)];
        _emotionview.backgroundColor = [UIColor whiteColor];
//        UIButton *sender = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 22, 22)];
//        [sender setBackgroundImage:[UIImage imageNamed:@"zy_thumb.gif"] forState:UIControlStateNormal];
//        [sender addTarget:self action:@selector(emojiClick) forControlEvents:UIControlEventTouchUpInside];
//        [_emotionview addSubview:sender];
        
        self.scrollView.frame = CGRectMake(0, 0, mScreenWidth, height - 35);
        self.scrollView.backgroundColor = [UIColor whiteColor];
        [_emotionview addSubview:self.scrollView];
        
        //常用，暴走漫画，搞怪
        _cyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, height - 35, mScreenWidth/4, 35)];
        [_cyBtn setTitle:@"常用" forState:UIControlStateNormal];
        [_cyBtn setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];
        [_cyBtn setTitleColor:mAppMainColor forState:UIControlStateSelected];
        _cyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _cyBtn.tag = 1;
        [_cyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cyBtn.selected = YES;
        [_emotionview addSubview:_cyBtn];
        
        _bzBtn = [[UIButton alloc] initWithFrame:CGRectMake(mScreenWidth/4, height - 35, mScreenWidth/4, 35)];
        [_bzBtn setTitle:@"暴走漫画" forState:UIControlStateNormal];
        [_bzBtn setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];
        [_bzBtn setTitleColor:mAppMainColor forState:UIControlStateSelected];
        _bzBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _bzBtn.tag = 2;
        [_bzBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_emotionview addSubview:_bzBtn];
        
        _ggBtn = [[UIButton alloc] initWithFrame:CGRectMake(mScreenWidth/2, height - 35, mScreenWidth/4, 35)];
        [_ggBtn setTitle:@"搞怪" forState:UIControlStateNormal];
        [_ggBtn setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];
        [_ggBtn setTitleColor:mAppMainColor forState:UIControlStateSelected];
        _ggBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _ggBtn.tag = 3;
        [_ggBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_emotionview addSubview:_ggBtn];
        
        UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(mScreenWidth/4*3, height - 35, mScreenWidth/4, 35)];
        [delBtn setImage:[UIImage imageNamed:@"emoji删除"] forState:UIControlStateNormal];
        [delBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 15, 10, 10)];
        [delBtn addTarget:self action:@selector(delEmoji) forControlEvents:UIControlEventTouchUpInside];
        [_emotionview addSubview:delBtn];
        
        
    }
    return _emotionview;
}

- (void)delEmoji{
    [self.textView deleteBackward];
}

- (void)btnClick:(UIButton *)sender{
    _bzBtn.selected = _bzBtn.tag == sender.tag;
    _ggBtn.selected = _ggBtn.tag == sender.tag;
    _cyBtn.selected = _cyBtn.tag == sender.tag;
    self.scrollView.contentOffset = CGPointMake((sender.tag - 1)*mScreenWidth, 0);
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(3 * mScreenWidth, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentOffset = CGPointMake(0, 0);
        _scrollView.delegate = self;
        _scrollView.tag = 100;
        
        //创建布局对象
        UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
        // 设置滚动的方向
        [layout1 setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView *collectionView1= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 215) collectionViewLayout:layout1];
        collectionView1.tag = 1;
        collectionView1.backgroundColor = [UIColor whiteColor];
        collectionView1.delegate = self;
        collectionView1.dataSource = self;
        [collectionView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
        [_scrollView addSubview:collectionView1];
        
        //创建布局对象
        UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
        // 设置滚动的方向
        [layout2 setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView *collectionView2 = [[UICollectionView alloc] initWithFrame:CGRectMake(mScreenWidth, 0, mScreenWidth, 215) collectionViewLayout:layout2];
        collectionView2.tag = 2;
        collectionView2.backgroundColor = [UIColor whiteColor];
        collectionView2.delegate = self;
        collectionView2.dataSource = self;
        [collectionView2 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
        [_scrollView addSubview:collectionView2];
        
        //创建布局对象
        UICollectionViewFlowLayout *layout3 = [[UICollectionViewFlowLayout alloc] init];
        // 设置滚动的方向
        [layout3 setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView *collectionView3 = [[UICollectionView alloc] initWithFrame:CGRectMake(mScreenWidth * 2, 0, mScreenWidth, 215) collectionViewLayout:layout3];
        collectionView3.tag = 3;
        collectionView3.backgroundColor = [UIColor whiteColor];
        collectionView3.delegate = self;
        collectionView3.dataSource = self;
        [collectionView3 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
        [_scrollView addSubview:collectionView3];
        
    }
    return _scrollView;
}

- (NSArray *)cyArr{
    if (!_cyArr) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"plist"];
        _cyArr = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _cyArr;
}

- (NSArray *)bmArr{
    if (!_bmArr) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"baoman" ofType:@"plist"];
        _bmArr = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _bmArr;
}

- (NSArray *)ggArr{
    if (!_ggArr) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gaoguai" ofType:@"plist"];
        _ggArr = [NSArray arrayWithContentsOfFile:filePath];
    }
    return _ggArr;
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (statusTextView == NO && scrollView.tag != 100 && scrollView.tag != 1 && scrollView.tag != 2 &&scrollView.tag != 3) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (scrollView.tag == 100) {
        NSInteger page = self.scrollView.contentOffset.x/mScreenWidth + 1;
        _bzBtn.selected = _bzBtn.tag == page;
        _ggBtn.selected = _ggBtn.tag == page;
        _cyBtn.selected = _cyBtn.tag == page;
    }
}

#pragma  mark -- collectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 1){
        return self.cyArr.count;
    }else if(collectionView.tag == 2){
        return self.bmArr.count;
    }else{
        return self.ggArr.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    NSDictionary *dic = [NSDictionary dictionary];
    if (collectionView.tag == 1){
        dic = self.cyArr[indexPath.row];
    }else if(collectionView.tag == 2){
        dic =  self.bmArr[indexPath.row];
    }else{
        dic =  self.ggArr[indexPath.row];
    }
    NSString *imageName = dic[@"png"];
    if ([imageName.pathExtension isEqualToString:@"gif"]) {
        NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]];
        LLGifView *gifView = [[LLGifView alloc] initWithFrame:CGRectMake((mScreenWidth/7 - 22)/2, (mScreenWidth/7 - 22)/2, 22, 22) data:localData];
        [cell.contentView addSubview:gifView];
        [gifView startGif];
    }else{
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((mScreenWidth/7 - 22)/2, (mScreenWidth/7 - 22)/2, 22, 22)];
        imageView.image = [UIImage imageNamed:imageName];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(mScreenWidth/7, mScreenWidth/7);
    
}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [NSDictionary dictionary];
    if (collectionView.tag == 1){
        dic = self.cyArr[indexPath.row];
    }else if(collectionView.tag == 2){
        dic =  self.bmArr[indexPath.row];
    }else{
        dic =  self.ggArr[indexPath.row];
    }
//    self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,dic[@"cht"]];
//    self.textView.attributedText = [self replaceEmotion:self.textView.text];
    BCTextAttachment *attachment = [[BCTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:dic[@"png"]];
    attachment.emotionStr = dic[@"cht"];
    attachment.bounds = CGRectMake(0, -3, attachment.image.size.width - 8, attachment.image.size.height - 8);
    
    NSRange range = self.textView.selectedRange;
    
    // 设置textView的文字
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    NSAttributedString *imageAttr = [NSMutableAttributedString attributedStringWithAttachment:attachment];
    
    [textAttr replaceCharactersInRange:self.textView.selectedRange withAttributedString:imageAttr];
    [textAttr addAttributes:@{NSFontAttributeName : self.textView.font} range:NSMakeRange(self.textView.selectedRange.location, 1)];
    
    self.textView.attributedText = textAttr;
    
    // 会在textView后面插入空的,触发textView文字改变
    [self.textView insertText:@""];
    
    // 设置光标位置
    self.textView.selectedRange = NSMakeRange(range.location + 1, 0);
}

//- (NSAttributedString *)replaceEmotion:(NSString *)infoText{
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emotion" ofType:@"plist"];
//    NSArray *face = [NSArray arrayWithContentsOfFile:filePath];
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:infoText];
//    NSString *regex_emoji = @"\\[(\\S+?)\\]";//@"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";//匹配表情
//    NSError *error =nil;
//    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
//    if(!re) {
//        NSLog(@"%@", [error localizedDescription]);
//        return attributeString;
//    }
//    NSArray *resultArray = [re matchesInString:infoText options:0 range:NSMakeRange(0, infoText.length)];
//    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
//    //根据匹配范围来用图片进行相应的替换
//    for(NSTextCheckingResult *match in resultArray) {
//        //获取数组元素中得到range
//        NSRange range = [match range];
//        //获取原字符串中对应的值
//        NSString *subStr = [infoText substringWithRange:range];
//        for(int i =0; i < face.count; i ++) {
//            if([face[i][@"cht"] isEqualToString:subStr]) {
//                //face[i][@"png"]就是我们要加载的图片
//                //新建文字附件来存放我们的图片,iOS7才新加的对象
//                NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
//                //给附件添加图片
//                textAttachment.image= [UIImage imageNamed:face[i][@"png"]];
//                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
//                textAttachment.bounds=CGRectMake(0, 0, textAttachment.image.size.width - 8, textAttachment.image.size.height - 8);
//                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
//                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
//                //把图片和图片对应的位置存入字典中
//                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
//                [imageDic setObject:imageStr forKey:@"image"];
//                [imageDic setObject:[NSValue valueWithRange:range]forKey:@"range"];
//                //把字典存入数组中
//                [imageArray addObject:imageDic];
//            }
//        }
//    }
//    //4、从后往前替换，否则会引起位置问题
//    for(int i = (int)imageArray.count-1; i >=0; i--) {
//        NSRange range;
//        [imageArray[i][@"range"] getValue:&range];
//        //进行替换
//        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
//    }
//    return attributeString;
//}


@end
