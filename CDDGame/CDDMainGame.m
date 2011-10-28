//
//  CDDMainGame.m
//  CDDGame
//
//  Created by kwan terry on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CDDMainGame.h"


@implementation CDDMainGame

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CDDMainGame *layer = [CDDMainGame node];
	
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
        
        //初始时gameState为Update
        gameState = Update;
        
        //添加背景
        mainGameView = [CCSprite spriteWithFile:@"background3.png"];
        mainGameView.anchorPoint = CGPointZero;
        [self addChild:mainGameView z:0 tag:1];
        
        //初始化
        roleList = [[NSMutableArray alloc]init];
        [roleList addObject:[NSNumber numberWithInt:1]];
        [roleList addObject:[NSNumber numberWithInt:2]];
        [roleList addObject:[NSNumber numberWithInt:3]];
    
        //初始化52张牌
        [self initCardsList];
        
        //初始化playerList，并且显示分数和牌数
        [self initPlayersList];
        
        //初始化每个AIplayer背面牌
        [self initBackCardsList];
        
        //随机分牌
        [self distributeCards];
        
        //确定分牌后的接管权
        [self playerTakeTurn];
        
        //绘画Update画面的按钮
        [self drawUpdate];
        
        //绘画Notice画面
        [self drawNotice];
        
        //绘画End画面
        [self drawEnd];
        
        //绘画Menu画面
        [self drawMenu];
        
        //开始回调刷新函数
        delayTime = 0.5f;
        [self schedule:@selector(step:) interval:delayTime];
        
    }
    return self;
}

-(void)initCardsList
{
    //初始化52张牌
    cardsList = [[NSMutableArray alloc]init];
    for(int i=0; i<4; i++)
    {
        switch(i)
        {
            case 0:
            {
                for(int j=0; j<13; j++)
                {
                    Card* cardTemp = [[Card alloc]initObjectWithNum:(j+1)];
                    [cardTemp initObjectWithType:DIAMONDS andNum:j+1];
                    [cardsList addObject:cardTemp];
                    [self addChild:cardTemp z:1];
                }
                break;
            }
            case 1:
            {
                for(int j=0; j<13; j++)
                {
                    Card* cardTemp = [[Card alloc]initObjectWithNum:(13+j+1)];
                    [cardTemp initObjectWithType:CLUB andNum:j+1];
                    [cardsList addObject:cardTemp];
                    //[self addChild:cardTemp z:1];
                }
                break;
            }
            case 2:
            {
                for(int j=0; j<13; j++)
                {
                    Card* cardTemp = [[Card alloc]initObjectWithNum:(26+j+1)];
                    [cardTemp initObjectWithType:HEARTS andNum:j+1];
                    [cardsList addObject:cardTemp];
                    //[self addChild:cardTemp z:1];
                }
                break;
            }
            case 3:
            {
                for(int j=0; j<13; j++)
                {
                    Card* cardTemp = [[Card alloc]initObjectWithNum:(39+j+1)];
                    [cardTemp initObjectWithType:SPADE andNum:j+1];
                    [cardsList addObject:cardTemp];
                    //[self addChild:cardTemp z:1];
                }
                break;
            }
        }
    }
}

