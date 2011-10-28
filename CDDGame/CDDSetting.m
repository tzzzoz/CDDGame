//
//  CDDSetting.m
//  CDDGame
//
//  Created by kwan terry on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CDDSetting.h"
#import "CDDMenu.h"
#import "SimpleAudioEngine.h"
#import "CJSONDeserializer.h"

@implementation CDDSetting

@synthesize userNameText;
@synthesize musicVolumn;
@synthesize effectVolumn;
@synthesize userList;
@synthesize userTable;
@synthesize userView;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CDDSetting *layer = [CDDSetting node];
	
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
        
        userNameIsEmpty = YES;
        
        sqldata = [[CDDData alloc]init];
        //打开数据库
        [sqldata openDB];
        [sqldata createUserSettingTable];
        
        //添加设置背景
        CCSprite* settingback = [CCSprite spriteWithFile:@"settingback.png"];
        settingback.anchorPoint = CGPointZero;
        [self addChild:settingback z:0 tag:1];
        
        //添加加号按钮
        CCSprite* add1btn_off = [CCSprite spriteWithFile:@"bt_add_off.png"];
        CCSprite* add1btn_on  = [CCSprite spriteWithFile:@"bt_add_on.png"];
        CCMenuItemImage* add1btnImg = [CCMenuItemImage itemFromNormalSprite:add1btn_off selectedSprite:add1btn_on target:self selector:@selector(clickAdd1:)];
        
        CCSprite* add2btn_off = [CCSprite spriteWithFile:@"bt_add_off.png"];
        CCSprite* add2btn_on  = [CCSprite spriteWithFile:@"bt_add_on.png"];
        CCMenuItemImage* add2btnImg = [CCMenuItemImage itemFromNormalSprite:add2btn_off selectedSprite:add2btn_on target:self selector:@selector(clickAdd2:)];
        
        CCMenu* addbtn = [CCMenu menuWithItems:add1btnImg, add2btnImg,nil];
        [addbtn alignItemsVerticallyWithPadding:30.0f];
        addbtn.anchorPoint = CGPointZero;
        addbtn.scale = 0.5f;
        addbtn.position    = CGPointMake(435.0f, 147.0f);
        [self addChild:addbtn z:2 tag:1]; 
        
        //添加减号按钮
        CCSprite* sub1btn_off = [CCSprite spriteWithFile:@"bt_sub_off.png"];
        CCSprite* sub1btn_on  = [CCSprite spriteWithFile:@"bt_sub_on.png"];
        CCMenuItemImage* sub1btnImg = [CCMenuItemImage itemFromNormalSprite:sub1btn_off selectedSprite:sub1btn_on target:self selector:@selector(clickSub1:)];
        
        CCSprite* sub2btn_off = [CCSprite spriteWithFile:@"bt_sub_off.png"];
        CCSprite* sub2btn_on  = [CCSprite spriteWithFile:@"bt_sub_on.png"];
        CCMenuItemImage* sub2btnImg = [CCMenuItemImage itemFromNormalSprite:sub2btn_off selectedSprite:sub2btn_on target:self selector:@selector(clickSub2:)];
        
        CCMenu* subbtn = [CCMenu menuWithItems:sub1btnImg, sub2btnImg,nil];
        [subbtn alignItemsVerticallyWithPadding:30.0f];
        subbtn.anchorPoint = CGPointZero;
        subbtn.scale = 0.5f;
        subbtn.position = CGPointMake(158.0f, 147.0f);
        [self addChild:subbtn z:2 tag:2]; 
        
        //添加确定和重置按钮
        CCSprite* surebtn_off = [CCSprite spriteWithFile:@"bt_sure_off.png"];
        CCSprite* surebtn_on  = [CCSprite spriteWithFile:@"bt_sure_on.png"];
        CCMenuItemImage* surebtnImg = [CCMenuItemImage itemFromNormalSprite:surebtn_off selectedSprite:surebtn_on target:self selector:@selector(clickSure:)];
        
        CCSprite* resetbtn_off = [CCSprite spriteWithFile:@"bt_reset_off.png"];
        CCSprite* resetbtn_on  = [CCSprite spriteWithFile:@"bt_reset_on.png"];
        CCMenuItemImage* resetbtnImg = [CCMenuItemImage itemFromNormalSprite:resetbtn_off selectedSprite:resetbtn_on target:self selector:@selector(clickReset:)];
        
        CCMenu* operbtn = [CCMenu menuWithItems:surebtnImg, resetbtnImg, nil];
        [operbtn alignItemsHorizontallyWithPadding:400.0f];
        operbtn.anchorPoint = CGPointZero;
        operbtn.scale = 0.5f;
        operbtn.position = CGPointMake(240.0f, 50.0f);
        [self addChild:operbtn z:2 tag:3];
        
        //添加下拉按钮
        CCSprite* setdownbtn_off = [CCSprite spriteWithFile:@"bt_setdown_off.png"]; 
        CCSprite* setdownbtn_on  = [CCSprite spriteWithFile:@"bt_setdown_on.png"];
        CCMenuItemImage* setdownbtnImg = [CCMenuItemImage itemFromNormalSprite:setdownbtn_off selectedSprite:setdownbtn_on target:self selector:@selector(clickSetdown:)];
        CCMenu* setdownbtn = [CCMenu menuWithItems:setdownbtnImg, nil];
        setdownbtn.position = CGPointMake(265.0f, 166.0f);
        setdownbtn.scale = 0.6f;
        [self addChild:setdownbtn z:2 tag:4];
        
        //用户编辑框
        userNameText = [[UITextField alloc]initWithFrame:CGRectMake(140.0f, 180.0f, 150.0f, 25.0f)];
        CGAffineTransform rotation2 = CGAffineTransformMakeRotation(1.57079633);
        [userNameText setTransform:rotation2];
        [userNameText setFrame:CGRectMake(217.0f, 205.0f, 26.0f, 128.0f)];
        [userNameText setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [userNameText setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [userNameText addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [userNameText addTarget:self action:@selector(touchTextFieldAction:) forControlEvents:UIControlEventTouchDown];
        userNameText.backgroundColor = [UIColor whiteColor];
        userNameText.textColor       = [UIColor blackColor];
        userNameText = [userNameText autorelease];
        [[[[CCDirector sharedDirector]openGLView]window]addSubview:userNameText];
        
        //初始化控制音量声音的滚动条 
        musicVolumn = [[UISlider alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 238.0f, 15.0f)];
        CGAffineTransform rotation = CGAffineTransformMakeRotation(1.57079633);
        [musicVolumn setTransform:rotation];
        [musicVolumn setFrame:CGRectMake(165.0f, 173.0f, 15.0f, 243.0f)];
        [musicVolumn addTarget:self action:@selector(changeMusicVol:) forControlEvents:UIControlEventValueChanged];
        musicVolumn.maximumValue = 1.0f;
        musicVolumn.minimumValue = 0.0f;
        musicVolumn = [musicVolumn autorelease];
        [[[[CCDirector sharedDirector]openGLView]window]addSubview:musicVolumn];
        
        //初始化控制音效声音得滚动条
        effectVolumn = [[UISlider alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 238.0f, 15.0f)];
        CGAffineTransform rotation1 = CGAffineTransformMakeRotation(1.57079633);
        [effectVolumn setTransform:rotation1];
        [effectVolumn setFrame:CGRectMake(110.0f, 173.0f, 15.0f, 243.0f)];
        [effectVolumn addTarget:self action:@selector(changeEffectVol:) forControlEvents:UIControlEventValueChanged];
        effectVolumn.maximumValue = 1.0f;
        effectVolumn.minimumValue = 0.0f;
        effectVolumn = [effectVolumn autorelease];
        [[[[CCDirector sharedDirector]openGLView]window]addSubview:effectVolumn];
        
        //播放背景音乐
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"playing.wav" loop:1];

        //初始化下拉框和预选用户名
        userList = [[NSArray alloc]initWithObjects:@"kate",@"bill",@"lili",@"peter",nil];
        userTable = [[UITableView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 480.0f, 320.0f)];
        CGAffineTransform rotation4 = CGAffineTransformMakeRotation(1.57079633);
        [userTable setTransform:rotation4];
        [userTable setFrame:CGRectMake(20.0f, 20.0f, 280.0f, 440.0f)];
        userTable.dataSource = (id)self;
        userTable.delegate   = (id)self;
        [userTable setHidden:YES];
        [userTable autorelease];
        [[[[CCDirector sharedDirector]openGLView]window]addSubview:userTable];
        
        
        //初始化用户设置
        userNameText.text = [sqldata selectLastName];
        musicVolumn.value = [sqldata gettingMvol];
        //设置背景音乐的音量大小
        [CDAudioManager sharedManager].backgroundMusic.volume = musicVolumn.value;
        //音效音乐的音量大小
        effectVolumn.value = [sqldata gettingEvol];        
    }
    return self;
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
    [super registerWithTouchDispatcher];
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

//返回项的数目
-(NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    return userList.count;
}

//返回每项的高度
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

//初始化下拉框的列表的值
-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellid = @"userTable id";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid]autorelease];
    }
    cell.textLabel.text = (NSString*)[userList objectAtIndex:indexPath.row];
    cell.textLabel.font = userNameText.font;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    return cell;
}

