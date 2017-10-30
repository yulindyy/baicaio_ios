//
//  DiscountPrise.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "DiscountPrise.h"

@implementation DiscountPrise

+ (BOOL)insertDiscountID:(NSString *)discountID andUser:(NSString *)user andIsDiscount:(BOOL)isDiscount{
    
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open])
    {
        //4.创表
        NSString *table = isDiscount ? @"t_DiscountPrise" : @"t_original";
        BOOL result = [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, IDname text NOT NULL, username text NOT NULL);",table]];
        
        if (result)
        {
            NSLog(@"创建表成功");
        }//[NSString stringWithFormat:@"---%@",discountID];
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO %@ ('IDname','username') VALUES ('%@','%@')",table,discountID,user];
        BOOL res = [db executeUpdate:insertSql1];
        
        [db close];
        if (!res) {
            NSLog(@"error when insert db table");
            return NO;
        } else {
            NSLog(@"success to insert db table");
            return YES;
        }
    }

    return NO;
}

+ (BOOL)selectedDiscountID:(NSString *)discountID andUser:(NSString *)user andIsDiscount:(BOOL)isDiscount{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        NSString *table = isDiscount ? @"t_DiscountPrise" : @"t_original";
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ where IDname = '%@' and username = '%@'",table,discountID,user];//select * from t_student where id<?;”@(14
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
        
            NSString *idname = [rs stringForColumn:@"IDname"];
            NSString * username = [rs stringForColumn:@"username"];
            NSLog(@"id = %@, name = %@,",idname, username);
            [db close];
            return YES;
        }
        [db close];
    }
    return NO;
}

+ (BOOL)deletedDiscountID:(NSString *)discountID andUser:(NSString *)user andIsDiscount:(BOOL)isDiscount{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        NSString *table = isDiscount ? @"t_DiscountPrise" : @"t_original";
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where IDname = '%@' and username = '%@'",table,
                                discountID,user];
        BOOL res = [db executeUpdate:deleteSql];
        [db close];
        if (!res) {
            NSLog(@"error when delete db table");
            return NO;
        } else {
            NSLog(@"success to delete db table");
            return YES;
        }
        
        
    }
    return YES;
}

+ (void)selectedAll:(BOOL)isDiscount{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        NSString *table = isDiscount ? @"t_DiscountPrise" : @"t_original";
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@",table];
        NSLog(@"%@",sql);
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *idname = [rs stringForColumn:@"IDname"];
            NSString * username = [rs stringForColumn:@"username"];
            NSLog(@"%@ id = %@, name = %@,",table,idname, username);
    
        }
        [db close];
    }
}


+ (BOOL)insertCommentID:(NSString *)CommentID andUser:(NSString *)user andShopID:(NSString *)ShopID{
    
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open])
    {
        //4.创表
        BOOL result = [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_Comment (id integer PRIMARY KEY AUTOINCREMENT, CommentID text NOT NULL, username text NOT NULL,ShopID text NOT NULL);"]];
        
        if (result)
        {
            NSLog(@"创建表成功");
        }//[NSString stringWithFormat:@"---%@",discountID];
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO t_Comment ('CommentID','username','ShopID') VALUES ('%@','%@','%@')",CommentID,user,ShopID];
        BOOL res = [db executeUpdate:insertSql1];
        
        [db close];
        if (!res) {
            NSLog(@"error when insert db table");
            return NO;
        } else {
            NSLog(@"success to insert db table");
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)selectedCommentID:(NSString *)CommentID andUser:(NSString *)user andShopID:(NSString *)ShopID{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM t_Comment where CommentID = '%@' and username = '%@' and ShopID = '%@'",CommentID,user,ShopID];//select * from t_student where id<?;”@(14
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            
            NSString *idname = [rs stringForColumn:@"CommentID"];
            NSString * username = [rs stringForColumn:@"ShopID"];
            NSLog(@"id = %@, name = %@,",idname, username);
            [db close];
            return YES;
        }
        [db close];
    }
    return NO;

}

+ (BOOL)deletedCommentID:(NSString *)CommentID andUser:(NSString *)user andShopID:(NSString *)ShopID{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from t_Comment where CommentID = '%@' and username = '%@' and ShopID = '%@'",
                               CommentID,user,ShopID];
        BOOL res = [db executeUpdate:deleteSql];
        [db close];
        if (!res) {
            NSLog(@"error when delete db table");
            return NO;
        } else {
            NSLog(@"success to delete db table");
            return YES;
        }
        
        
    }
    return YES;
}

+ (NSArray *)selectedHistory{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM t_history"];
        FMResultSet * rs = [db executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        while ([rs next]) {
            NSString * histroy = [rs stringForColumn:@"History"];
            [array addObject:histroy];
        }
        [db close];
        return array;
    }
    return [NSMutableArray array];
}

+ (void)deletedHistory:(NSString *)string{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from t_history where History = '%@'",
                               string];
        BOOL res = [db executeUpdate:deleteSql];
        [db close];
        if (!res) {
            NSLog(@"error when delete db table");
        } else {
            NSLog(@"success to delete db table");
        }
    }
}

+ (void)insertHistory:(NSString *)string{
    
    NSArray *array = [DiscountPrise selectedHistory];
    if (array.count == 20) {
        [DiscountPrise deletedHistory:array.firstObject];
    }
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open])
    {
        //4.创表
        BOOL result = [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_history (id integer PRIMARY KEY AUTOINCREMENT, History text NOT NULL);"]];
        
        if (result)
        {
            NSLog(@"创建表成功");
        }//[NSString stringWithFormat:@"---%@",discountID];
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO t_history ('History') VALUES ('%@')",string];
        BOOL res = [db executeUpdate:insertSql1];
        
        [db close];
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
    }
}

+ (NSArray *)selectedUser{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM t_user"];
        FMResultSet * rs = [db executeQuery:sql];
        NSMutableArray *array = [NSMutableArray array];
        while ([rs next]) {
            NSString * histroy = [rs stringForColumn:@"user"];
            [array addObject:histroy];
        }
        [db close];
        return array;
    }
    return [NSMutableArray array];
}

+ (void)insertUser:(NSString *)string{
    NSArray *array = [DiscountPrise selectedUser];
    for (NSString *user in array) {
        if ([user isEqualToString:string]) {
            return;
        }
    }
    
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"database.sqlite"];
    
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([db open])
    {
        //4.创表
        BOOL result = [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_user (id integer PRIMARY KEY AUTOINCREMENT, user text NOT NULL);"]];
        
        if (result)
        {
            NSLog(@"创建表成功");
        }//[NSString stringWithFormat:@"---%@",discountID];
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO t_user ('user') VALUES ('%@')",string];
        BOOL res = [db executeUpdate:insertSql1];
        
        [db close];
        if (!res) {
            NSLog(@"error when insert db table");
        } else {
            NSLog(@"success to insert db table");
        }
    }
}


@end