-(void)initPlayersList
{
    //初始化playerList，并且显示分数和牌数
    playersList = [[NSMutableArray alloc]init];
    for(int i=0; i<4; i++)
    {
        switch(i)
        {
            case 0:
            {
                Player* playerTemp = [[Player alloc]initWithFile:@"player0.png"];
                playerTemp.anchorPoint = CGPointZero;
                playerTemp.scale = 0.9f;
                [playerTemp setPlayerPos:0];
                [playerTemp initPlayerWithPlayerName:benko PlayerType:User PlayerState:OffTurn];
                [playerTemp setPosition:CGPointMake(60.0f, 15.0f)];
                [playersList addObject:playerTemp];
                [self addChild:[playersList objectAtIndex:0] z:1 tag:2+i];
                
                NSString* scoreString = [NSString stringWithFormat:@"目前总分：%d",0];
                player0TotalScore = [CCLabelTTF labelWithString:scoreString fontName:@"Marker Felt" fontSize:10];
                player0TotalScore.anchorPoint = CGPointZero;
                player0TotalScore.color = ccBLACK;
                player0TotalScore.position    = CGPointMake(110.0f,10.0f);
                [self addChild:player0TotalScore z:1];
                
                NSString* cardNumString = [NSString stringWithFormat:@"目前牌数：%d",13];
                player0CardNum = [CCLabelTTF labelWithString:cardNumString fontName:@"Marker Felt" fontSize:10];
                player0CardNum.anchorPoint = CGPointZero;
                player0CardNum.color = ccBLACK;
                player0CardNum.position    = CGPointMake(330.0f,10.0f);
                [self addChild:player0CardNum z:1];
                
                break;
            }
            case 1:
            {
                Player* playerTemp = [[Player alloc]initPlayerWithRoleList:roleList Postion:1];
                playerTemp.anchorPoint = CGPointZero;
                playerTemp.scale = 0.8f;
                int value = [[roleList objectAtIndex:0]intValue];
                [playerTemp initPlayerWithPlayerName:value PlayerType:AI PlayerState:OffTurn];
                [playerTemp setPosition:CGPointMake(20.0f, 246.0f)];
                [playersList addObject:playerTemp];
                [self addChild:[playersList objectAtIndex:1] z:1 tag:2+i];
                
                NSString* cardNumString = [NSString stringWithFormat:@"目前牌数：%d",13];
                player1CardNum = [CCLabelTTF labelWithString:cardNumString fontName:@"Marker Felt" fontSize:10];
                player1CardNum.anchorPoint = CGPointZero;
                player1CardNum.color = ccBLACK;
                player1CardNum.position    = CGPointMake(8.0f,232.0f);
                [self addChild:player1CardNum z:1];
                
                break;
            }
            case 2:
            {
                Player* playerTemp = [[Player alloc]initPlayerWithRoleList:roleList Postion:2];
                playerTemp.anchorPoint = CGPointZero;
                playerTemp.scale = 0.8f;
                int value = [[roleList objectAtIndex:1]intValue];
                [playerTemp initPlayerWithPlayerName:value PlayerType:AI PlayerState:OffTurn];
                [playerTemp setPosition:CGPointMake(80.0f, 246.0f)];
                [playersList addObject:playerTemp];
                [self addChild:[playersList objectAtIndex:2] z:1 tag:2+i];
                
                NSString* cardNumString = [NSString stringWithFormat:@"目前牌数：%d",13];
                player2CardNum = [CCLabelTTF labelWithString:cardNumString fontName:@"Marker Felt" fontSize:10];
                player2CardNum.anchorPoint = CGPointZero;
                player2CardNum.color = ccBLACK;
                player2CardNum.position    = CGPointMake(120.0f,300.0f);
                [self addChild:player2CardNum z:1];
                
                break;
            }
            case 3:
            {
                Player* playerTemp = [[Player alloc]initPlayerWithRoleList:roleList Postion:3];
                playerTemp.anchorPoint = CGPointZero;
                playerTemp.scale = 0.8f;
                int value = [[roleList objectAtIndex:2]intValue];
                [playerTemp initPlayerWithPlayerName:value PlayerType:AI PlayerState:OffTurn];
                [playerTemp setPosition:CGPointMake(420.0f, 246.0f)];
                [playersList addObject:playerTemp];
                [self addChild:[playersList objectAtIndex:3] z:1 tag:2+i];
                
                NSString* cardNumString = [NSString stringWithFormat:@"目前牌数：%d",13];
                player3CardNum = [CCLabelTTF labelWithString:cardNumString fontName:@"Marker Felt" fontSize:10];
                player3CardNum.anchorPoint = CGPointZero;
                player3CardNum.color = ccBLACK;
                player3CardNum.position    = CGPointMake(410.0f,232.0f);
                [self addChild:player3CardNum z:1];
                
                break;
            }
        }            
    }    
}

