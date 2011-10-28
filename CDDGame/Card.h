//
//  Card.h
//  CDDGame
//
//  Created by kwan terry on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
    DIAMONDS = 1,  //方块
    CLUB = 2,      //梅花
    HEARTS = 3,    //红桃
    SPADE = 4,     //黑桃 
}SuitType;

@interface Card : CCSprite 
{
    int cardNum;
    SuitType suit;
    Boolean  isSelect;
    Boolean  isTake;
    Boolean  isTaked;
}

@property (readwrite) int cardNum;
@property (readwrite) SuitType suit;
@property (readwrite) Boolean  isSelect;
@property (readwrite) Boolean  isTake;
@property (readwrite) Boolean  isTaked;

-(id)initObjectWithType:(int)suitType andNum:(int)number;
-(id)initObjectWithNum:(int)number;
-(Card*)maxCard:(Card*)card;


@end
