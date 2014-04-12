//
//  BattleMapScene.h
//  sc
//
//  Created by fox on 13-1-19.
//
//

#import "GameScene.h"
#import "BattleMapRegion.h"
#import "BattleStage.h"
#import "MapConfig.h"
#import "SceneData.h"
#import "BattleMapLayer.h"

@class BattleCreature;

@interface BattleMapScene : GameScene
{
    BattleMapLayer* mapLayer[ MAX_BATTLE_LAYER ];
    
    int layerCount;
}

@property( nonatomic ) BOOL SPMap;

- ( BattleMapLayer* ) getActiveMapLayer;
- ( BattleLogUIHandler* ) getActiveLogUI;

- ( void ) loadSP;
- ( void ) load:( int )i :( int )t;

- ( void ) activeLayer:( int )l;

- ( BOOL ) checkEnd;

+ ( BattleMapScene* )instance;


@end


