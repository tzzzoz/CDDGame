//
//  Data.h
//  StoreData
//
//  Created by 喻 柏程 on 11-10-27.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface CDDData : NSObject
{
    //数据库的名字
    sqlite3 * database;
    //存储用户列表
    sqlite3_stmt * nextStatement;
    //记录用户设置的表
    NSString * userSettingTableName;
    //记录分数排名的表
    NSString * userScoreTableName;
    float currentMvol;
    float currentEvol;
    int currentScore;

}

//和数据库建立连接
-(void) openDB;

//创建记录用户设置的表
- (void) createUserSettingTable;

//-(sqlite3_stmt*) scoreStatement;
- (Boolean) validateUserName:(NSString*) name;
-(NSString *) nextUser;
- (void) deleteUser:(NSString *) name;
- (void) updateUserSetting:(NSString *) name withMvol:(float) mvol andEvol:(float) evol;
- (void) createUserSetting:(NSString *) name withMvol:(float) mvol andEvol:(float) evol;

-(void) displayRecord;
-(void) closeDB;
-(float) gettingMvol;
-(float) gettingEvol;
-(int) gettingScore;
-(void) useName:(NSString *)name;
-(NSString *) selectLastName;
-(void) updateSelectUserScore:(NSString *)name score:(int) x;
@end