//当选择下拉列表中的一行时，设置文本框中的值，隐藏下拉列表
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    userNameText.text=(NSString*)[userList objectAtIndex:indexPath.row];
    //NSLog(@"userNameText.text=%@",userNameText.text);
    [userTable setHidden:YES];    
}

-(void) clickAdd1: (id)sender
{
    
}

-(void) clickAdd2: (id)sender
{
    
}

-(void) clickSub1: (id)sender
{
    
}

-(void) clickSub2: (id)sender
{
    
}

-(void) clickSure: (id)sender
{
    //--------------------//
    userNameText.text = [userNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //用户名不为空，才可以确认
    if (!userNameIsEmpty)
    {
        //判断用户名是否存在，存在则更新记录，不存在则新建记录
        if ([sqldata validateUserName:userNameText.text])
        {
            [sqldata createUserSetting:userNameText.text withMvol:musicVolumn.value andEvol:effectVolumn.value];
        }
        else
        {
            [sqldata updateUserSetting:userNameText.text withMvol:musicVolumn.value andEvol:effectVolumn.value];
        }
        //确定当前用户
        [sqldata useName:userNameText.text];

        //这里移除输入框和滚动条
        [userNameText removeFromSuperview];
        [musicVolumn removeFromSuperview];
        [effectVolumn removeFromSuperview];
        
        //关闭数据库
        [sqldata closeDB];
        //这里关闭背景音乐
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        //切换到下一个场景
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.3f scene:[CDDMenu scene]]];
        
        [sqldata displayRecord];
    }
}

-(void) clickSetdown: (id)sender
{
    [userTable setHidden:NO];
}

-(void) clickReset: (id)sender
{
    
}
         
-(void) changeMusicVol:(id)sender
{
    
}

-(void) changeEffectVol:(id)sender
{
    
}

-(void) textFieldAction: (id)sender
{
    NSLog(@"textFieldAction");
    userNameText.text = [userNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //输入的用户名为空，给出提示
    if ([userNameText.text isEqualToString:@""] || userNameText.text == nil) 
    {
        [tips setString:@"用户名不能为空"];
        userNameIsEmpty = YES;
        id action = [CCFadeIn actionWithDuration:1.5f];
        id action2 = [CCFadeOut actionWithDuration:1.5f];
        [tips runAction:[CCSequence actions:action,action2,nil]];
    }
    else
    {
        userNameIsEmpty = NO;
    }
    
    [sqldata displayRecord];
}

-(void) touchTextFieldAction: (id)sender
{
    
}

- (void) dealloc
{
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
