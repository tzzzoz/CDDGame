//
//  CDDMenu.m
//  CDDGame
//
//  Created by kwan terry on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CDDMenu.h"
#import "CDDMainGame.h"
#import "CDDSetting.h"

@implementation CDDMenu

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CDDMenu *layer = [CDDMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if(self = [super init])
    {
        //允许触碰
        self.isTouchEnabled = YES;
        
        //游戏背景
        CCSprite* backGround = [CCSprite spriteWithFile:@"background1.png"];
        backGround.anchorPoint = CGPointZero;
        [self addChild:backGround z:0 tag:1];
        
        //开始游戏
        CCSprite* start_off = [CCSprite spriteWithFile:@"bt_start_off.png"];
        CCSprite* start_on  = [CCSprite spriteWithFile:@"bt_start_on.png"];
        CCMenuItemImage* gameStart = [CCMenuItemImage itemFromNormalSprite:start_off selectedSprite:start_on target:self selector:@selector(clickStart:)];
        
        //设置游戏
        CCSprite* setting_on  = [CCSprite spriteWithFile:@"bt_setting_on.png"];
        CCSprite* setting_off = [CCSprite spriteWithFile:@"bt_setting_off.png"];
        CCMenuItemImage* gameSetting = [CCMenuItemImage itemFromNormalSprite:setting_off selectedSprite:setting_on target:self selector:@selector(clickSetting:)];
        
        //添加到菜单列表
        CCMenu* mainMenu = [CCMenu menuWithItems: gameStart, gameSetting, nil];
        [mainMenu alignItemsVertically];                    //将项目纵向对齐
        mainMenu.anchorPoint = CGPointZero;
        mainMenu.position = CGPointMake(320.0f, 130.0f);
        [self addChild:mainMenu z:1 tag:2];                 //把mainMenu加入视图中
    }
    return self;
}

//点击“开始游戏”响应函数
-(void) clickStart: (id)sender
{
    CCScene* scene = [CCScene node];
    [scene addChild:[CDDMainGame node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5f scene:scene]];
}

//点击“设置游戏”响应函数
-(void) clickSetting: (id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.3f scene:[CDDSetting scene]]];
}

- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
