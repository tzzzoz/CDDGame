//
//  Data.m
//  StoreData
//
//  Created by 喻 柏程 on 11-10-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CDDData.h"

@implementation CDDData
//和数据库建立连接
-(void)openDB
{
    //初始化游戏音效和声音设置
    currentEvol = 0.5f;
    currentMvol = 0.5f;
    
    userSettingTableName = [[NSString alloc] initWithFormat:@"UserSetting"];
    userScoreTableName = [[NSString alloc] initWithFormat:@"UserScore"];
    
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                , NSUserDomainMask 
                                                                , YES); 
    NSString *databaseFilePath=[[documentsPaths objectAtIndex:0] stringByAppendingPathComponent:@"UserData"];
    
    if (sqlite3_open([databaseFilePath UTF8String], &database) == SQLITE_OK) { 
        NSLog(@"open sqlite db ok."); 
    }
}

- (void) createUserSettingTable
{
    char *errorMsg;    
    NSString * createSql = [NSString stringWithFormat:@"create table if not exists %@ (name text, mvol real, evol real, score integer, use integer)", userSettingTableName];
    if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) { 
        NSLog(@"create table ok."); 
    }
}


//判断用户名是否已存在
- (Boolean) validateUserName:(NSString*) name
{
    NSString * selectSql = [NSString stringWithFormat:@"select name from %@ where name='%@'",userSettingTableName , name];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, nil)==SQLITE_OK) { 
        NSLog(@"select ok."); 
    }else{
        NSLog(@"select failed");
    }
    if (sqlite3_step(statement) == SQLITE_ROW) {
        NSLog(@"已有相同的用户名");
        return NO;
    }else{
        NSLog(@"创建新的用户名");
        return YES;
    }
}

//更新用户的设置
- (void) updateUserSetting:(NSString *) name withMvol:(float) mvol andEvol:(float) evol
{
    char * errorMsg;
    NSString * updateSql = [NSString stringWithFormat:@"update  '%@' set mvol='%f', evol='%f' where name='%@'",userSettingTableName, mvol, evol, name];
    NSLog(@"%@", updateSql);
    if (sqlite3_exec(database, [updateSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"update user setting ok");
    }else
    {
        NSLog(@"update user setting failed");
    }
}

//创建新用户，保存其设置
- (void) createUserSetting:(NSString *) name withMvol:(float) mvol andEvol:(float) evol
{
    char * errorMsg;
    NSString * sql = [NSString stringWithFormat:@"INSERT OR ROLLBACK INTO '%@'('%@','%@', '%@','%@','%@') VALUES ('%@', '%f', '%f', '%d', '%d')", userSettingTableName, @"name",@"mvol",@"evol",@"score",@"use" ,name, 0.5, 0.5, 1, 1];
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"insert new user ok."); 
    }
    else
    {
        NSLog(@"insert new user faild."); 
        NSLog(@"%@", errorMsg);
    }
}


-(NSString *) nextUser
{
    NSString * selectSql = [NSString stringWithFormat:@"select name, mvol, evol, score, use from %@ order by name asc", userSettingTableName];
    
    if (sqlite3_step(nextStatement) == SQLITE_ROW) {
        double mvol = sqlite3_column_double(nextStatement, 1);
        double evol = sqlite3_column_double(nextStatement, 2);
        int score = sqlite3_column_int(nextStatement, 3);
        int use = sqlite3_column_int(nextStatement, 4);
        //        mvol = 100;
        
        currentMvol = mvol;
        currentEvol = evol;
        NSLog(@"mvol = %f", currentMvol);
        NSLog(@"evol = %f", currentEvol);
        NSLog(@"score=%d", score);
        NSLog(@"use=%d", use);
        return [[NSString alloc] initWithCString:(char *)sqlite3_column_text(nextStatement, 0) encoding:NSUTF8StringEncoding];
    }else{
        NSLog(@"最后一位了");
        if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &nextStatement, nil) == SQLITE_OK) {
            NSLog(@"select next user ok");
        }
        if (sqlite3_step(nextStatement) == SQLITE_ROW) {
            NSLog(@"zailai");
            double mvol = sqlite3_column_double(nextStatement, 1);
            double evol = sqlite3_column_double(nextStatement, 2);
            int score = sqlite3_column_int(nextStatement, 3);
            int use = sqlite3_column_int(nextStatement, 4);
            //            mvol = 100;
            currentMvol = mvol;
            currentEvol = evol;
            NSLog(@"mvol = %f", currentMvol);
            NSLog(@"evol = %f", currentEvol);
            NSLog(@"score=%d", score);
            NSLog(@"use=%d", use);
            return [[NSString alloc] initWithCString:(char *)sqlite3_column_text(nextStatement, 0) encoding:NSUTF8StringEncoding];
        }else{
            return nil;
        }
    }
}