-(void)initBackCardsList
{
    for(int i=1; i<4; i++)
    {
        switch(i)
        {
            case 1:
            {
                backCards1 = [[NSMutableArray alloc]init];
                for(int j=0; j<13; j++)
                {
                    CCSprite* backCardTemp = [[CCSprite alloc]initWithFile:@"backcard.png"];
                    backCardTemp.rotation = -90.0f;
                    backCardTemp.scale    = 0.9f;
                    backCardTemp.position = CGPointMake(30.0f, 210.0f-j*13.0f);
                    [self addChild:backCardTemp z:1];
                    [backCards1 addObject:backCardTemp];
                }
                break;
            }
            case 2:
            {
                backCards2 = [[NSMutableArray alloc]init];
                for(int j=0; j<13; j++)
                {
                    CCSprite* backCardTemp = [[CCSprite alloc]initWithFile:@"backcard.png"];
                    backCardTemp.scale    = 0.9f;
                    backCardTemp.position = CGPointMake(180.0f+j*13.0f, 275.0f);
                    [self addChild:backCardTemp z:1];
                    [backCards2 addObject:backCardTemp];
                }
                break;
            }
            case 3:
            {
                backCards3 = [[NSMutableArray alloc]init];
                for(int j=0; j<13; j++)
                {
                    CCSprite* backCardTemp = [[CCSprite alloc]initWithFile:@"backcard.png"];
                    backCardTemp.rotation = 90.0f;
                    backCardTemp.scale    = 0.9f;
                    backCardTemp.position = CGPointMake(450.0f, 210.0f-j*13.0f);
                    [self addChild:backCardTemp z:1];
                    [backCards3 addObject:backCardTemp];
                }
                break;
            }
        }
    }
}

-(void)distributeCards
{
    for(int i=0; i<4; i++)
    {
        switch(i)
        {
            case 0:
            {
                Player* playerTemp = [playersList objectAtIndex:0];
                for(int j=0; j<13; j++)
                {
                    Card* cardTemp = [cardsList objectAtIndex:(j)];
                    cardTemp.visible = YES;
                    cardTemp.anchorPoint = CGPointZero;
                    cardTemp.position = CGPointMake(111.0f+j*18.0f, 30.0f);
                    [playerTemp.cardsOnHand addObject:cardTemp];
                }
                break;
            }
            case 1:
            {
                Player* playerTemp = [playersList objectAtIndex:1];
                for(int j=0; j<13; j++)
                {
                    Card* cardTemp = [cardsList objectAtIndex:(13+j)];
                    [playerTemp.cardsOnHand addObject:cardTemp];
                }
                break;
            }
            case 2:
            {
                Player* playerTemp = [playersList objectAtIndex:2];
                for(int j=0; j<13; j++)
                {
                    Card* cardTemp = [cardsList objectAtIndex:(26+j)];
                    [playerTemp.cardsOnHand addObject:cardTemp];
                }
                break;
            }
            case 3:
            {
                Player* playerTemp = [playersList objectAtIndex:3];
                for(int j=0; j<13; j++)
                {
                    Card* cardTemp = [cardsList objectAtIndex:(39+j)];
                    [playerTemp.cardsOnHand addObject:cardTemp];
                }
                break;
            }
        }
    }
}

-(void)playerTakeTurn
{
    for(int i=0; i<4; i++)
    {
        Player* playerTemp = [playersList objectAtIndex:i];
        if(playerTemp.hasDiamodsThree)
        {
            [playerTemp setPlayerState:TakeTurn];
            lastPos = -1;
            currentPlayer = playerTemp;
            
            return;
        }
    }
}

