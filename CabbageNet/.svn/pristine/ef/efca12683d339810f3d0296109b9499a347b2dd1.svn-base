//
//  ScreenCollectionCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/11.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ScreenCollectionCell.h"
#import "LabelCollectionViewCell.h"
#import "ScreenModel.h"
#import "EqualSpaceFlowLayoutEvolve.h"

@interface ScreenCollectionCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@end

@implementation ScreenCollectionCell{
    NSInteger _selectedCell;
    NSIndexPath *_lateCellIndex;
}

- (void)setArray:(NSArray *)array{
    _array = array;
    for (int i = 0; i < array.count; i ++) {
        ScreenModel *model = array[i];
        if ([self.selectedOrig isEqualToString:model.screenID]) {
            _selectedCell = i + 1;
        }
    }
    [self.myCollectionView reloadData];
    self.myCollectionView.scrollEnabled = NO;
    if (self.backHeight) {
        self.backHeight(self.myCollectionView.collectionViewLayout.collectionViewContentSize.height);
    }else{
        NSLog(@"blpck=======");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectedCell = 1;
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
    ScreenModel *model = self.array[indexPath.row];
    cell.titleLabel.text = model.name;
//    if (_selectedCell == 0 && [self.selectedOrig isEqualToString:model.screenID]) {
//        NSLog(@"self --%@,%@",self.selectedOrig,model.screenID);
//        _selectedCell = indexPath.row + 1;
//    }
    if (indexPath.row == _selectedCell - 1) {
        cell.backgroundColor = mAppMainColor;
        cell.titleLabel.textColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.textColor = toPCcolor(@"333333");
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    ScreenModel *model = self.array[indexPath.row];
    CGSize stringSize = [model.name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    return CGSizeMake(stringSize.width + 10, 25);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 15, 0, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _lateCellIndex = [NSIndexPath indexPathForRow:_selectedCell - 1 inSection:0];
    _selectedCell = indexPath.row + 1;
    if (self.block) self.block(indexPath.row);
    [UIView setAnimationsEnabled:NO]; 
    [collectionView reloadItemsAtIndexPaths:@[_lateCellIndex,indexPath]];
}



@end
