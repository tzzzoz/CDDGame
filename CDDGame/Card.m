//
//  Card.m
//  CDDGame
//
//  Created by kwan terry on 11-10-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Card.h"


@implementation Card

@synthesize cardNum;
@synthesize suit;
@synthesize isSelect;
@synthesize isTake;
@synthesize isTaked;

-(id)initObjectWithNum:(int)number
{
    self = [self initWithFile:[[NSString alloc]initWithFormat:@"%d.png",number]];
    self.visible = NO;
    self.scale   = 0.8f;
    return self;
}

-(id)initObjectWithType:(int)suitType andNum:(int)number
{
    //[self init];
    self.cardNum  = number;
    self.suit     = suitType;
    self.isSelect = NO;
    self.isTake   = NO;
    self.isTaked  = NO;
    
    return self;
}

-(Card*)maxCard:(Card*)card
{
    if(card.cardNum <= 2)
        return [[Card alloc]initObjectWithType:card.suit andNum:card.cardNum];
    else
        return [[Card alloc]initObjectWithType:card.suit andNum:card.cardNum];
}

@end
