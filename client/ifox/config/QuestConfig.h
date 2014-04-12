//
//  QuestConfig.h
//  sc
//
//  Created by fox on 13-10-15.
//
//

#import "GameConfig.h"


//<q id="100" story="117" rank="C" img="IC3101" name="【探索】杀戮之地" owner="工匠协会" time="" des="在【精灵森林】里面的绿地，莫名其妙的发生了小鹿被残忍杀戮的事件，探索这个区域发现一些线索" cdes="【探索】【精灵森林】的【杀戮之地】" ci0="" ci1="" cserch="103" cserchper="1.0" calchemy="" cgroundlv="" cgshoplv="" chomelv="" cworklv="" ckill0="" ckillnum0="" ckill1="" ckillnum1="" cgold="" comGold="1000" comi0="" cominum0="" comi1="" comi2="" comi3=""/>
//<q id="101" story="117" rank="B" img="IC1701" name="死神" owner="工匠协会" time="" des="【精灵森林】的【杀戮之地】" cdes="【探索】【斯赛提卡湖】的【凉风西湖畔】" ci0="" ci1="" cserch="103" calchemy="" cgroundlv="" cgshoplv="" chomelv="" cworklv="" ckill0="" ckillnum0="" ckill1="" ckillnum1="" cgold="" comGold="2000" comi0="" cominum0="" comi1="" comi2="" comi3=""/>
//<q id="110" story="117" rank="C" img="IC3081" name="【探索】被困的水精灵" owner="一个好心人" time="" des="在【斯塞提卡湖】钓鱼时听到了呼救声，循声望去的时候发现是个被魔物围困的水精灵，谁能前去解救她呢？" cdes="【探索】【斯赛提卡湖】的【凉风西湖畔】" ci0="" ci1="" cserch="103" calchemy="" cgroundlv="" cgshoplv="" chomelv="" cworklv="" ckill0="" ckillnum0="" ckill1="" ckillnum1="" cgold="" comGold="2000" comi0="" cominum0="" comi1="" comi2="" comi3=""/>



@interface QuestConfigData : NSObject
{
    
}

@property( nonatomic ) int QuestID , NextID , StoryID , WorkRank;
@property( nonatomic , assign ) NSString* Rank;
@property( nonatomic , assign ) NSString* Img;
@property( nonatomic , assign ) NSString* Name;
@property( nonatomic , assign ) NSString* Owner;
@property( nonatomic , assign ) NSString* Time;
@property( nonatomic , assign ) NSString* Des;
@property( nonatomic , assign ) NSString* CDes;
@property( nonatomic ) float CSerchPer;
@property( nonatomic ) int CItem0 , CItem1 , CItemNum0 , CItemNum1 , CSerch , CAlchemy;
@property( nonatomic ) int CGold , CGroundLV , CShopLV , CHomeLV , CWorkLV;
@property( nonatomic ) int CKill0 , CKillNum0 , CKill1 , CKillNum1;
@property( nonatomic ) int ComGold , ComItem0 , ComItem1 , ComItem2 , ComItem3;
@property( nonatomic ) int ComItemNum0 , ComItemNum1 , ComItemNum2 , ComItemNum3;

@end





@interface QuestConfig : GameConfig
{
    
}
@property( nonatomic , assign ) NSMutableDictionary* Dic;

- ( QuestConfigData* ) getQuest:( int )d;

+ ( QuestConfig* ) instance;


@end
