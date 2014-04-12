//
//  GuideConfig.h
//  sc
//
//  Created by fox on 13-11-28.
//
//

#import "GameConfig.h"

//
//<guide id="2012" activeScene="profession" mask="1" next="-1" >
//<g str="现在介绍一下【教会】功能" pos="0" />
//<g str="面板左方会列有可以转职的【职业】，最初只有【下级】职业，随着职业等级的提升，会开启【高级】职业。" pos="0" />
//<g str="有的【高级】职业可能还需要几种【下级】职业的到达一定等级，当然某些角色可能一开始就处于【高级】职业。" pos="0" />
//<g str="最终的【隐藏职业】转职条件也相当苛刻，除了下级职业外其他职业都是隐藏的，请慢慢探索吧。" pos="0" />
//</guide>
//
//<guide id="10001" checkScene="battle" mask="1" next="-1" >
//<g cR="4" showName="1" name="????" str="可怜的小鹿...（女精灵对着动物的尸体喃喃自语。）" pos="0" aR="C" />
//<g cR="4" showName="1" name="????" str="啊！人类！是你干的好事吗？！" pos="0" aR="C" />
//</guide>
//<guide id="10002" checkScene="battle" mask="1" next="-1" >
//<g cR="4" showName="1" name="????" str="。。。。。。。噢，原来是场误会。但，到底是谁这么残忍。对了，忘了自我介绍，你好，我叫塞维尔，住在这片森林里的精灵。" pos="0" aR="B" />
//<g cR="4" showName="1" str="我可以跟随你一起探索么，请一定帮我找出凶手。" pos="0" aR="B" />
//<g cR="4" showName="1" str="现在您可以在酒馆雇佣【塞维尔】了，她属于特殊佣兵，雇佣她并且探索这片森林，有一定几率触发【随机事件】并找出凶手。" pos="0" aR="B" />
//</guide>
//
//<guide id="10011" checkScene="battle" mask="1" next="-1" >
//<g cR="4" showName="1" str="山东省地说道" pos="0" aR="C" />
//</guide>
//<guide id="10012" checkScene="battle" mask="1" next="-1" >
//<g cR="4" showName="1" str="。。。。。。。我跑了。嘻嘻" pos="0" aR="B" />
//</guide>
//<guide id="10021" checkScene="battle" mask="1" next="-1" >
//<g cR="4" showName="1" str="少的地方" pos="0" aR="C" />
//</guide>
//<guide id="10022" checkScene="battle" mask="1" next="-1" >
//<g cR="4" showName="1" str="是的发生的" pos="0" aR="B" />
//</guide>

@interface GuideConfigStep : NSObject
@property ( nonatomic , assign ) NSString* Str;
@property ( nonatomic , assign ) NSString* Alert;

@property ( nonatomic ) int Font;
@property ( nonatomic ) int Employ;
@property ( nonatomic ) int CreatureRight;
@property ( nonatomic ) int CreatureMiddle;
@property ( nonatomic ) int CreatureLeft;
@property ( nonatomic ) int StopMusic;

@property ( nonatomic , assign ) NSString* ActionRight;
@property ( nonatomic , assign ) NSString* ActionMiddle;
@property ( nonatomic , assign ) NSString* ActionLeft;

@property ( nonatomic ) float LeftMoveRight;
@property ( nonatomic ) float RightMoveLeft;

@property ( nonatomic ) float RotationLeft;
@property ( nonatomic ) float RotationRight;

@property ( nonatomic ) float LeftRight , UpDown;

@property ( nonatomic ) float FadeInRight;
@property ( nonatomic ) float FadeOutRight;
@property ( nonatomic ) float FadeInLeft;
@property ( nonatomic ) float FadeOutLeft;
@property ( nonatomic ) float FadeInMiddleLeft , FadeInMiddleRight;
@property ( nonatomic ) float FadeOutMiddleLeft , FadeOutMiddleRight;
@property ( nonatomic ) int Day , ItemID , Gold;
@property ( nonatomic ) float FadeIn , FadeOut , White;
@property ( nonatomic , assign ) NSString* UI;
@property ( nonatomic , assign ) NSString* Music;
@property ( nonatomic , assign ) NSString* Sound;
@property ( nonatomic , assign ) NSString* Name;
@property ( nonatomic ) int NameID;

@end


@interface GuideConfigData : NSObject
@property ( nonatomic , assign ) NSMutableArray* Steps;
@property ( nonatomic ) int GuideID;
@property ( nonatomic ) int NextID , Mask;
@property ( nonatomic ) int Story , NextStory;
@property ( nonatomic ) int CheckBattle , CheckBattleEnd;
@property ( nonatomic ) float BGFadeRight , BGFadeLeft , BGFade;
@property ( nonatomic , assign ) NSString* BG;
@property ( nonatomic , assign ) NSString* NextScene;
@property ( nonatomic , assign ) NSString* ActiveScene;
@property ( nonatomic , assign ) NSString* CheckScene;


@end

@interface GuideConfig : GameConfig
{
    
}

@property ( nonatomic , assign ) NSMutableDictionary* Dic;
@property ( nonatomic , assign ) NSMutableDictionary* StoryDic;

+ ( GuideConfig* ) instance;

- ( GuideConfigData* ) getStoryData:( int )s;
- ( GuideConfigData* ) getData:( int )i;

@end



