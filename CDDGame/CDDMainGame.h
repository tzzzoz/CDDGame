//
//  CDDMainGame.h
//  CDDGame
//
//  Created by kwan terry on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Card.h"
#import "Player.h"

typedef enum 
{
    Update   = 1,
    Menu     = 2,
    Pause    = 3,
    Continue = 4,
    Notice   = 5,
    Escape   = 6,
    End      = 7
}GameState;

@interface CDDMainGame : CCLayer 
{
    NSMutableArray* playersList;
    NSMutableArray* cardsList;
    NSMutableArray* roleList;
    
    int  totalScore0;
    int  totalScore1;
    int  totalScore2;
    int  totalScore3;
    
    Player*         currentPlayer;
    GameState       gameState;
    int             lastPos;
    float           delayTime;
    
    //更新界面
    CCSprite*     mainGameView;
    CCMenu*       menuMenu;
    CCMenu*       backMenu;
    CCMenu*       takeMenu;
    CCMenu*       passMenu;
    CCMenu*       sortMenu;
    CCLabelTTF*   player0TotalScore;
    CCLabelTTF*   player0CardNum;
    CCLabelTTF*   player1CardNum;
    CCLabelTTF*   player2CardNum;
    CCLabelTTF*   player3CardNum;
    NSMutableArray*  backCards1;
    NSMutableArray*  backCards2;
    NSMutableArray*  backCards3;
    
    //提示界面
    CCMenu*       noticeMenu;
    
    //结束界面
    CCSprite*     endView;
    CCMenu*       restartMenu;
    CCMenu*       awayMenu;
    
    //菜单界面
    CCSprite*     menuView;
    CCMenu*       menuList;
    CCMenu*       menSuerMenu;
    CCMenu*       menCancelMenu;
    CCMenuItemImage* setImg;
    CCMenuItemImage* pauseImg;
    
    //逃跑界面
    CCSprite*     escapeView;
    CCMenu*       escSureMenu;
    CCMenu*       escCancelMenu;
    
    //暂停界面
    CCSprite*     pauseView;
    CCMenu*       continueMenu;
    
    //继续界面
    CCSprite*     goonView;
    CCMenu*       goonList;
    
}

+(CCScene *) scene;

-(void)distributeCards;
-(void)playerTakeTurn;
-(Boolean)testEnd;
-(void)calculateScore;
-(void)calculateEscape;

-(void)initPlayersList;
-(void)initCardsList;
-(void)initBackCardsList;

-(void)drawUpdate;
-(void)drawMenu;
-(void)drawPause;
-(void)drawContinue;
-(void)drawNotice;
-(void)drawEscape;
-(void)drawEnd;

-(void)step:(ccTime)delayTime;
-(void)gameUpdate;
-(void)gameMenu;
-(void)gamePause;
-(void)gameContinue;
-(void)gameNotice;
-(void)gameEscape;
-(void)gameEnd;

@end