-(Boolean)testEnd
{
    if(currentPlayer.cardsOnHand.count == 0)
    {
        [endView     setPosition:CGPointMake(400.0f, endView.position.y)];
        [restartMenu setPosition:CGPointMake(400.0f, restartMenu.position.y)];
        [awayMenu    setPosition:CGPointMake(400.0f, awayMenu.position.y)];
        
        gameState = End;
        return YES;
    }
    else
        return NO;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(gameState == Update)
    {
        CGPoint touchPoint = [touch locationInView:[touch view]];
        //NSLog(@"x=%f,y=%f",touchPoint.x,touchPoint.y);
        
        //处理未被选中的牌
        if(touchPoint.y>240.0f && touchPoint.y<290.0f)
        {
            Player* playerTemp = [playersList objectAtIndex:0];
            //处理手牌中从第一张到最后一张
            for(int i=0; i<playerTemp.cardsOnHand.count; i++)
            {
                Card* cardTemp = [playerTemp.cardsOnHand objectAtIndex:i];
                if(touchPoint.x>(111.0f+i*18.0f) && touchPoint.x<(111.0f+(i+1)*18.0f) && !cardTemp.isSelect)
                {
                    playerTemp.selectCardsNum++;
                    cardTemp.isSelect = YES;
                    [cardTemp setPosition:CGPointMake(cardTemp.position.x, cardTemp.position.y+10.0f)];
                    [playerTemp.selectCards addObject:cardTemp];
                    
                    return YES;
                }
                if(i == playerTemp.cardsOnHand.count-1)
                {
                    //处理手牌中最后一张
                    if(touchPoint.x>(111.0f+i*18.0f) && touchPoint.x<(111.0f+i*18.0f+40.0f) && !cardTemp.isSelect)
                    {
                        playerTemp.selectCardsNum++;
                        cardTemp.isSelect = YES;
                        [cardTemp setPosition:CGPointMake(cardTemp.position.x, cardTemp.position.y+10.0f)];
                        [playerTemp.selectCards addObject:cardTemp];
                        
                        return YES;
                    }
                }
            }
        }
        
        //处理被选中的牌
        if(touchPoint.y>230.0f && touchPoint.y<280.0f)
        {
            Player* playerTemp = [playersList objectAtIndex:0];
            //处理手牌中从第一张到最后一张
            for(int i=0; i<playerTemp.cardsOnHand.count; i++)
            {
                Card* cardTemp = [playerTemp.cardsOnHand objectAtIndex:i];
                if(touchPoint.x>(111.0f+i*18.0f) && touchPoint.x<(111.0f+(i+1)*18.0f) && cardTemp.isSelect)
                {
                    playerTemp.selectCardsNum--;
                    cardTemp.isSelect = NO;
                    [cardTemp setPosition:CGPointMake(cardTemp.position.x, cardTemp.position.y-10.0f)];
                    [playerTemp.selectCards removeObject:cardTemp];
                    
                    return YES;
                }
                if(i == playerTemp.cardsOnHand.count-1)
                {
                    //处理手牌中最后一张
                    if(touchPoint.x>(111.0f+i*18.0f) && touchPoint.x<(111.0f+i*18.0f+40.0f) && cardTemp.isSelect)
                    {
                        playerTemp.selectCardsNum--;
                        cardTemp.isSelect = NO;
                        [cardTemp setPosition:CGPointMake(cardTemp.position.x, cardTemp.position.y-10.0f)];
                        [playerTemp.selectCards removeObject:cardTemp];
                        
                        return YES;
                    }
                }
            }
        }
    }
    return YES;
    
}

