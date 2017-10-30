//
//  UserInfoModel.m
//  CabbageNet/Users/zhi/Dev/project/CabbageNet/Classes/Sections/个人/Model/UserInfoModel.m
//
//  Created by MacAir on 2017/4/12.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

MJCodingImplementation

// 获取用户信息
+ (UserInfoModel *)sharedUserData{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"atany.archiver"];
    UserInfoModel *userModel =[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (!userModel) {
        NSLog(@"----");
    }
    return userModel;
}

// 存储用户信息
+ (void)storeUserWithModel:(UserInfoModel *)model{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [documentPath stringByAppendingPathComponent:@"atany.archiver"];
    BOOL success=[NSKeyedArchiver archiveRootObject:model toFile:path];
    NSLog(@"%@\n:::%@", documentPath,path);
    if (success) {
        NSLog(@"个人信息成功存储到本地");
    }else{
        NSLog(@"个人信息存储到本地失败");
    }
}

@end
