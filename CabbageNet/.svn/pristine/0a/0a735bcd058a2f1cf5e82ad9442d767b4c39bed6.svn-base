//
//  MYCollectionCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/15.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "MYCollectionCell.h"

@interface MYCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

@end

@implementation MYCollectionCell

- (void)setModel:(MYCollectionModel *)model{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
//    self.titleLabel.text = model.title;
    NSString *strUrl = [model.title stringByReplacingOccurrencesOfString:@"<span>" withString:@"<span style=\"color:#ff4444\">"];//替换字符
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[strUrl dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.titleLabel.attributedText = attrStr;
    self.commentNumLabel.text = [NSString stringWithFormat:@"评论数：%ld",model.comments    ];
}
- (IBAction)delBtnClick {
    if (self.Block) self.Block();
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.delBtn.layer.cornerRadius = 5;
    self.delBtn.layer.masksToBounds = YES;
    self.delBtn.layer.borderWidth = 1;
    self.delBtn.layer.borderColor = toPCcolor(@"999999").CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