-(void)drawUpdate
{
    
    CCSprite* menuSprite_off = [CCSprite spriteWithFile:@"bt_menu_off.png"];
    CCSprite* menuSprite_on  = [CCSprite spriteWithFile:@"bt_menu_on.png"];
    CCMenuItemImage* menuImg = [CCMenuItemImage itemFromNormalSprite:menuSprite_off selectedSprite:menuSprite_on target:self selector:@selector(clickMenu:)];
    menuMenu = [CCMenu menuWithItems:menuImg, nil];
    menuMenu.anchorPoint = CGPointZero;
    menuMenu.scale       = 1.0f;
    menuMenu.position    = CGPointMake(35.0f, 20.0f);
    [self addChild:menuMenu z:1];
    
    CCSprite* backSprite_off = [CCSprite spriteWithFile:@"bt_back_off.png"];
    CCSprite* backSprite_on  = [CCSprite spriteWithFile:@"bt_back_on.png"];
    CCMenuItemImage* backImg = [CCMenuItemImage itemFromNormalSprite:backSprite_off selectedSprite:backSprite_on target:self selector:@selector(clickBack:)];
    backMenu = [CCMenu menuWithItems:backImg, nil];
    backMenu.anchorPoint = CGPointZero;
    backMenu.scale       = 1.0f;
    backMenu.position    = CGPointMake(445.0f, 20.0f);
    [self addChild:backMenu z:1];
    
    CCSprite* takeSprite_off = [CCSprite spriteWithFile:@"bt_take_off.png"];
    CCSprite* takeSprite_on  = [CCSprite spriteWithFile:@"bt_take_on.png"];
    CCMenuItemImage* takeImg = [CCMenuItemImage itemFromNormalSprite:takeSprite_off selectedSprite:takeSprite_on target:self selector:@selector(clickTake:)];
    takeMenu = [CCMenu menuWithItems:takeImg, nil];
    takeMenu.visible     = NO;
    takeMenu.anchorPoint = CGPointZero;
    takeMenu.scale       = 0.6f;
    takeMenu.position    = CGPointMake(125.0f, 120.0f);
    [self addChild:takeMenu z:1];
    
    CCSprite* passSprite_off = [CCSprite spriteWithFile:@"bt_pass_off.png"];
    CCSprite* passSprite_on  = [CCSprite spriteWithFile:@"bt_pass_on.png"];
    CCMenuItemImage* passImg = [CCMenuItemImage itemFromNormalSprite:passSprite_off selectedSprite:passSprite_on target:self selector:@selector(clickPass:)];
    passMenu = [CCMenu menuWithItems:passImg, nil];
    passMenu.visible     = NO;
    passMenu.anchorPoint = CGPointZero;
    passMenu.scale       = 0.6f;
    passMenu.position    = CGPointMake(355.0f, 120.0f);
    [self addChild:passMenu z:1];
    
    CCSprite* sortSprite_off = [CCSprite spriteWithFile:@"bt_sort_off.png"];
    CCSprite* sortSprite_on  = [CCSprite spriteWithFile:@"bt_sort_on.png"];
    CCMenuItemImage* sortImg = [CCMenuItemImage itemFromNormalSprite:sortSprite_off selectedSprite:sortSprite_on target:self selector:@selector(clickSort:)];
    sortMenu = [CCMenu menuWithItems:sortImg, nil];
    sortMenu.visible     = YES;
    sortMenu.anchorPoint = CGPointZero;
    sortMenu.scale       = 0.6f;
    sortMenu.position    = CGPointMake(400.0f, 80.0f);
    [self addChild:sortMenu z:1];
    
    if(currentPlayer.playerType == User)
    {
        takeMenu.visible = YES;
        passMenu.visible = YES;
    }
    
}

-(void)drawNotice
{
    CCSprite* noticeSprite_off = [CCSprite spriteWithFile:@"bg_notice.png"];
    CCSprite* noticeSprite_on  = [CCSprite spriteWithFile:@"bg_notice.png"];
    CCMenuItemImage* noticeImg = [CCMenuItemImage itemFromNormalSprite:noticeSprite_off selectedSprite:noticeSprite_on target:self selector:@selector(clickNotice:)];
    noticeMenu = [CCMenu menuWithItems:noticeImg, nil];
    noticeMenu.visible       = NO;
    noticeMenu.anchorPoint   = CGPointZero;
    noticeMenu.position      = CGPointMake(240.0f, 160.0f);
    [self addChild:noticeMenu z:2];
}

