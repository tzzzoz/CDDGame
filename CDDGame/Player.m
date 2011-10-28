//
//  Player.m
//  CDDGame
//
//  Created by kwan terry on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize playerName;
@synthesize playerState;
@synthesize playerType;
@synthesize playerPos;
@synthesize onHandCardsNum;
@synthesize selectCardsNum;
@synthesize selectCards;
@synthesize cardsOnHand;
@synthesize lastCards;
@synthesize tScore;
@synthesize scoreGet;

-(id)initPlayerWithPlayerName:(PlayerName)playerName1 PlayerType:(PlayerType)playerType1 PlayerState:(PlayerState)playerState1
{
    //[self init];
    
    self.playerState = playerState1;
    self.playerType  = playerType1;
    self.playerName  = playerName1;
    
    self.cardsOnHand = [[NSMutableArray alloc]init];
    self.selectCards = [[NSMutableArray alloc]init];
    self.lastCards   = [[NSMutableArray alloc]init];
    
    self.onHandCardsNum = 13;
    self.selectCardsNum = 0;
    self.tScore = 0;
    self.scoreGet = 0;
    
    return self;
}

-(id)initPlayerWithRoleList:(NSMutableArray*)roleList Postion:(int)playerPos1
{
    self.playerPos = playerPos1;
    int value = [[roleList objectAtIndex:playerPos1-1]intValue];
    self = [self initWithFile:[[NSString alloc]initWithFormat:@"player%d.png",value]];
    return self;
}

-(Boolean)hasDiamodsThree
{
    for (int i=0; i<cardsOnHand.count; i++) 
    {
        Card* cardTemp = [cardsOnHand objectAtIndex:i];
        if (cardTemp.cardNum == 3 && cardTemp.suit == DIAMONDS) 
            return YES;
    }
    return NO;
}

-(Boolean)selectDiamodsThree
{
    for(int i=0; i<selectCards.count; i++)
    {
        Card* cardTemp = [selectCards objectAtIndex:i];
        if(cardTemp.cardNum == 3 && cardTemp.suit == DIAMONDS)
            return YES;
    }
    return NO;
}

-(void)selectCardsAction:(NSMutableArray*)player
{
    if(playerType == AI)
    {
        if(lastCards.count != 0)
        {
            for(int i=0; i<lastCards.count; i++)
            {
                Card* cardTemp = [lastCards objectAtIndex:i];
                cardTemp.visible = NO;
            }
        }
        
        Card* cardTemp = [cardsOnHand objectAtIndex:onHandCardsNum-1];
        [cardTemp setIsSelect:YES];
        [selectCards addObject:cardTemp];
        selectCardsNum++;
    }
}

-(void)showCard:(NSMutableArray *)player byId:(id)game
{
    [lastCards removeAllObjects];
    lastCards = [[NSMutableArray alloc]init];
    
    switch(playerPos)
    {
        case 0:
            break;
        case 1:
        {
            Player* playerTemp = [player objectAtIndex:1];
            for (int i=0; i<playerTemp.selectCardsNum; i++) 
            {
                Card* cardTemp = [playerTemp.selectCards objectAtIndex:i];
                //出牌的位置待定
                cardTemp.visible = YES;
                [cardTemp runAction:[CCPlace actionWithPosition:CGPointMake(100.0f, 200.0f)]];
                [game addChild:cardTemp];
                NSLog(@"%d",111);
            }
        }
            break;
        case 2:
        {
            Player* playerTemp = [player objectAtIndex:2];
            for (int i=0; i<playerTemp.selectCardsNum; i++) 
            {
                Card* cardTemp = [playerTemp.selectCards objectAtIndex:i];
                //出牌的位置待定
                cardTemp.visible = YES;
                [cardTemp runAction:[CCPlace actionWithPosition:CGPointMake(220.0f, 220.0f)]];
                [game addChild:cardTemp];
                NSLog(@"%d",222);
            }
        }
            break;
        case 3:
        {
            Player* playerTemp = [player objectAtIndex:3];
            for (int i=0; i<playerTemp.selectCardsNum; i++) 
            {
                Card* cardTemp = [playerTemp.selectCards objectAtIndex:i];
                //出牌的位置待定
                cardTemp.visible = YES;
                [cardTemp runAction:[CCPlace actionWithPosition:CGPointMake(340.0f, 200.0f)]];
                [game addChild:cardTemp];
                NSLog(@"%d",333);
            }            
        }
            break;
    }
    
    for(int i=0; i<selectCardsNum; i++)
    {
        Card* cardTemp = [selectCards objectAtIndex:i];
        [cardTemp setIsTake:YES];
        [lastCards addObject:[selectCards objectAtIndex:i]];
        [cardsOnHand removeObject:[selectCards objectAtIndex:i]];
    }
    self.onHandCardsNum = cardsOnHand.count;
    
    
    [self.selectCards removeAllObjects];
    selectCards = [[NSMutableArray alloc]init];
    selectCardsNum = 0;
     
}

-(int)scoreCard:(NSMutableArray *)player
{
    Player* playerTemp = [player objectAtIndex:playerPos];
    if(playerTemp.onHandCardsNum < 8)
        scoreGet = playerTemp.onHandCardsNum;
    else if(playerTemp.onHandCardsNum>=8 && playerTemp.onHandCardsNum<10)
        scoreGet = 2*playerTemp.onHandCardsNum;
    else if(playerTemp.onHandCardsNum>=10 && playerTemp.onHandCardsNum<13)
        scoreGet = 3*playerTemp.onHandCardsNum;
    else if(playerTemp.onHandCardsNum == 13)
        scoreGet = 4*playerTemp.onHandCardsNum;
            
    for(int i=0; i<playerTemp.onHandCardsNum; i++)
    {
        Card* cardTemp = [playerTemp.cardsOnHand objectAtIndex:i];
        if(cardTemp.suit == SPADE && cardTemp.cardNum == 2 && playerTemp.onHandCardsNum >= 8)
            scoreGet = scoreGet*2;
    }
            
    return scoreGet;
}

-(int)totalScore:(NSMutableArray *)player ScoreZero:(int)scoreZero ScoreOne:(int)scoreOne ScoreTwo:(int)scoreTwo ScoreThree:(int)scoreThree
{
    switch (playerPos) 
    {
        case 0:
        {
            tScore = scoreOne+scoreTwo+scoreThree-3*scoreZero;
            return tScore;
        }
            break;
        case 1:
        {
            tScore = scoreZero+scoreTwo+scoreThree-3*scoreOne;
            return tScore;
        }
            break;
        case 2:
        {
            tScore = scoreZero+scoreOne+scoreThree-3*scoreTwo;
            return tScore;
        }
            break;
        case 3:
        {
            tScore = scoreZero+scoreOne+scoreTwo-3*scoreThree;
            return tScore;
        }
        default:
            break;
    }
    return tScore;
}

@end