- (void) deleteUser:(NSString *) name
{
    char * errorMsg;
    NSString * deleteSql = [NSString stringWithFormat:@"delete from %@ where name='%@'", userSettingTableName, name];
    if (sqlite3_exec(database, [deleteSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"delete user ok");
    }else
    {
        NSLog(@"delete user failed");
    }
}


//测试，用于显示所有的数据
-(void) displayRecord
{
    //    const char *selectSqla="select name from persons1"; 
    NSString *selectSql = [NSString stringWithFormat:@"select name from %@", userSettingTableName];
    sqlite3_stmt *statement; 
    if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, nil)==SQLITE_OK) { 
        NSLog(@"select ok."); 
    }
    while (sqlite3_step(statement)==SQLITE_ROW) { 
        //        int _id=sqlite3_column_int(statement, 0); 
        NSString *name=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding]; 
        NSLog(@"row>>, name %@",name); 
    }
    sqlite3_finalize(statement);
}

//-(sqlite3_stmt *) scoreStatement
//{
//    NSString *selectSql = [NSString stringWithFormat:@"select name, score from %@ order by score desc", userScoreTableName];
//    sqlite3_stmt *statement; 
//    if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, nil)==SQLITE_OK) { 
//        NSLog(@"select ok."); 
//    }
//    return statement;
//}


-(float) gettingMvol
{
    return currentMvol;
}

-(float) gettingEvol
{
    return currentEvol;
}

-(int) gettingScore
{
    return currentScore;
}


//更新用户的分数
-(void) updateSelectUserScore:(NSString *)name score:(int)x
{
    char * errorMsg;
    NSString * updateSql = [NSString stringWithFormat:@"update '%@' set score='%d' where name='%@'", userSettingTableName, x,name];
    if (sqlite3_exec(database, [updateSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"update ok");
    }else
    {
        NSLog(@"update failed");
    }
}
//使用用户名
-(void)useName:(NSString *)name
{
    char * errorMsg;
    NSString * updateSql = [NSString stringWithFormat:@"update '%@' set use='%d'",userSettingTableName, 1];
    if (sqlite3_exec(database, [updateSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"use update ok");
    }else
    {
        NSLog(@"use update failed");
    }
    NSString * useSql = [NSString stringWithFormat:@"update '%@' set use='%d' where name='%@'", userSettingTableName, 0, name];
    if (sqlite3_exec(database, [useSql UTF8String], NULL, NULL, &errorMsg) == SQLITE_OK) {
        NSLog(@"use ok");
    }else
    {
        NSLog(@"use failed");
    }
}

//选择上次使用的用户名
-(NSString *) selectLastName
{
    NSString * selectSql = [NSString stringWithFormat:@"select name, mvol, evol, score from %@ where use='%d'", userSettingTableName, 0];
    sqlite3_stmt *statement; 
    if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &statement, nil)==SQLITE_OK) { 
        NSLog(@"select ok1."); 
    }
    else
    {
        NSLog(@"select failed");
    }
    NSString *name = nil;
    if (sqlite3_step(statement)==SQLITE_ROW) {
        name=[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding]; 
        NSLog(@"row>>, name %@",name);
        currentMvol = sqlite3_column_double(statement, 1);
        currentEvol = sqlite3_column_double(statement, 2);
        currentScore = sqlite3_column_int(statement, 3);
        NSLog(@"score=%d", currentScore);
    }
    sqlite3_finalize(statement);
    return name;
}



//关闭数据库
-(void) closeDB
{
    //释放查询的sql文资源，如果没有释放，下次打开数据库的时候将不能写入
    sqlite3_finalize(nextStatement);
    //关闭数据库
    sqlite3_close(database); 
    NSLog(@"close db");
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