-(void)drawEnd
{
    endView               = [CCSprite spriteWithFile:@"bg_end.png"];
    endView.position      = CGPointMake(240.0f, 160.0f); 
    endView.visible       = NO;
    [self addChild:endView z:2];
    
    CCSprite* restartSprite_off = [CCSprite spriteWithFile:@"bt_restart_off.png"];
    CCSprite* restartSprite_on  = [CCSprite spriteWithFile:@"bt_restart_on.png"];
    CCMenuItemImage* restartImg = [CCMenuItemImage itemFromNormalSprite:restartSprite_off selectedSprite:restartSprite_on target:self selector:@selector(clickRestart:)];
    restartMenu                 = [CCMenu menuWithItems:restartImg, nil];
    restartMenu.scale           = 0.8f;
    restartMenu.anchorPoint     = CGPointZero;
    restartMenu.position        = CGPointMake(240.0f, 130.0f);
    restartMenu.visible         = NO;
    [self addChild:restartMenu z:2];
    
    CCSprite* awaySprite_off    = [CCSprite spriteWithFile:@"bt_backmenu_off.png"];
    CCSprite* awaySprite_on     = [CCSprite spriteWithFile:@"bt_backmenu_on.png"];
    CCMenuItemImage* awayImg    = [CCMenuItemImage itemFromNormalSprite:awaySprite_off selectedSprite:awaySprite_on target:self selector:@selector(clickAway:)];
    awayMenu                    = [CCMenu menuWithItems:awayImg, nil];
    awayMenu.scale              = 0.7f;
    awayMenu.anchorPoint        = CGPointZero;
    awayMenu.position           = CGPointMake(240.0f, 90.0f);
    awayMenu.visible            = NO;
    [self addChild:awayMenu z:2];
}

-(void)drawMenu
{
    menuView = [CCSprite spriteWithFile:@"bg_menu.png"];
    menuView.visible  = NO;
    menuView.position = CGPointMake(240.0f, 160.0f);
    [self addChild:menuView z:2];
    
    CCSprite* pauseSprite_off = [CCSprite spriteWithFile:@"bt_pause_off.png"];
    CCSprite* pauseSprite_on  = [CCSprite spriteWithFile:@"bt_pause_on.png"];
    pauseImg = [CCMenuItemImage itemFromNormalSprite:pauseSprite_off selectedSprite:pauseSprite_on target:self selector:@selector(clickPause:)];
    
    CCSprite* setSprite_off   = [CCSprite spriteWithFile:@"bt_set_off.png"];
    CCSprite* setSprite_on    = [CCSprite spriteWithFile:@"bt_set_on.png"];
    setImg   = [CCMenuItemImage itemFromNormalSprite:setSprite_off selectedSprite:setSprite_on target:self selector:@selector(clickSet:)];
    
    menuList = [CCMenu menuWithItems:pauseImg, setImg ,nil];
    menuList.anchorPoint    = CGPointZero;
    menuList.position       = CGPointMake(240.0f, 160.0f);
    menuList.scale          = 0.8f;
    menuList.visible        = NO;
    [menuList alignItemsVerticallyWithPadding:30.0f];
    [self addChild:menuList z:2];
}

-(void)clickMenu:(id)sender
{
    if(gameState == Update)
    {
        menuView.visible  = YES;
        menuList.visible  = YES;
        menuView.position = CGPointMake(400.0f, 160.0f);
        menuList.position = CGPointMake(400.0f, 160.0f);
        [menuView runAction:[CCMoveTo actionWithDuration:0.1f position:CGPointMake(240.0f, 160.0f)]];
        [menuList runAction:[CCMoveTo actionWithDuration:0.1f position:CGPointMake(240.0f, 160.0f)]];
        gameState = Menu;
    }
}

-(void)clickBack:(id)sender
{
    if(gameState == Update)
    {
        
    }
}

