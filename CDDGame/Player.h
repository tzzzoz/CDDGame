//
//  Player.h
//  CDDGame
//
//  Created by kwan terry on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Card.h"

typedef enum
{
    AI   = 1,
    User = 2
}PlayerType;

typedef enum
{
    TakeTurn = 1,
    OffTurn  = 2
}PlayerState;

typedef enum
{
    benko  = 1,
    fenko  = 2,
    fenke  = 3,
    sanzhi = 4,
    push   = 5,
    none   = 6
}PlayerName;

@interface Player : CCSprite 
{
    PlayerType      playerType;
    PlayerState     playerState;
    PlayerName      playerName;
    
    NSMutableArray*        cardsOnHand;
    NSMutableArray*        selectCards;
    NSMutableArray*        lastCards;
    
    int             onHandCardsNum;
    int             selectCardsNum;
    int             playerPos;
    
    //分数
    int             tScore;
    int             scoreGet;
}

@property (readwrite) PlayerType  playerType;
@property (readwrite) PlayerState playerState;
@property (readwrite) PlayerName  playerName;
@property (readwrite) int         onHandCardsNum;
@property (readwrite) int         selectCardsNum;
@property (readwrite) int         playerPos;
@property (readwrite) int         tScore;
@property (readwrite) int         scoreGet;

@property (retain)    NSMutableArray*   cardsOnHand;
@property (retain)    NSMutableArray*   selectCards;
@property (retain)    NSMutableArray*   lastCards;

-(id)initPlayerWithPlayerName:(PlayerName)playerName1 PlayerType:(PlayerType)playerType1 PlayerState:(PlayerState)playerState1;
-(id)initPlayerWithRoleList:(NSMutableArray*)roleList Postion:(int)playerPos1;
-(Boolean)hasDiamodsThree;
-(Boolean)selectDiamodsThree;
-(void)selectCardsAction:(NSMutableArray*)player;
-(void)showCard:(NSMutableArray*)player byId:(id)game;
-(int)scoreCard:(NSMutableArray*)player;
-(int)totalScore:(NSMutableArray*)player ScoreZero:(int)scoreZero ScoreOne:(int)scoreTwo ScoreTwo:(int)scoreTwo ScoreThree:(int)scoreThree;

@end
