//
//  CDDSetting.h
//  CDDGame
//
//  Created by kwan terry on 11-10-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CDDData.h"
@interface CDDSetting : CCLayer 
{
    UISlider* musicVolumn;
    UISlider* effectVolumn;
    
    UITableView* userTable;
    NSArray*     userList;
    
    UIView* userView;
    
    UITextField* userNameText;
    
    CDDData* sqldata;
    
    Boolean userNameIsEmpty;
    
    //一些提示的标签
    CCLabelTTF * tips;

}
+(CCScene *) scene;
-(void) changeMusicVol:(id)sender;
-(void) changeEffectVol:(id)sender;

@property (retain) UITextField* userNameText;
@property (retain) UISlider*    musicVolumn;
@property (retain) UISlider*    effectVolumn;
@property (retain) UITableView* userTable;
@property (retain) NSArray*     userList;
@property (nonatomic,retain) UIView*      userView;

@end