-(void)clickTake:(id)sender
{
    if(gameState == Update)
    {
        Player* playerTemp = [playersList objectAtIndex:0];
        if(playerTemp.selectCardsNum != 0)//需要加多一个判断出的牌合不合理，这是属于逻辑方面的内容
        {
            if( (playerTemp.selectDiamodsThree && lastPos == -1) || (lastPos != -1) )
            {
                [playerTemp.lastCards removeAllObjects];
                
                for(int i=0; i<playerTemp.selectCardsNum; i++)
                {
                    Card* cardTemp = [playerTemp.selectCards objectAtIndex:i];
                    
                    [playerTemp.lastCards addObject:cardTemp];
                    
                    [cardTemp setIsTake:YES];
                    [cardTemp setPosition:CGPointMake(170.0f+i*13.0f, 100.0f)];
                    [self reorderChild:cardTemp z:1];
                    [playerTemp.cardsOnHand removeObject:cardTemp];
                }
                [playerTemp.selectCards removeAllObjects];
                playerTemp.selectCardsNum =0;
                
                [playerTemp setOnHandCardsNum:playerTemp.cardsOnHand.count];
                for(int i=0; i<playerTemp.onHandCardsNum; i++)
                {
                    Card* cardTemp = [playerTemp.cardsOnHand objectAtIndex:i];
                    [cardTemp setPosition:CGPointMake(111.0f+i*18.0f, 30.0f)];
                }
                
                lastPos = 0;
                
                [player0CardNum setString:[NSString stringWithFormat:@"目前牌数：%d",currentPlayer.cardsOnHand.count]];
                
                if(![self testEnd])
                {
                    currentPlayer = [playersList objectAtIndex:1];
                    playerTemp.playerState = OffTurn;
                    currentPlayer.playerState = TakeTurn;
                }
                
                takeMenu.visible = NO;
                passMenu.visible = NO;
                
            }
            else
            {
                [playerTemp.selectCards removeAllObjects];
                playerTemp.selectCardsNum =0;
                
                [playerTemp setOnHandCardsNum:playerTemp.cardsOnHand.count];
                for(int i=0; i<playerTemp.onHandCardsNum;i++)
                {
                    Card* cardTemp = [playerTemp.cardsOnHand objectAtIndex:i];
                    [cardTemp setPosition:CGPointMake(111.0f+i*18.0f, 30.0f)];
                    [cardTemp setIsSelect:NO];
                }
                
                noticeMenu.scale = 0.0f;
                noticeMenu.visible = YES;
                [noticeMenu runAction:[CCScaleTo actionWithDuration:0.1f scale:1.0f]];
                gameState = Notice;
            }
        }
        else
        {
            noticeMenu.scale = 0.0f;
            noticeMenu.visible = YES;
            [noticeMenu runAction:[CCScaleTo actionWithDuration:0.1f scale:1.0f]];
            gameState = Notice;
        }
    }
}

-(void)clickPass:(id)sender
{
    if(gameState == Update)
    {
        Player* playerTemp = [playersList objectAtIndex:0];
        if((playerTemp.hasDiamodsThree && lastPos == -1) || (lastPos == 0))
        {
            [playerTemp.selectCards removeAllObjects];
            playerTemp.selectCardsNum =0;
            
            [playerTemp setOnHandCardsNum:playerTemp.cardsOnHand.count];
            for(int i=0; i<playerTemp.onHandCardsNum;i++)
            {
                Card* cardTemp = [playerTemp.cardsOnHand objectAtIndex:i];
                [cardTemp setPosition:CGPointMake(111.0f+i*18.0f, 30.0f)];
                [cardTemp setIsSelect:NO];
            }
            
            noticeMenu.scale = 0.0f;
            noticeMenu.visible = YES;
            [noticeMenu runAction:[CCScaleTo actionWithDuration:0.1f scale:1.0f]];
            gameState = Notice;
        }
        else
        {
            [playerTemp.lastCards removeAllObjects];
            [playerTemp.selectCards removeAllObjects];
            playerTemp.selectCardsNum = 0;
            
            for(int i=0; i<playerTemp.onHandCardsNum; i++)
            {
                Card* cardTemp = [playerTemp.cardsOnHand objectAtIndex:i];
                cardTemp.isSelect = NO;
                [cardTemp setPosition:CGPointMake(111.0f+i*18.0f, 30.0f)];
            }
            
            currentPlayer = [playersList objectAtIndex:1];
            playerTemp.playerState = OffTurn;
            currentPlayer.playerState = TakeTurn;
            
            takeMenu.visible = NO;
            passMenu.visible = NO;
            
        }
    }
}

-(void)clickSort:(id)sender
{
    if(gameState == Update)
    {
        
    }
}

-(void)clickNotice:(id)sender
{
    noticeMenu.visible = NO;
    gameState = Update;
}

-(void)clickRestart:(id)sender
{
    [self removeFromParentAndCleanup:YES];
    
    CCScene* scene = [CCScene node];
    [scene addChild:[CDDMainGame node]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:scene]];
}

-(void)clickAway:(id)sender
{
    
}

-(void)clickPause:(id)sender
{
    
}

-(void)clickSet:(id)sender
{
    
}

