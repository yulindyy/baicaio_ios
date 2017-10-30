//
//  DetailSignCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/11.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "DetailSignCell.h"
#import "LabelCollectionViewCell.h"
#import "ScreenModel.h"
#import "EqualSpaceFlowLayoutEvolve.h"

@interface DetailSignCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end

@implementation DetailSignCell

- (void)setArray:(NSArray *)array{
    _array = array;
    
    [self.myCollectionView reloadData];
    self.myCollectionView.scrollEnabled = NO;
    if (self.backHeight) {
        self.backHeight(self.myCollectionView.collectionViewLayout.collectionViewContentSize.height);
    }else{
        NSLog(@"blpck=======");
    }
}

- (IBAction)btnClick {
    if (self.btnWidth) self.btnBlock();
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    EqualSpaceFlowLayoutEvolve *leftAlignedLayout = [[EqualSpaceFlowLayoutEvolve alloc] initWthType:AlignWithLeft];
        leftAlignedLayout.betweenOfCell = 10;
    self.myCollectionView.collectionViewLayout = leftAlignedLayout;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma  mark -- collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"labelCollectionViewCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = self.array[indexPath.row];

    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize stringSize = [self.array[indexPath.row] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    return CGSizeMake(stringSize.width + 20, 25);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) self.block(indexPath.row);
    [collectionView reloadData];
}


@end
