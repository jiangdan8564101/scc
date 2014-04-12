//
//  MapConfig.h
//  sc
//
//  Created by fox on 13-2-11.
//
//

#import "GameConfig.h"
#import "CreatureConfig.h"




@interface SubSceneMap : NSObject
{
}
@property ( nonatomic , assign ) NSMutableString* Name;
@property ( nonatomic ) int ID , LV;

@property ( nonatomic , assign ) NSMutableArray* Collect;
@property ( nonatomic , assign ) NSMutableArray* Dig;
@property ( nonatomic , assign ) NSMutableArray* Enemy;
@property ( nonatomic , assign ) NSMutableArray* SPEnemy;
@property ( nonatomic , assign ) NSMutableArray* Treasure;
@property ( nonatomic ) int BossID , BossNum;
@end


@interface SceneMap : NSObject
{
}

@property ( nonatomic , assign ) NSMutableString* Name;
@property ( nonatomic , assign ) NSMutableArray* SubScenes;
@property ( nonatomic ) int ID , Day , Story , WorkRank;

@end


@interface MapConfig : GameConfig
{
    NSMutableDictionary* subScenes;
}

@property( nonatomic , assign ) NSMutableDictionary* Scenes;
@property( nonatomic , assign ) SubSceneMap* SPSubSceneMap;

- ( SubSceneMap* ) getSubSceneMap:( int )i;
- ( SceneMap* ) getSceneMap: ( int )i;

+ ( MapConfig* ) instance;

@end