-(void)step:(ccTime)delayTime
{
    switch(gameState)
    {
        case Update:
        {
            [self gameUpdate];
        }break;
        case Menu:
        {
            //[self gameMenu];
        }break;
        case Pause:break;
        case Continue:break;
        case Escape:break;
        case Notice:
        {
            //[self gameNotice];
        }break;
        case End:
        {
            [self gameEnd];
        }break;
        default:break;
    }
}

-(void)gameUpdate
{
    switch(currentPlayer.playerType)
    {
        case AI:
        {
            [currentPlayer selectCardsAction:playersList];
            [currentPlayer showCard:playersList byId:self];
            
            if(currentPlayer.lastCards.count != 0)
            {
                lastPos = currentPlayer.playerPos;
            }
            
            if(currentPlayer.playerPos == 1)
            {
                int cardNum = currentPlayer.cardsOnHand.count;
                NSLog(@"%d",cardNum);
                [player1CardNum setString:[NSString stringWithFormat:@"目前牌数：%d",cardNum]];
                for(int i=backCards1.count-1; i>=cardNum; i--)
                {
                    CCSprite* backTemp = [backCards1 objectAtIndex:i];
                    backTemp.visible   =  NO;
                    [backCards1 removeLastObject];
                }
            }
            else if(currentPlayer.playerPos == 2)
            {
                int cardNum = currentPlayer.cardsOnHand.count;
                NSLog(@"%d",cardNum);
                [player2CardNum setString:[NSString stringWithFormat:@"目前牌数：%d",cardNum]];
                for(int i=backCards2.count-1; i>=cardNum; i--)
                {
                    CCSprite* backTemp = [backCards2 objectAtIndex:i];
                    backTemp.visible   =  NO;
                    [backCards2 removeLastObject];
                }
            }
            else if(currentPlayer.playerPos == 3)
            {
                int cardNum = currentPlayer.cardsOnHand.count;
                NSLog(@"%d",cardNum);
                [player3CardNum setString:[NSString stringWithFormat:@"目前牌数：%d",cardNum]];
                for(int i=backCards3.count-1; i>=cardNum; i--)
                {
                    CCSprite* backTemp = [backCards3 objectAtIndex:i];
                    backTemp.visible   =  NO;
                    [backCards3 removeLastObject];
                }
            }
            
            if(![self testEnd])
            {
                currentPlayer.playerState = OffTurn;
                currentPlayer = [playersList objectAtIndex:(currentPlayer.playerPos+1)%4];
                currentPlayer.playerState = TakeTurn;
            }
            
        }break;
        case User:
        {
            takeMenu.visible = YES;
            passMenu.visible = YES;
            
            if(currentPlayer.lastCards.count != 0)
            {
                for(int i=0; i<currentPlayer.lastCards.count; i++)
                {
                    Card* cardTemp = [currentPlayer.lastCards objectAtIndex:i];
                    cardTemp.visible = NO;
                }
            }
            [currentPlayer.lastCards removeAllObjects];
            
        }break;
    }
}

-(void)gameNotice
{
    noticeMenu.visible = YES;
    [noticeMenu runAction:[CCScaleTo actionWithDuration:0.1f scale:1.0f]];
}

-(void)gameEnd
{
    [endView     runAction:[CCMoveTo actionWithDuration:0.1f position:CGPointMake(240.0f, endView.position.y)]];
    [restartMenu runAction:[CCMoveTo actionWithDuration:0.1f position:CGPointMake(240.0f, restartMenu.position.y)]];
    [awayMenu    runAction:[CCMoveTo actionWithDuration:0.1f position:CGPointMake(240.0f, awayMenu.position.y)]];
    
    endView.visible     = YES;
    restartMenu.visible = YES;
    awayMenu.visible    = YES;
}

-(void)gameMenu
{
    [menuView runAction:[CCMoveTo actionWithDuration:0.1f position:CGPointMake(240.0f, 160.0f)]];
    [menuList runAction:[CCMoveTo actionWithDuration:0.1f position:CGPointMake(240.0f, 160.0f)]];
}

//注册事件
- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
	[super onEnter];
}

//注销事件
- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
