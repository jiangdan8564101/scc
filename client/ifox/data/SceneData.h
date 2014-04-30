//
//  SceneData.h
//  sc
//
//  Created by fox on 13-12-8.
//
//

#import "GameData.h"

@interface SceneDataItem : NSObject

@property ( nonatomic ) int Complete;
@property ( nonatomic ) float Per , HidePer;
@property ( nonatomic , assign ) NSMutableArray* CollectArray;
@property ( nonatomic , assign ) NSMutableArray* DigArray;
@property ( nonatomic , assign ) NSMutableArray* EnemyArray;
@property ( nonatomic , assign ) NSMutableDictionary* DataDic;
@property ( nonatomic , assign ) NSMutableDictionary* DoorDic;
@property ( nonatomic , assign ) NSMutableDictionary* TreasureDic;
@property ( nonatomic ) BOOL SPEnemy;

- ( BOOL ) getCollect:( int )c;
- ( BOOL ) getDig:( int )d;
- ( BOOL ) getEnemy:( int )e;

- ( void ) setCollect:( int )c;
- ( void ) setDig:( int )d;
- ( void ) setEnemy:( int )e;

- ( void ) setData:( int )index;
- ( BOOL ) getData:( int )index;

- ( void ) setTreasure:( int )index;
- ( BOOL ) getTreasure:( int )index;

- ( void ) setDoor:( int )index;
- ( BOOL ) getDoor:( int )index;


@end


@interface SceneData : GameData
{
    int completeCount;
}

@property( nonatomic , assign ) NSMutableDictionary* Data;
@property( nonatomic , assign ) SceneDataItem* SPSceneDataItem;
- ( BOOL ) getEnemy:( int )e;

- ( void ) activeSceneData:( int )i;
- ( SceneDataItem* ) getSceneData:( int )i;

+ ( SceneData* ) instance;

- ( void ) checkComplete;
- ( void ) randomSPEnemy;


@end

