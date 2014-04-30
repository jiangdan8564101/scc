//
//  BattleStage.m
//  sc
//
//  Created by fox on 13-4-29.
//
//

#import "BattleStage.h"
#import "PlayerData.h"
#import "BattleNetHandler.h"
#import "GameSceneManager.h"
#import "BattleTopUIHandler.h"
#import "BattleMapScene.h"
#import "BattleEndItemUIHandler.h"
#import "CreatureConfig.h"
#import "BattleLogUIHandler.h"
#import "GameManager.h"
#import "LevelUpConfig.h"
#import "ItemConfig.h"
#import "ItemData.h"
#import "HitConfig.h"
#import "ProfessionConfig.h"
#import "GameAudioManager.h"
#import "SkillConfig.h"

@implementation BattleStage
@synthesize StartFight , LogUI;


- ( void ) initBattleStage:( BattleMapLayer* )layer
{
    mapLayer = layer;
    
    selfCreatures = [ [ NSMutableArray alloc ] init ];
    enemyCreatures = [ [ NSMutableArray alloc ] init ];
    creatures = [ [ NSMutableArray alloc ] init ];
    targets = [ [ NSMutableArray alloc ] init ];
    targetsSelf = [ [ NSMutableArray alloc ] init ];
    
    buffArray = [ [ NSMutableArray alloc ] init ];
    
    bossEnemy = INVALID_ID;
}


- ( void ) clearBattleStage
{
    bossEnemy = INVALID_ID;
    StartFight = NO;
    turn = 0;
    
    spEnemy = NO;
    end = NO;
    
    [ selfCreatures removeAllObjects ];
    [ enemyCreatures removeAllObjects ];
    [ creatures removeAllObjects ];
    
    [ targets removeAllObjects ];
    [ targetsSelf removeAllObjects ];
    
    [ LogUI clearMsg ];
    
    [ playingMusic release ];
    playingMusic = NULL;
    
    atkArray = NULL;
    defArray = NULL;
    
    
    [ buffArray removeAllObjects ];
}

- ( BOOL ) canMoveCreature
{
    for ( int i = 0 ; i < selfCreatures.count ; ++i )
    {
        CreatureCommonData* comm = [ selfCreatures objectAtIndex:i ];
        
        if ( comm.RealBaseData.FS == 0 )
        {
            return NO;
        }
    }
    
    return YES;
}
- ( void ) moveCreature
{
    for ( int i = 0 ; i < selfCreatures.count ; ++i )
    {
        CreatureCommonData* comm = [ selfCreatures objectAtIndex:i ];
        
        comm.RealBaseData.FS--;
        
        if ( comm.RealBaseData.FS < 1 )
        {
            comm.RealBaseData.FS = 0;
            
            [ LogUI updateSelf:selfCreatures ];
            return;
        }
    }
    
    [ LogUI updateSelf:selfCreatures ];
}


- ( void ) addSelfCreature:( CreatureCommonData* )c
{
    [ selfCreatures addObject:c ];
}


- ( void ) getCreatures
{
    [ creatures removeAllObjects ];
    
    for ( int i = 0 ; i < enemyCreatures.count ; i++ )
    {
        CreatureCommonData* comm = [ enemyCreatures objectAtIndex:i ];
        
        if ( !comm.Dead )
        {
            [ creatures addObject:[ enemyCreatures objectAtIndex:i ] ];
            comm.Group = GROUP_ENEMY;
            comm.Index = i;
        }
    }
    
    for ( int i = 0 ; i < selfCreatures.count ; i++ )
    {
        CreatureCommonData* comm = [ selfCreatures objectAtIndex:i ];
        
        if ( !comm.Dead )
        {
            [ creatures addObject:[ selfCreatures objectAtIndex:i ] ];
            comm.Group = GROUP_PLAYER;
            comm.Index = i;
        }
    }
    
    [ creatures sortUsingComparator:^NSComparisonResult( CreatureCommonData* obj1, CreatureCommonData* obj2) {
        int i = obj1.RealBaseData.Agile;
        int j = obj2.RealBaseData.Agile;
        if ( [ obj1 isEquipSkillTriggerEffectB:STGE_FASTATTACK ] )
        {
            i = MAX_HP;
        }
        if ( [ obj2 isEquipSkillTriggerEffectB:STGE_FASTATTACK ] )
        {
            j = MAX_HP;
        }
        
        if (i < j) {
            return NSOrderedDescending;
        }
        if (i > j) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    } ];
}

- ( void ) onEndFight
{
    while ( buffArray.count )
    {
        [ self updateBuffTurnEnd ];
    }
    
    StartFight = NO;
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightEnd" , nil ) ];
    [ mapLayer battleLog:str ];
    
    NSArray* array = [ [ ItemData instance ] useHPItem:selfCreatures ];
    for ( int i = 0 ; i < array.count ; ++i )
    {
        CreatureCommonData* comm = [ selfCreatures objectAtIndex:[ [ array objectAtIndex:i ] intValue ] ];
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHealthHPItem" , nil ) , comm.Name ];
        [ mapLayer battleLog:str ];
    }
    
    array = [ [ ItemData instance ] useSPItem:selfCreatures ];
    for ( int i = 0 ; i < array.count ; ++i )
    {
        CreatureCommonData* comm = [ selfCreatures objectAtIndex:[ [ array objectAtIndex:i ] intValue ] ];
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHealthSPItem" , nil ) , comm.Name ];
        [ mapLayer battleLog:str ];
    }
    
    
    [ LogUI endFight ];
    
    bossEnemy = INVALID_ID;
    
    turn = 0;
    time = 0.0f;
    timeStep = 0;
    
    spEnemy = NO;
    
    [ enemyCreatures removeAllObjects ];
    [ creatures removeAllObjects ];
    [ targets removeAllObjects ];
    [ targetsSelf removeAllObjects ];
    
    [ buffArray removeAllObjects ];
    
    atkArray = NULL;
    defArray = NULL;
    
    hpArrayAtk = NULL;
    hpArrayDef = NULL;
    
    if ( mapLayer.LayerIndex == 0 )
    {
        [ [ GameAudioManager instance ] playMusic:playingMusic :musicTime ];
        [ playingMusic release ];
        playingMusic = NULL;
    }
}

- ( void ) endFight
{
    time = -MAX_HP;
    timeStep = 0;
    end = YES;
    
    [ self performSelector:@selector(onEndFight) withObject:NULL afterDelay:2.0f ];
}


- ( void ) addExpDrop
{
    for ( int i = 0 ; i < selfCreatures.count ; i++ )
    {
        CreatureCommonData* comm = [ selfCreatures objectAtIndex:i ];
        
        [ comm addProfessionTime ];
        [ comm addProfessionSkillAP:enemyCreatures.count ];
        
        float exp = 0.3f;
        
        for ( int j = 0 ; j < enemyCreatures.count ; j++ )
        {
            CreatureCommonData* comm1 = [ enemyCreatures objectAtIndex:j ];
            
            if ( comm.Level < comm1.Level + 3 )
            {
                exp = ( 1 - ( comm.Level - comm1.Level ) * 0.2f ) * comm1.EXP;

                if ( exp > 100 )
                {
                    exp = 100;
                }
            }
        }
        
        if ( !comm.Dead )
        {
            comm.EXP += exp;
        }
        
        
//        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightEXP" , nil ) , comm.Name , (int)exp ];
//        [ mapLayer battleLog:str ];
        
        if ( comm.EXP > 100 )
        {
            comm.Level += 1;
            comm.EXP -= 100;
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightLevelUp" , nil ) , comm.Name ];
            [ mapLayer battleLog:str ];
            
            CreatureBaseData* ba = [ [ LevelUpConfig instance ] getBaseData:comm.LevelUpType ];
            
            [ comm.BaseData addRandomData:ba ];
            [ comm updateProfessionSkillAndEquip ];
            
            if ( comm.EXP > 100 )
            {
                comm.EXP = 0;
                [ [ GameManager instance ] getError ];
                return;
            }
        }
    }
    
    
    for ( int j = 0 ; j < enemyCreatures.count ; j++ )
    {
        CreatureCommonData* comm1 = [ enemyCreatures objectAtIndex:j ];
        
        if ( ![ mapLayer getEnemy:comm1.ID ] && comm1.FirstDrop )
        {
            ItemConfigData* data = [ [ ItemConfig instance ] getData:comm1.FirstDrop ];
            
            [ [ ItemData instance ] addItem:comm1.FirstDrop :comm1.FirstDropNum ];
            [ mapLayer addItem:comm1.FirstDrop :comm1.FirstDropNum ];
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDrop" , nil ) ];
            [ mapLayer battleLog:str ];
            
            NSString* str1 = [ NSString stringWithFormat:@"FightColor%d" , data.Color ];
            str = [ NSString localizedStringWithFormat:NSLocalizedString( str1 , nil ) , data.Name , comm1.FirstDropNum ];
            [ mapLayer battleLog:str ];
            
            [ mapLayer setEnemy:comm1.ID ];
            continue;
        }
        
        [ mapLayer setEnemy:comm1.ID ];
        
        int allCount = 0;
        
        for ( int i = 0 ; i < comm1.Drop.count ; ++i )
        {
            CreatureBaseIDPerNum* drop = [ comm1.Drop objectAtIndex:i ];

            allCount += drop.Per;
        }
        
        if ( !allCount )
        {
            continue;
        }
        
        int r = rand() % allCount;

        allCount = 0;
        
        for ( int i = 0 ; i < comm1.Drop.count ; ++i )
        {
            CreatureBaseIDPerNum* drop = [ comm1.Drop objectAtIndex:i ];
            allCount += drop.Per;
            
            if ( r < allCount )
            {
                int item = drop.ID;
                
                ItemConfigData* data = [ [ ItemConfig instance ] getData:item ];
                
                if ( data.AutoSell )
                {
//                    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDropGold" , nil ) , data.Sell ];
//                    [ mapLayer battleLog:str ];
//                    
                    mapLayer.DropGold += data.Sell;
                    [ [ PlayerData instance ] addGold:data.Sell ];
                }
                else
                {
                    int c = rand() % drop.Num + 1;
                    
                    if ( data.Type2 )
                    {
                        c += [ PlayerData instance ].WorkItemEffect[ data.Type2 + ICDET_DROP1 - 1 ];
                    }
                    
                    [ [ ItemData instance ] addItem:item :c ];
                    [ mapLayer addItem:item :c ];
                    
                    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDrop" , nil ) ];
                    [ mapLayer battleLog:str ];
                    
                    NSString* str1 = [ NSString stringWithFormat:@"FightColor%d" , data.Color ];
                    str = [ NSString localizedStringWithFormat:NSLocalizedString( str1 , nil ) , data.Name , c ];
                    [ mapLayer battleLog:str ];
                }
                
                break;
            }
        }
        
        
    }
}

- ( void ) checkEnd
{
    int count = 0;
    for ( int i = 0 ; i < selfCreatures.count ; i++ )
    {
        CreatureCommonData* comm = [ selfCreatures objectAtIndex:i ];
        
        if ( comm.Dead )
        {
            count++;
        }
        else
        {
            break;
        }
    }
    
    if ( count == selfCreatures.count )
    {
        [ self endFight ];
        [ mapLayer showWin:NO ];
        
        if ( bossEnemy != INVALID_ID )
        {
            [ mapLayer killByOther:bossEnemy ];
            bossEnemy = INVALID_ID;
        }
        
        return;
    }
    
    
    count = 0;
    for ( int i = 0 ; i < enemyCreatures.count ; i++ )
    {
        CreatureCommonData* comm = [ enemyCreatures objectAtIndex:i ];
        
        if ( comm.Dead )
        {
            count++;
            
            [ [ PlayerData instance ] setMonsterData:comm.ID ];
        }
        else
        {
            break;
        }
    }
    
    
    if ( count == enemyCreatures.count )
    {
        if ( bossEnemy != INVALID_ID )
        {
            [ mapLayer killOther:bossEnemy ];
            bossEnemy = INVALID_ID;
        }
        
        [ self addExpDrop ];
        [ self endFight ];
        
        return;
    }
}

- ( void ) updateTargets
{
    [ targetsSelf removeAllObjects ];
    [ targets removeAllObjects ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        CreatureCommonData* comm = [ atkArray objectAtIndex:i ];
        
        if ( !comm.Dead )
        {
            [ targetsSelf addObject:[ NSNumber numberWithInt:i ] ];
        }
    }
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        CreatureCommonData* comm = [ defArray objectAtIndex:i ];
        
        if ( !comm.Dead )
        {
            [ targets addObject:[ NSNumber numberWithInt:i ] ];
        }
    }
}

- ( int ) getSelfTarget:( NSArray* )arr :( CreatureCommonData* )comm
{
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        if ( [ arr objectAtIndex:i ] == comm )
        {
            return i;
        }
    }
    
    return INVALID_ID;
}


- ( int ) getOneTarget:( NSArray* )arr :(NSArray*)def
{
    for ( int i = 0 ; i < def.count ; ++i )
    {
        CreatureCommonData* comm = [ def objectAtIndex:i ];
        
        if ( [ self hasBuffWithEffect:comm :STGE_HATRED ] && !comm.Dead )
        {
            return i;
        }
    }
    
    int rand1[ 5 ] = { 50 , 20 , 15 , 10 , 5 };
    int count = 0;
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        count += rand1[ i ];
    }
    
    int r = rand() % count;
    
    int c = 0;
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        c += rand1[ i ];
        
        if ( c > r )
        {
            return [ [ arr objectAtIndex:i ] intValue ];
        }
    }
    
    return [ [ arr objectAtIndex:0 ] intValue ];
}


- ( int ) getMinHPTarget:( NSArray* )arr
{
    int min = MAX_HP;
    int index = 0;
    
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        CreatureCommonData* comm = [ arr objectAtIndex:i ];
        
        if ( !comm.Dead )
        {
            if ( min > (int)comm.RealBaseData.HP )
            {
                min = (int)comm.RealBaseData.HP;
                index = i;
            }
        }
    }
    
    return index;
}

- ( int ) getDeadTarget:( NSArray* )arr
{
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        CreatureCommonData* comm = [ arr objectAtIndex:i ];
        
        if ( comm.Dead )
        {
            return i;
        }
    }
    
    return INVALID_ID;
}



- ( int ) pHit:( CreatureCommonData* )com1 :( CreatureCommonData* )com2
{
    float hit = com1.RealBaseData.Hit;
    float miss = com2.RealBaseData.Miss;
    
    int v = ( hit - miss ) * 100.0f;
    
    if ( v < 0 )
    {
        v = 1;
    }
    
    int r = rand() % 100;
    
    if ( r > v )
    {
        return BHS_MISS;
    }
    
    int c = com1.RealBaseData.Critical;
    if ( c == 0 )
    {
        c = 1;
    }
    r = rand() % 100;
    
    if ( r > c )
    {
        return BHS_HIT;
    }
    
    return BHS_CRITICAL;
}


- ( HitConfigData* ) pHitRandom:( CreatureCommonData* )com1 :( CreatureCommonData* )com2
{
    int r = rand() % 100;
    
    int proLevel = [ com1 getProfessionLevel ];
    
    
    HitConfigData** hits = [ [ HitConfig instance ] getHit:proLevel ];
    
    int c = 0;
    for ( int i = BRHS_HIT1 ; i < BRHS_HIT5 ; ++i )
    {
        c += hits[ i - 1 ].Per;
        
        if ( r < c )
        {
            return hits[ i - 1 ];
        }
    }
    
    return hits[ BRHS_HIT5 - 1 ];
}


- ( int ) pAttack:( CreatureCommonData* )com1 :( CreatureCommonData* )com2
{
    float at = com1.RealBaseData.PAtk * 0.5f;
    float df = com2.RealBaseData.PDef * 0.25f;
    
    float baseDamage = at - df;
    
    if ( baseDamage <= 0 )
    {
        baseDamage = 1.0f;
    }
    
    float per1 = 1.0f;
    
    if ( com2.Type < GCT_HUMAN )
    {
        per1 = 1.0f + com1.RealMonsterDamage[ com2.Type ];
    }
    
    float ad = com2.RealAttrDefence[ com1.MainAttrType ];
    float per2 = ( 1.0f + com1.MainAttr ) * ( 1.0f - ad );
    
    float finalDamage = baseDamage * per1 * per2;
    
    return finalDamage;
}

- ( int ) mAttack:( CreatureCommonData* )com1 :( CreatureCommonData* )com2 :( int )attr :( float* )monster
{
    float at = com1.RealBaseData.MAtk * 0.5f;
    float df = com2.RealBaseData.MDef * 0.25f;
    
    float baseDamage = at - df;
    
    if ( baseDamage <= 0 )
    {
        baseDamage = 1.0f;
    }
    
    float per1 = 1.0f;
    
    if ( com2.Type < GCT_HUMAN )
    {
        per1 = 1.0f + com1.RealMonsterDamage[ com2.Type ];
    }
    
    float ad = com2.RealAttrDefence[ attr ];
    float per2 = ( 1.0f + com1.MainAttr ) * ( 1.0f - ad );
    
    float mt = monster[ com2.Type ];
    
    if ( !mt )
    {
        mt = 1.0f;
    }
    
    float finalDamage = baseDamage * per1 * per2 * 1.0f;
    
    return finalDamage;
}


- ( void ) physicalAttack:( CreatureCommonData* )atk
{
    int targetOne = [ self getOneTarget:targets :defArray ];

    CreatureCommonData* def = [ defArray objectAtIndex:targetOne ];
    
    int hitType = [ self pHit:atk :def ];
    int hp = [ self pAttack:atk :def ];
    HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
    
    if ( hp <= 0 )
    {
        hp = 1;
    }
    
    //hitType = BHS_MISS;
    
    switch ( hitType )
    {
        case BHS_MISS:
        {
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit" , nil ) ];
            
            [ mapLayer battleLog:str ];
            
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightMiss" , nil ) , def.Name ];
            
            [ mapLayer battleLog:str ];
            
            hp = FIGHT_MISS;
        }
            break;
        case BHS_HIT:
        {
            hp *= hitRandom.Value;
            def.RealBaseData.HP -= hp;
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit" , nil ) ];
            [ mapLayer battleLog:str ];
            
            NSString* str2 = [ NSString stringWithFormat:@"FightHit%d" , hitRandom.ID ];
            str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) ];
            [ mapLayer battleLog:str ];
            
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
            
            str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , hitRandom.ID ];
            str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
            [ mapLayer battleLog:str ];
        }
            break;
        case BHS_CRITICAL:
        {
            def.RealBaseData.HP -= hp * 2.0f;
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightCritical" , nil ) ];
            [ mapLayer battleLog:str ];
            
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
            
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamageHP5" , nil ) , hp ];
            [ mapLayer battleLog:str ];
            
            [ LogUI fightEffectCritical ];
            
            hitRandom.ID = BRHS_HIT5;
        }
            break;
    }

    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne == i )
        {
            [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
        }
    }
    
    
    ProfessionConfigData* pro = [ [ ProfessionConfig instance ] getProfessionConfig:atk.ProfessionID ];
        
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightSelf:hpArrayDef :pro.Effect :hitRandom.ID ];
            //[ LogUI fightEnemy:hpArrayAtk :NULL ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightEnemy:hpArrayDef :pro.Effect :hitRandom.ID ];
            //[ LogUI fightSelf:hpArrayAtk :NULL ];
            break;
        default:
            break;
    }
    
}

- ( BOOL ) AIRunFightReady:( CreatureCommonData* )atk
{
    SkillConfigData* skillGiddiness = [ self hasBuffWithEffect:atk :STGE_GIDDINESS ];
    if ( skillGiddiness )
    {
        [ creatures removeObject:atk ];
        
        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightBuff2" , nil ) , atk.Name , skillGiddiness.Des3 ];
        [ mapLayer battleLog:str ];
        //STGE_DEATH2
        return NO;
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightAttack" , nil ) , atk.Name ];
    [ mapLayer battleLog:str ];
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            defArray = selfCreatures;
            atkArray = enemyCreatures;
            
            // 播放起手动作，
            [ LogUI startEnemyFight:atk.Index ];
            break;
        case GROUP_PLAYER:
            atkArray = selfCreatures;
            defArray = enemyCreatures;
            
            // 播放起手动作，
            [ LogUI startSelfFight:atk.Index ];
            break;
        default:
            break;
    }
    
    return YES;
}


- ( void ) AIRunFight:( CreatureCommonData* )atk
{
    [ creatures removeObject:atk ];
    
    // 刷新攻击对象
    [ self updateTargets ];
    
    
    hpArrayAtk = [ [ NSMutableArray alloc ] init ];
    hpArrayDef = [ [ NSMutableArray alloc ] init ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        [ hpArrayAtk addObject:[ NSNumber numberWithInt:0 ] ];
    }
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        [ hpArrayDef addObject:[ NSNumber numberWithInt:0 ] ];
    }
    
    // 行动时即死，，
    SkillConfigData* skillDeath2 = [ self hasBuffWithEffect:atk :STGE_DEATH2 ];
    if ( skillDeath2 )
    {
        BOOL b = [ self useSkillDeath2Buff:atk :skillDeath2.SkillID ];
        
        if ( b )
        {
            [ hpArrayAtk release ];
            [ hpArrayDef release ];
            
            [ self checkDead ];
            [ self checkEnd ];
            
            return;
        }
    }
    
    
    int skillID = [ self canUseSkill:atk :STG_INITIATIVE ];
    if ( skillID > 0 )
    {
        // 使用主动技能
        BOOL b = [ self useSkill:atk :skillID ];
        
        if ( !b )
        {
            // 使用失败
            [ self physicalAttack:atk ];
        }
    }
    else
    {
        int skillID = [ self canUseSkill:atk :STG_ATTCK ];
        
        if ( skillID > 0 )
        {
            // 普通攻击技能
            BOOL b = [ self physicalAttackSkill:atk :skillID ];
            
            if ( !b )
            {
                // 使用失败
                [ self physicalAttack:atk ];
            }
        }
        else
        {
            // 普通物理攻击
            [ self physicalAttack:atk ];
        }
    }
    
    [ hpArrayAtk release ];
    [ hpArrayDef release ];
    
    [ self checkDead ];
    [ self checkEnd ];
}


- ( void ) checkDead
{
    atkArray = selfCreatures;
    defArray = enemyCreatures;
    
    // 扣血是否死亡处理，
    NSMutableArray* deadArraySelf = [ [ NSMutableArray alloc ] init ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        CreatureCommonData* atk1 = [ atkArray objectAtIndex:i ];
        
        if ( atk1.RealBaseData.HP > atk1.RealBaseData.MaxHP )
        {
            atk1.RealBaseData.HP = atk1.RealBaseData.MaxHP;
        }
        if ( atk1.RealBaseData.SP > atk1.RealBaseData.MaxSP )
        {
            atk1.RealBaseData.SP = atk1.RealBaseData.MaxSP;
        }
        if ( atk1.RealBaseData.SP < 0 )
        {
            atk1.RealBaseData.SP = 0;
        }
        if ( atk1.RealBaseData.HP < 1.0f )
        {
            atk1.RealBaseData.HP = 0.0f;
        }
        
        if ( !atk1.Dead && atk1.RealBaseData.HP < 1.0f )
        {
            int skillID = [ self canUseSkill:atk1 :STG_DEAD ];
            
            if ( skillID > 0 )
            {
                // 使用死亡触发技能
                [ self useSkill:atk1 :skillID ];
            }
        }
        
        if ( !atk1.Dead && atk1.RealBaseData.HP < 1.0f )
        {
            atk1.RealBaseData.HP = 0;
            atk1.Dead = YES;
            
            [ creatures removeObject:atk1 ];
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDead" , nil ) , atk1.Name ];
            [ mapLayer battleLog:str ];
            
            [ deadArraySelf addObject:[ NSNumber numberWithBool:YES ] ];
        }
        else
        {
            [ deadArraySelf addObject:[ NSNumber numberWithBool:NO ] ];
        }
    }
    
    NSMutableArray* deadArrayDef = [ [ NSMutableArray alloc ] init ];
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        CreatureCommonData* def1 = [ defArray objectAtIndex:i ];
        
        if ( def1.RealBaseData.HP > def1.RealBaseData.MaxHP )
        {
            def1.RealBaseData.HP = def1.RealBaseData.MaxHP;
        }
        if ( def1.RealBaseData.SP > def1.RealBaseData.MaxSP )
        {
            def1.RealBaseData.SP = def1.RealBaseData.MaxSP;
        }
        if ( def1.RealBaseData.SP < 0 )
        {
            def1.RealBaseData.SP = 0;
        }
        if ( def1.RealBaseData.HP < 1.0f )
        {
            def1.RealBaseData.HP = 0.0f;
        }
        
        if ( !def1.Dead && def1.RealBaseData.HP < 1.0f )
        {
            int skillID = [ self canUseSkill:def1 :STG_DEAD ];
            
            if ( skillID > 0 )
            {
                // 使用死亡触发技能
                [ self useSkill:def1 :skillID ];
            }
        }
        
        if ( !def1.Dead && def1.RealBaseData.HP < 1.0f )
        {
            def1.RealBaseData.HP = 0;
            def1.Dead = YES;
            
            [ creatures removeObject:def1 ];
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDead" , nil ) , def1.Name ];
            [ mapLayer battleLog:str ];
            
            [ deadArrayDef addObject:[ NSNumber numberWithBool:YES ] ];
        }
        else
        {
            [ deadArrayDef addObject:[ NSNumber numberWithBool:NO ] ];
        }
    }
    
    [ LogUI deadSelf:deadArraySelf ];
    [ LogUI dead:deadArrayDef ];
    
    [ deadArraySelf release ];
    [ deadArrayDef release ];
    
    [ LogUI updateSelf:selfCreatures ];
}


- ( void ) AIRun:( float )d
{
    time += d * GAME_SPEED;
    
    if ( timeStep == 0 && time > 1.0f )
    {
        timeStep = 1;
        
        BOOL bb = NO;
        
        if ( !creatures.count )
        {
            bb = [ self updateBuffTurnEnd ];
            [ self checkEnd ];
            
            if ( end )
            {
                return;
            }
            
            [ self getCreatures ];
            turn++;
            
            if ( !creatures.count )
            {
                [ self endFight ];
                return;
            }
        }
        
        CreatureCommonData* common = [ creatures objectAtIndex:0 ];
        
        [ self updateBuffTurnStart ];
        
        BOOL b = [ self AIRunFightReady:common ];
        
        if ( !b )
        {
            timeStep = 0;
            time = 0.0f;
            [ self checkEnd ];
        }
        
        nextTime = 1.0f + ( bb ? 1.0f : 0.01f );
    }
    else if( timeStep == 1 && time > nextTime )
    {
        timeStep = 2;
        
        CreatureCommonData* common = [ creatures objectAtIndex:0 ];
        
        [ self AIRunFight:common ];
        
        nextTime += 0.2f;
    }
    else if( timeStep == 2 && time > nextTime )
    {
        timeStep = 0;
        time = 0.0f;
    }
    
}

- ( void ) onStartBoss
{
    for ( int i = 0 ; i < bossNum ; i++ )
    {
        CreatureCommonData* c = [ [ CreatureConfig instance ] getCommonData:bossCID ].copy;
        [ enemyCreatures addObject:c ];
        
        //[ mapLayer setEnemy:c.ID ];
        
        [ c release ];
    }
    
    time = 0.0f;
    timeStep = 0;
    end = NO;
    
    [ LogUI startFight:enemyCreatures :YES :NO ];
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightBoss" , nil ) ];
    [ mapLayer battleLog:str ];
}

- ( void ) startBoss:(int)cid :(int)num :(int)e
{
    bossEnemy = e;
    bossCID = cid;
    bossNum = num;
    
    time = -MAX_HP;
    timeStep = 0;
    
    StartFight = YES;
    end = NO;
    
    [ LogUI startFightMovie:self :@selector(onStartBoss) ];
    
    if ( [ mapLayer LayerIndex ] == 0 )
    {
        [ playingMusic release ];
        playingMusic = [ GameAudioManager instance ].Playing.retain;
        
        int r = rand() % 3;
        
        musicTime = [ [ GameAudioManager instance ] getCurrectTime ];
        [ [ GameAudioManager instance ] playMusic:[ NSString stringWithFormat:@"BGM03%d" , 3 + r ] :0 ];
    }
    
}


- ( void ) startLog
{
    [ LogUI start:selfCreatures ];
}


- ( void ) onStart
{
    bossEnemy = INVALID_ID;
    
    
    //    int randE = rand() % enemyCreaturesSet.count;
    //
    //    CreatureBaseIDPerNum* n = [ enemyCreaturesSet objectAtIndex:randE ];
    //
    //    int randC = rand() % n.Num + 1;
    //
    //    for ( int i = 0 ; i < randC ; ++i )
    //    {
    //        CreatureCommonData* c = [ [ CreatureConfig instance ] getCommonData:n.ID ].copy;
    //        [ enemyCreatures addObject:c ];
    //
    //        [ mapLayer setEnemy:c.ID ];
    //        [ c release ];
    //    }
    
    if ( spEnemy )
    {
        NSMutableArray* enemyCreaturesSet = mapLayer.SPEnemyCreatures;
        
        CreatureBaseIDPerNum* n = [ enemyCreaturesSet objectAtIndex:0 ];
        
        for ( int i = 0 ; i < n.Num ; i++ )
        {
            CreatureCommonData* c = [ [ CreatureConfig instance ] getCommonData:n.ID ].copy;
            [ enemyCreatures addObject:c ];
            
            //[ mapLayer setEnemy:c.ID ];
            [ c release ];
        }
    }
    else
    {
        NSMutableArray* enemyCreaturesSet = mapLayer.EnemyCreatures;
        
        CreatureBaseIDPerNum* n = [ enemyCreaturesSet objectAtIndex:0 ];
        
        for ( int i = 0 ; i < n.Num ; i++ )
        {
            int countR = rand() % enemyCreaturesSet.count;
            n = [ enemyCreaturesSet objectAtIndex:countR ];
            
            CreatureCommonData* c = [ [ CreatureConfig instance ] getCommonData:n.ID ].copy;
            [ enemyCreatures addObject:c ];
            
            //[ mapLayer setEnemy:c.ID ];
            [ c release ];
        }
        

    }
    
    
    time = 0.0f;
    timeStep = 0;
    
    [ LogUI startFight:enemyCreatures :NO :spEnemy ];
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightStart" , nil ) ];
    [ mapLayer battleLog:str ];
}


- ( void ) start :( BOOL )sp
{
    spEnemy = sp;
    
    time = -MAX_HP;
    
    StartFight = YES;
    end = NO;
    
    [ LogUI startFightMovie:self :@selector(onStart) ];
    
    if ( [ mapLayer LayerIndex ] == 0 )
    {
        [ playingMusic release ];
        playingMusic = [ GameAudioManager instance ].Playing.retain;
        
        if ( sp )
        {
            musicTime = [ [ GameAudioManager instance ] getCurrectTime ];
            [ [ GameAudioManager instance ] playMusic:@"BGM031" :0 ];
        }
        else
        {
            musicTime = [ [ GameAudioManager instance ] getCurrectTime ];
            [ [ GameAudioManager instance ] playMusic:@"BGM032" :0 ];
        }
    }
}

- ( void ) update:( freal32 )d
{
    if ( !StartFight )
    {
        return;
    }
    
    [ self AIRun:d ];
}

//////////////////////////////////////////////////////////
// skill



- ( BOOL ) skillHit:( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    return ( rand() % 100 ) < skill.Hit * 100.0f;
}


- ( int ) canUseSkill:( CreatureCommonData* )atk :( int )type
{
    NSMutableArray* array = [ NSMutableArray array ];

    if ( atk.Group == GROUP_ENEMY )
    {
        if ( atk.Skill.count )
        {
            int r = rand() % ( atk.Skill.count );
            
            if ( r >= atk.Skill.count )
            {
                return INVALID_ID;
            }
            
            int skillID = [ [ atk.Skill.allKeys objectAtIndex:r ] intValue ];
            
            SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
            
            BOOL have = NO;
            
            if ( ( skill.Target == STT_HEALTH || skill.Target == STT_HEALTHALL ||
                  skill.Target == STT_SELF )
                && skill.Turn )
            {
                for ( int i = 0 ; i < defArray.count ; ++i )
                {
                    if ( [ self hasBuffWithEffect:[ defArray objectAtIndex:i ] :skill.TriggerEffect ] )
                    {
                        have = YES;
                        break;
                    }
                }
            }
            else if ( ( skill.Target == STT_TARGET || skill.Target == STT_TARGETALL )
                     && skill.Turn )
            {
                for ( int i = 0 ; i < atkArray.count ; ++i )
                {
                    if ( [ self hasBuffWithEffect:[ atkArray objectAtIndex:i ] :skill.TriggerEffect ] )
                    {
                        have = YES;
                        break;
                    }
                }
            }
            
            if ( !have && atk.RealBaseData.SP >= skill.SP &&
                skill.Trigger == type )
            {
                return skillID;
            }
            
        }
    }
    
    for( int i = 0 ; i < MAX_SKILL ; i++ )
    {
        int skillID = atk.EquipSkill[ i ];
        if ( skillID > 0 )
        {
            SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
            
            BOOL have = NO;
            
            if ( ( skill.Target == STT_HEALTH || skill.Target == STT_HEALTHALL ||
                  skill.Target == STT_SELF )
                && skill.Turn )
            {
                for ( int i = 0 ; i < atkArray.count ; ++i )
                {
                    if ( [ self hasBuffWithEffect:[ atkArray objectAtIndex:i ] :skill.TriggerEffect ] )
                    {
                        have = YES;
                        break;
                    }
                }
            }
            else if ( ( skill.Target == STT_TARGET || skill.Target == STT_TARGETALL )
                     && skill.Turn )
            {
                for ( int i = 0 ; i < defArray.count ; ++i )
                {
                    if ( [ self hasBuffWithEffect:[ defArray objectAtIndex:i ] :skill.TriggerEffect ] )
                    {
                        have = YES;
                        break;
                    }
                }
            }
            
            if ( !have && atk.RealBaseData.SP >= skill.SP &&
                skill.Trigger == type )
            {
                [ array addObject:[ NSNumber numberWithInt:skillID ] ];
            }
            
        }
    }
    
    if ( !array.count )
    {
        return INVALID_ID;
    }
    
    int r = rand() % ( array.count );
    
    if ( r >= array.count )
    {
        return INVALID_ID;
    }
    
    return [ [ array objectAtIndex:r ] intValue ];
}


- ( BOOL ) physicalAttackSkill:( CreatureCommonData* )atk :( int )skillID
{
    BOOL b = [ self useSkill:atk :skillID ];
    
    return b;
}

- ( BOOL ) useSkill:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    switch ( skill.TriggerEffect )
    {
        case STGE_HP:
        {
            BOOL b = [ self useSkillHP:atk :skillID ];
            
            if ( b )
            {
                [ LogUI fightEffectCritical ];
            }
            return b;
        }
            break;
        case STGE_HP1:
        {
            if ( atk.BaseData.HP < 2 )
            {
                return NO;
            }
            
            int hp = 0;
            for ( int i = 0 ; i < hpArrayDef.count ; i++ )
            {
                if ( [ [ hpArrayDef objectAtIndex:i ] intValue ] )
                {
                    hp = [ [ hpArrayDef objectAtIndex:i ] intValue ];
                    break;
                }
            }
            for ( int i = 0 ; i < atkArray.count ; ++i )
            {
                if ( atk == [ atkArray objectAtIndex:i ] )
                {
                    hp *= skill.Power1;
                    atk.RealBaseData.HP -= hp;
                    
                    if ( atk.RealBaseData.HP <= 0 )
                    {
                        atk.RealBaseData.HP = 1;
                    }
                    
                    [ hpArrayAtk replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
                }
            }
            
            [ self useSkillHP:atk :skillID ];
            
            switch ( atk.Group )
            {
                case GROUP_ENEMY:
                    [ LogUI fightEnemy:hpArrayAtk :NULL :BRHS_HIT2 ];
                    break;
                case GROUP_PLAYER:
                    [ LogUI fightSelf:hpArrayAtk :NULL :BRHS_HIT2 ];
                    break;
                default:
                    break;
            }
            
            [ LogUI fightEffectCritical ];
        }
            break;
        case STGE_HP2:
        {
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
            [ mapLayer battleLog:str ];
            
            for ( int i = 0 ; i < skill.Power1 ; i++ )
            {
                [ self useSkillHP2:atk :skillID ];
            }
            
            
            atk.RealBaseData.SP -= skill.SP;
            
            [ LogUI fightEffectCritical ];
            
            switch ( atk.Group )
            {
                case GROUP_ENEMY:
                    [ LogUI fightSelf:hpArrayDef :skill.Effect :BRHS_HIT2 ];
                    break;
                case GROUP_PLAYER:
                    [ LogUI fightEnemy:hpArrayDef :skill.Effect :BRHS_HIT2 ];
                    break;
                default:
                    break;
            }
            
        }
            break;
        case STGE_HP3:
        {
            [ self useSkillHP3:atk :skillID ];
            [ LogUI fightEffectCritical ];
        }
            break;
        case STGE_HP4:
        {
            [ self useSkillHP4:atk :skillID ];
            [ LogUI fightEffectCritical ];
        }
            break;
        case STGE_HP5:
        {
            [ self useSkillHP5:atk :skillID ];
            [ LogUI fightEffectCritical ];
        }
            break;
        case STGE_FASTATTACK2:
        {
            
        }
            break;
        case STGE_GIDDINESS:
        {
            [ self useSkillHP:atk :skillID ];
        }
            break;
        case STGE_CHARGE:
        {
            [ self useSkillCharge:atk :skillID ];
        }
            break;
        case STGE_SP:
        {
            [ self useSkillSP:atk :skillID ];
        }
            break;
        case STGE_GOLD:
        {
            [ self useSkillGold:atk :skillID ];
        }
            break;
        case STGE_HEALTH:
        {
            BOOL b = [ self useSkillHealth:atk :skillID ];
            return b;
        }
            break;
        case STGE_HEALTH1:
        {
            BOOL b = [ self useSkillHealth1:atk :skillID ];
            return b;
        }
            break;
        case STGE_HEALTHSP:
        {
            BOOL b = [ self useSkillHealthSP:atk :skillID ];
            return b;
        }
            break;
        case STGE_HEALTHSP1:
        {
            BOOL b = [ self useSkillHealthSP1:atk :skillID ];
            return b;
        }
            break;
        case STGE_RELIVE:
        {
            BOOL b = [ self useSkillRelive:atk :skillID ];
            return b;
        }
            break;
        case STGE_DEATH:
        {
            BOOL b = [ self useSkillDeath:atk :skillID ];
            if ( b )
            {
                [ LogUI fightEffectCritical ];
            }
            return b;
        }
            break;
        case STGE_DEATH1:
        {
            BOOL b = [ self useSkillDeath1:atk :skillID ];
            if ( b )
            {
                [ LogUI fightEffectCritical ];
            }
            return b;
        }
            break;
        case STGE_DEATH2:
        {
            BOOL b = [ self useSkillDeath2:atk :skillID ];
            return b;
        }
            break;
        case STGE_DEATH3:
        {
            BOOL b = [ self useSkillDeath3:atk :skillID ];
            if ( b )
            {
                [ LogUI fightEffectCritical ];
            }
            return b;
        }
            break;
        case STGE_DEATH4:
        {
            BOOL b = [ self useSkillDeath4:atk :skillID ];
            return b;
        }
            break;
        case STGE_HATRED:
        {
            BOOL b = [ self useSkillHatred:atk :skillID ];
            return b;
        }
            break;
        case STGE_DEATH5:
        {
            int dead = 0;
            for ( int i = 0 ; i < atkArray.count ; ++i )
            {
                CreatureCommonData* comm = [ atkArray objectAtIndex:i ];
                if ( comm.Dead )
                {
                    dead++;
                }
            }
            
            if ( dead && dead == atkArray.count - 1 )
            {
                [ self useSkillDeath5:atk :skillID ];
                [ LogUI fightEffectCritical ];
            }
            else
            {
                return NO;
            }
        }
            break;
        case STGE_MAXHP:
        case STGE_MAXSP:
        case STGE_DEFATTR:
        case STGE_SPEED:
        case STGE_MISS:
        case STGE_HIT:
        case STGE_PATK:
        case STGE_MATK:
        case STGE_PDEF:
        case STGE_MDEF:
        case STGE_CT:
        {
            BOOL b = [ self useSkillDefAttr:atk :skillID :skill.TriggerEffect ];
            return b;
        }
            break;
            
        default:
            break;
    }
    
    
    
    return YES;
}


- ( void ) updateBuffTurnStart
{
//    NSMutableArray* arr = [ [ NSMutableArray alloc ] init ];
//    
//    for ( int i = 0 ; i < buffArray.count ; ++i )
//    {
//        SkillBuff* buff = [ buffArray objectAtIndex:i ];
//        
//        // buff 处理
//        
//    }
}

- ( BOOL ) updateBuffTurnEnd
{
    NSMutableArray* arr = [ [ NSMutableArray alloc ] init ];
    
    hpArrayAtk = [ [ NSMutableArray alloc ] init ];
    hpArrayDef = [ [ NSMutableArray alloc ] init ];
    
    BOOL b = NO;
    
    for ( int i = 0 ; i < buffArray.count ; ++i )
    {
        SkillBuff* buff = [ buffArray objectAtIndex:i ];
        
        buff.Turn--;
        
        // buff 处理
        
        SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:buff.SkillID ];
        
        CreatureCommonData* def = buff.Target;
        
        NSMutableArray* arrayAtk = hpArrayAtk;
        NSMutableArray* arrayDef = hpArrayDef;
        
        [ hpArrayAtk removeAllObjects ];
        [ hpArrayDef removeAllObjects ];
        
        for ( int i = 0 ; i < atkArray.count ; ++i )
        {
            [ hpArrayAtk addObject:[ NSNumber numberWithInt:0 ] ];
        }
        for ( int i = 0 ; i < defArray.count ; ++i )
        {
            [ hpArrayDef addObject:[ NSNumber numberWithInt:0 ] ];
        }
        
        switch ( def.Group )
        {
            case GROUP_ENEMY:
                atkArray = selfCreatures;
                defArray = enemyCreatures;
                break;
            case GROUP_PLAYER:
                arrayAtk = hpArrayDef;
                arrayDef = hpArrayAtk;
                
                atkArray = enemyCreatures;
                defArray = selfCreatures;
                break;
            default:
                break;
        }

        switch ( skill.TriggerEffect )
        {
            case STGE_HP:
            {
                int hp = buff.Power;
                if ( hp <= 0 )
                {
                    hp = 1;
                }
                
                def.RealBaseData.HP -= hp;
                int t = [ self getSelfTarget:defArray :def ];
                [ arrayDef replaceObjectAtIndex:t withObject:[ NSNumber numberWithInt:-hp ] ];
                
                if ( !end )
                {
                    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightBuff1" , nil ) , def.Name , skill.Des3 , hp ];
                    [ mapLayer battleLog:str ];
                }
                
            }
                break;
            case STGE_SP:
            {
                int sp = buff.Power * def.RealBaseData.MaxSP;
                
                if ( sp <= 0 )
                {
                    sp = 1;
                }
                
                def.RealBaseData.SP -= sp;
                
                int t = [ self getSelfTarget:defArray :def ];
                [ arrayDef replaceObjectAtIndex:t withObject:[ NSNumber numberWithInt:-sp ] ];
                
                if ( !end )
                {
                    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightBuff3" , nil ) , def.Name , skill.Des3 , sp ];
                    [ mapLayer battleLog:str ];
                }
                
            }
                break;
            case STGE_GIDDINESS:
            {
            }
                break;
            case STGE_HEALTH:
            case STGE_HEALTH1:
            {
                int hp = buff.Power;
                def.RealBaseData.HP += hp;
                int t = [ self getSelfTarget:defArray :def ];
                [ arrayDef replaceObjectAtIndex:t withObject:[ NSNumber numberWithInt:hp ] ];
                
                if ( !end )
                {
                    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightBuff4" , nil ) , def.Name , skill.Des3 , hp ];
                    [ mapLayer battleLog:str ];
                }
                
            }
                break;
            case STGE_HEALTHSP:
            case STGE_HEALTHSP1:
            {
                int sp = buff.Power;
                def.RealBaseData.SP += sp;
                int t = [ self getSelfTarget:defArray :def ];
                [ arrayDef replaceObjectAtIndex:t withObject:[ NSNumber numberWithInt:sp ] ];
                
                if ( !end )
                {
                    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightBuff5" , nil ) , def.Name , skill.Des3 , sp ];
                    [ mapLayer battleLog:str ];
                }
                
            }
                break;
            default:
                break;
        }
        
        if ( buff.Turn == 0 )
        {
            float power = 0;
            
            switch ( skill.TriggerEffect )
            {
                case STGE_CHARGE:
                {
                    int hp = buff.Power;
                    if ( hp <= 0 )
                    {
                        hp = 1;
                    }
                    def.RealBaseData.HP -= hp;
                    int t = [ self getSelfTarget:defArray :def ];
                    [ arrayDef replaceObjectAtIndex:t withObject:[ NSNumber numberWithInt:-hp ] ];
                    
                    if ( !end )
                    {
                        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightCharge" , nil ) , def.Name , hp ];
                        [ mapLayer battleLog:str ];
                    }
                }
                    break;
                case STGE_HATRED:
                {
                    int hp = buff.Power;
                    if ( hp <= 0 )
                    {
                        hp = 1;
                    }
                    
                    def.RealBaseData.HP -= hp;
                    def.RealBaseData.MaxHP -= hp;
                    
                    if ( def.RealBaseData.HP < 0 )
                    {
                        def.RealBaseData.HP = 1;
                    }
                    
                    power = buff.Power1;
                    def.RealBaseData.PDef -= power;
                }
                    break;
                case STGE_MAXHP:
                {
                    int hp = buff.Power;
                    if ( hp <= 0 )
                    {
                        hp = 1;
                    }
                    
                    def.RealBaseData.HP -= hp;
                    def.RealBaseData.MaxHP -= hp;
                    
                    if ( def.RealBaseData.HP < 0 )
                    {
                        def.RealBaseData.HP = 1;
                    }
                }
                    break;
                case STGE_MAXSP:
                {
                    int sp = buff.Power;
                    def.RealBaseData.SP -= sp;
                    def.RealBaseData.MaxSP -= sp;
                    
                    if ( def.RealBaseData.SP < 0 )
                    {
                        def.RealBaseData.SP = 0;
                    }
                }
                    break;
                case STGE_DEFATTR:
                {
                    power = buff.Power;
                    def.RealAttrDefence[ skill.Attribute ] -= power;
                }
                    break;
                case STGE_SPEED:
                {
                    power = buff.Power;
                    def.RealBaseData.Agile -= power;
                }
                    break;
                case STGE_MISS:
                {
                    power = buff.Power;
                    def.RealBaseData.Miss -= power;
                }
                    break;
                case STGE_HIT:
                {
                    power = buff.Power;
                    def.RealBaseData.Hit -= power;
                }
                    break;
                case STGE_PATK:
                {
                    power = buff.Power;
                    def.RealBaseData.PAtk -= power;
                }
                    break;
                case STGE_MATK:
                {
                    power = buff.Power;
                    def.RealBaseData.MAtk -= power;
                }
                    break;
                case STGE_PDEF:
                {
                    power = buff.Power;
                    def.RealBaseData.PDef -= power;
                }
                    break;
                case STGE_MDEF:
                {
                    power = buff.Power;
                    def.RealBaseData.MDef -= power;
                }
                    break;
                case STGE_CT:
                {
                    power = buff.Power;
                    def.RealBaseData.Critical -= power;
                }
                    break;
                default:
                    break;
            }

            if ( !end && skill.TriggerEffect != STGE_CHARGE )
            {
                NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHitAttr3" , nil ) ];
                [ mapLayer battleLog:str ];
            }
            
            
            [ arr addObject:[ NSNumber numberWithInt:i ] ];
        }
        
        b = YES;
        
        // 多个扣血buff有问题，
        [ LogUI fightSelf:hpArrayAtk : end ? NULL : skill.Effect :BRHS_HIT2 ];
        [ LogUI fightEnemy:hpArrayDef : end ? NULL : skill.Effect :BRHS_HIT2 ];
    }
    
    
    [ hpArrayAtk removeAllObjects ];
    [ hpArrayAtk release ];
    [ hpArrayDef removeAllObjects ];
    [ hpArrayDef release ];
    
    for ( int i = 0 ; i < arr.count ; ++i )
    {
        int index = [ [ arr objectAtIndex:i ] intValue ];
        
        index -= i;
        
        // 移除buff，，
        [ buffArray removeObjectAtIndex:index ];
    }
    
    [ arr removeAllObjects ];
    [ arr release ];
    
    [ self checkDead ];
    
    return b;
}

- ( BOOL ) hasBuff:( CreatureCommonData* )comm :( int )skillID
{
    for ( int i = 0 ; i < buffArray.count ; ++i )
    {
        SkillBuff* buff = [ buffArray objectAtIndex:i ];
        
        if ( buff.Target == comm )
        {
            if ( buff.SkillID == skillID )
            {
                return YES;
            }
        }
    }
    
    return NO;
}


- ( float ) getBuffPower:( CreatureCommonData* )comm :( int )triggerEffect
{
    for ( int i = 0 ; i < buffArray.count ; ++i )
    {
        SkillBuff* buff = [ buffArray objectAtIndex:i ];
        
        if ( buff.Target == comm )
        {
            SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:buff.SkillID ];
            
            if ( skill.TriggerEffect == triggerEffect )
            {
                return skill.Power;
            }
        }
    }
    
    return 0;
}


- ( float ) getBuffAttrPower:( CreatureCommonData* )comm :( int )attr
{
    for ( int i = 0 ; i < buffArray.count ; ++i )
    {
        SkillBuff* buff = [ buffArray objectAtIndex:i ];
        
        if ( buff.Target == comm )
        {
            SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:buff.SkillID ];
            
            if ( skill.TriggerEffect == STGE_DEFATTR &&
                skill.Attribute == attr )
            {
                return skill.Power;
            }
        }
    }
    
    return 1.0f;
}

- ( SkillConfigData* ) hasBuffWithEffect:( CreatureCommonData* )comm :( int )triggerEffect
{
    for ( int i = 0 ; i < buffArray.count ; ++i )
    {
        SkillBuff* buff = [ buffArray objectAtIndex:i ];
    
        if ( buff.Target == comm )
        {
            SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:buff.SkillID ];
            
            if ( skill.TriggerEffect == triggerEffect )
            {
                return skill;
            }
        }
    }
    
    return NULL;
}


- ( SkillBuff* ) addBuff:( int )skillID :( int )t :( float )p :( CreatureCommonData* )comm
{
    for ( int i = 0 ; i < buffArray.count ; ++i )
    {
        SkillBuff* buff = [ buffArray objectAtIndex:i ];
        
        if ( buff.Target == comm )
        {
            if ( skillID == buff.SkillID )
            {
                buff.Turn += t;
                return buff;
            }
        }
    }
    
    SkillBuff* buff = [ [ [ SkillBuff alloc ] init ] autorelease ];
    buff.SkillID = skillID;
    buff.Target = comm;
    buff.Power = p;
    buff.Turn = t;
    
    [ buffArray addObject:buff ];
    
    return buff;
}

//////////////////////////////////////////////////////////////

- ( BOOL ) useSkillHP:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    if ( skill.Hit && ( rand() % 100 ) > skill.Hit * 100.0f )
    {
        return NO;
    }
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    int hit = BRHS_HIT1;
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        
        int hp = 0;
        if ( skill.Type == ST_PHYSICAL )
        {
            hp = [ self pAttack:atk :def ];
        }
        else
        {
            hp = [ self mAttack:atk :def :skill.Attribute :skill.MonsterDamage ];
        }
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        if ( hitRandom.ID > hit )
        {
            hit = hitRandom.ID;
        }
        
        if ( hp * skill.Power * hitRandom.Value < skill.MinDamage )
        {
            hp = skill.MinDamage * hitRandom.Value;
        }
        else
        {
            hp = hp * hitRandom.Value * skill.Power;
        }
        
        if ( hp <= 0 )
        {
            hp = 1;
        }
        
        def.RealBaseData.HP -= hp;
        
        [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
        [ mapLayer battleLog:str ];
        
        NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , hitRandom.ID ];
        str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
        [ mapLayer battleLog:str ];
        
        if ( skill.Turn )
        {
            if ( ( rand() % 100 ) < skill.Hit * 100.0f )
            {
                if ( [ self hasBuff:def :skill.SkillID ] )
                {
                    str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit6" , nil ) ];
                    [ mapLayer battleLog:str ];
                }
                else
                {
                    str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit7" , nil ) , def.Name , skill.Des3 ];
                    [ mapLayer battleLog:str ];
                }
                
                [ self addBuff:skill.SkillID :skill.Turn :skill.Power :def ];
            }
            else
            {
                str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightMiss" , nil ) , def.Name ];
                [ mapLayer battleLog:str ];
            }
        }

    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightSelf:hpArrayDef :skill.Effect :hit ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightEnemy:hpArrayDef :skill.Effect :hit ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;

    return YES;
}

- ( BOOL ) useSkillSP:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
//        int sp = 0;
//        if ( skill.Type == ST_PHYSICAL )
//        {
//            sp = [ self pAttack:atk :def ];
//        }
//        else
//        {
//            sp = [ self mAttack:atk :def :skill.Attribute :skill.MonsterDamage ];
//        }
//        
//        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
//        
//        sp = sp * hitRandom.Value * skill.Power;
//        
//        
//        def.RealBaseData.SP -= sp;
//        
//        [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-sp ] ];
//        
//        
//        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name , sp ];
//        [ mapLayer battleLog:str ];
        
        if ( skill.Turn )
        {
            if ( ( rand() % 100 ) < skill.Hit * 100.0f )
            {
                if ( [ self hasBuff:def :skill.SkillID ] )
                {
                    str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit6" , nil ) ];
                    [ mapLayer battleLog:str ];
                }
                else
                {
                    str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit7" , nil ) , def.Name , skill.Des3 ];
                    [ mapLayer battleLog:str ];
                }
                
                [ self addBuff:skill.SkillID :skill.Turn :skill.Power :def ];
            }
            else
            {
                str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightMiss" , nil ) , def.Name ];
                [ mapLayer battleLog:str ];
            }
        }

    }
    
//    switch ( atk.Group )
//    {
//        case GROUP_ENEMY:
//            [ LogUI fightSelf:hpArrayDef :skill.Effect ];
//            //[ LogUI fightEnemy:hpArrayAtk :NULL ];
//            break;
//        case GROUP_PLAYER:
//            [ LogUI fightEnemy:hpArrayDef :skill.Effect ];
//            //[ LogUI fightSelf:hpArrayAtk :NULL ];
//            break;
//        default:
//            break;
//    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}

- ( BOOL ) useSkillHP2:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    if ( skill.Hit && ( rand() % 100 ) > skill.Hit * 100.0f )
    {
        return NO;
    }
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    int hit = BRHS_HIT1;
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        int hp = 0;
        if ( skill.Type == ST_PHYSICAL )
        {
            hp = [ self pAttack:atk :def ];
        }
        else
        {
            hp = [ self mAttack:atk :def :skill.Attribute :skill.MonsterDamage ];
        }
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        if ( hitRandom.ID > hit )
        {
            hit = hitRandom.ID;
        }
        
        if ( hp * skill.Power * hitRandom.Value < skill.MinDamage )
        {
            hp = skill.MinDamage * hitRandom.Value;
        }
        else
        {
            hp = hp * hitRandom.Value * skill.Power;
        }
        
        if ( hp <= 0 )
        {
            hp = 1;
        }
        
        def.RealBaseData.HP -= hp;
        
        int hp1 = [ [ hpArrayDef objectAtIndex:i ] intValue ];
        [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp + hp1 ] ];
        
        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
        [ mapLayer battleLog:str ];
        
        NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , hitRandom.ID ];
        str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
        [ mapLayer battleLog:str ];
    }
    
    
    
    return YES;
}


- ( BOOL ) useSkillHP3:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    int hit = BRHS_HIT1;
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        int hp = 0;
        if ( skill.Type == ST_PHYSICAL )
        {
            hp = [ self pAttack:atk :def ];
        }
        else
        {
            hp = [ self mAttack:atk :def :skill.Attribute :skill.MonsterDamage ];
        }
        
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        if ( hitRandom.ID > hit )
        {
            hit = hitRandom.ID;
        }
        
        if ( hp * hitRandom.Value * skill.Power < skill.MinDamage )
        {
            hp = skill.MinDamage * hitRandom.Value;
        }
        else
        {
            hp = hp * hitRandom.Value * skill.Power;
        }
        
        if ( hp <= 0 )
        {
            hp = 1;
        }
        
        def.RealBaseData.HP -= hp;
        
        [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
        
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
        [ mapLayer battleLog:str ];
        
        NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , hitRandom.ID ];
        str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
        [ mapLayer battleLog:str ];
    }
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        if ( targetOne >= 0 && i != targetOne && !def.Dead )
        {
            int hp = 0;
            if ( skill.Type == ST_PHYSICAL )
            {
                hp = [ self pAttack:atk :def ];
            }
            else
            {
                hp = [ self mAttack:atk :def :skill.Attribute :skill.MonsterDamage ];
            }
            
            HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
            
            if ( hp * skill.Power1 * hitRandom.Value < skill.MinDamage )
            {
                hp = skill.MinDamage * hitRandom.Value;
            }
            else
            {
                hp = hp * hitRandom.Value * skill.Power1;
            }
            
            if ( hp <= 0 )
            {
                hp = 1;
            }
            
            def.RealBaseData.HP -= hp;
            
            [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
            
            NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , hitRandom.ID ];
            str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
            [ mapLayer battleLog:str ];
            
            break;
        }
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightSelf:hpArrayDef :skill.Effect :hit ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightEnemy:hpArrayDef :skill.Effect :hit ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}

- ( BOOL ) useSkillHP4:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        int hp = def.RealBaseData.HP * skill.Power;
        
        if ( hp <= 0 )
        {
            hp = 1;
        }
        
        def.RealBaseData.HP -= hp;
        
        [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
        [ mapLayer battleLog:str ];
        
        NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , BRHS_HIT2 ];
        str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
        [ mapLayer battleLog:str ];
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightSelf:hpArrayDef :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightEnemy:hpArrayDef :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


- ( BOOL ) useSkillHP5:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    if ( skill.Hit && ( rand() % 100 ) > skill.Hit * 100.0f )
    {
        return NO;
    }
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    int hit = BRHS_HIT1;
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        
        int hp = 0;
        if ( skill.Type == ST_PHYSICAL )
        {
            hp = [ self pAttack:atk :def ];
        }
        else
        {
            hp = [ self mAttack:atk :def :skill.Attribute :skill.MonsterDamage ];
        }
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        if ( hitRandom.ID > hit )
        {
            hit = hitRandom.ID;
        }
        
        if ( hp * skill.Power * hitRandom.Value < skill.MinDamage )
        {
            hp = skill.MinDamage * hitRandom.Value;
        }
        else
        {
            hp = hp * hitRandom.Value * skill.Power;
        }
        
        if ( hp <= 0 )
        {
            hp = 1;
        }
        
        int t = [ self getSelfTarget:atkArray :atk ];
        int hp1 = [ [ hpArrayAtk objectAtIndex:t ] intValue ] + hp * skill.Power1;
        if ( hp1 <= 0 )
        {
            hp1 = 1;
        }
        [ hpArrayAtk replaceObjectAtIndex:t withObject:[ NSNumber numberWithInt:hp1 ] ];

        def.RealBaseData.HP -= hp;
        
        [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
        [ mapLayer battleLog:str ];
        
        NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , hitRandom.ID ];
        str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
        [ mapLayer battleLog:str ];
        
        if ( skill.Turn )
        {
            if ( ( rand() % 100 ) < skill.Hit * 100.0f )
            {
                if ( [ self hasBuff:def :skill.SkillID ] )
                {
                    str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit6" , nil ) ];
                    [ mapLayer battleLog:str ];
                }
                else
                {
                    str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit7" , nil ) , def.Name , skill.Des3 ];
                    [ mapLayer battleLog:str ];
                }
                
                [ self addBuff:skill.SkillID :skill.Turn :skill.Power :def ];
            }
            else
            {
                str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightMiss" , nil ) , def.Name ];
                [ mapLayer battleLog:str ];
            }
        }
        
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightSelf:hpArrayDef :skill.Effect :hit ];
            [ LogUI fightEnemy:hpArrayAtk :NULL :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightEnemy:hpArrayDef :skill.Effect :hit ];
            [ LogUI fightSelf:hpArrayAtk :NULL :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


- ( BOOL ) useSkillCharge:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        int hp = 0;
        if ( skill.Type == ST_PHYSICAL )
        {
            hp = [ self pAttack:atk :def ];
        }
        else
        {
            hp = [ self mAttack:atk :def :skill.Attribute :skill.MonsterDamage ];
        }
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        if ( hp * skill.Power * hitRandom.Value < skill.MinDamage )
        {
            hp = skill.MinDamage * hitRandom.Value;
        }
        else
        {
            hp = hp * hitRandom.Value * skill.Power;
        }
        
        if ( skill.Turn )
        {
            [ self addBuff:skill.SkillID :skill.Turn :hp :def ];
        }
        
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


- ( BOOL ) useSkillGold:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    int hit = BRHS_HIT1;
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        int hp = 0;
        if ( skill.Type == ST_PHYSICAL )
        {
            hp = [ self pAttack:atk :def ];
        }
        else
        {
            hp = [ self mAttack:atk :def :skill.Attribute :skill.MonsterDamage ];
        }
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        if ( hitRandom.ID > hit )
        {
            hit = hitRandom.ID;
        }
        
        if ( hp * hitRandom.Value < skill.MinDamage )
        {
            hp = skill.MinDamage * hitRandom.Value;
        }
        else
        {
            hp = hp * hitRandom.Value;
        }
        
        if ( hp <= 0 )
        {
            hp = 1;
        }
        
        if ( ( rand() % 100 ) < skill.Hit * 100.0f )
        {
            int dropGold = 0;
            
            for ( int i = 0 ; i < def.Drop.count ; ++i )
            {
                CreatureBaseIDPerNum* drop = [ def.Drop objectAtIndex:i ];
                int item = drop.ID;
                
                ItemConfigData* data = [ [ ItemConfig instance ] getData:item ];
                
                if ( data.AutoSell )
                {
                    dropGold += data.Sell * skill.Power;
                    mapLayer.DropGold += dropGold;
                    [ [ PlayerData instance ] addGold:dropGold ];
                }
            }
            
            hp = MAX_HP;
            
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHitGold" , nil ) , dropGold ];
            [ mapLayer battleLog:str ];
        }
        else
        {
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHitGoldMiss" , nil ) ];
            [ mapLayer battleLog:str ];
        }

        
        def.RealBaseData.HP -= hp;
        
        [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
        [ mapLayer battleLog:str ];
        
        NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , hitRandom.ID ];
        str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
        [ mapLayer battleLog:str ];
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightSelf:hpArrayDef :skill.Effect :hit ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightEnemy:hpArrayDef :skill.Effect :hit ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}



- ( BOOL ) useSkillHealth:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_HEALTH )
    {
        targetOne = [ self getMinHPTarget:atkArray ];
        
        CreatureCommonData* comm = [ atkArray objectAtIndex:targetOne ];
        
        if ( comm.RealBaseData.HP / comm.RealBaseData.MaxHP > 0.5f )
        {
            return NO;
        }
    }
    else if ( skill.Target == STT_HEALTHALL )
    {
        BOOL b = NO;
        
        for ( int i = 0 ; i < atkArray.count ; ++i )
        {
            CreatureCommonData* comm = [ atkArray objectAtIndex:i ];
            
            if ( comm.RealBaseData.HP / comm.RealBaseData.MaxHP < 0.5f )
            {
                b = YES;
            }
        }
        
        if ( !b )
        {
            return NO;
        }
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ atkArray objectAtIndex:i ];
        
        int hp = 0;
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        hp = def.RealBaseData.MAtk * hitRandom.Value * skill.Power;
        def.RealBaseData.HP += hp;
        
        [ hpArrayAtk replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:hp ] ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHealth" , nil ) , def.Name , hp ];
        [ mapLayer battleLog:str ];
        
    }
    
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightEnemy:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightSelf:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


- ( BOOL ) useSkillHealth1:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_HEALTH )
    {
        targetOne = [ self getMinHPTarget:atkArray ];
        
        CreatureCommonData* comm = [ atkArray objectAtIndex:targetOne ];
        
        if ( comm.RealBaseData.HP / comm.RealBaseData.MaxHP > 0.5f )
        {
            return NO;
        }
    }
    else if ( skill.Target == STT_HEALTHALL )
    {
        BOOL b = NO;
        
        for ( int i = 0 ; i < atkArray.count ; ++i )
        {
            CreatureCommonData* comm = [ atkArray objectAtIndex:i ];
            
            if ( comm.RealBaseData.HP / comm.RealBaseData.MaxHP < 0.5f )
            {
                b = YES;
            }
        }
        
        if ( !b )
        {
            return NO;
        }
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ atkArray objectAtIndex:i ];
        
        int hp = 0;
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        hp = def.RealBaseData.MaxHP * hitRandom.Value * skill.Power;
        
        if ( hp < skill.MinDamage )
        {
            hp = skill.MinDamage * hitRandom.Value;
        }
        
        def.RealBaseData.HP += hp;
        
        [ hpArrayAtk replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:hp ] ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHealth" , nil ) , def.Name , hp ];
        [ mapLayer battleLog:str ];
        
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightEnemy:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightSelf:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


- ( BOOL ) useSkillHealthSP:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_HEALTH )
    {
        targetOne = [ self getMinHPTarget:atkArray ];
        
        CreatureCommonData* comm = [ atkArray objectAtIndex:targetOne ];
        
        if ( comm.RealBaseData.SP / comm.RealBaseData.MaxSP > 0.5f )
        {
            //return NO;
        }
    }
    else if ( skill.Target == STT_HEALTHALL )
    {
        BOOL b = NO;
        
        for ( int i = 0 ; i < atkArray.count ; ++i )
        {
            CreatureCommonData* comm = [ atkArray objectAtIndex:i ];
            
            if ( comm.RealBaseData.SP / comm.RealBaseData.MaxSP < 0.5f )
            {
                b = YES;
            }
        }
        
        if ( !b )
        {
            //return NO;
        }
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ atkArray objectAtIndex:i ];
        
        int sp = 0;
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        sp = def.RealBaseData.SP * hitRandom.Value * skill.Power;
        def.RealBaseData.SP += sp;
        
        [ hpArrayAtk replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:sp ] ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHealthSP" , nil ) , def.Name , sp ];
        [ mapLayer battleLog:str ];
        
    }
    
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightEnemy:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightSelf:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


- ( BOOL ) useSkillHealthSP1:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_HEALTH )
    {
        targetOne = [ self getMinHPTarget:atkArray ];
        
        CreatureCommonData* comm = [ atkArray objectAtIndex:targetOne ];
        
        if ( comm.RealBaseData.SP / comm.RealBaseData.MaxSP > 0.5f )
        {
            return NO;
        }
    }
    else if ( skill.Target == STT_HEALTHALL )
    {
        BOOL b = NO;
        
        for ( int i = 0 ; i < atkArray.count ; ++i )
        {
            CreatureCommonData* comm = [ atkArray objectAtIndex:i ];
            
            if ( comm.RealBaseData.SP / comm.RealBaseData.MaxSP < 0.5f )
            {
                b = YES;
            }
        }
        
        if ( !b )
        {
            return NO;
        }
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ atkArray objectAtIndex:i ];
        
        int sp = 0;
        
        HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
        
        sp = hitRandom.Value * skill.Power * def.RealBaseData.MaxSP;
        def.RealBaseData.SP += sp;
        
        [ hpArrayAtk replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:sp ] ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHealthSP" , nil ) , def.Name , sp ];
        [ mapLayer battleLog:str ];
    }
    
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightEnemy:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightSelf:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


- ( BOOL ) useSkillRelive:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_HEALTH )
    {
        targetOne = [ self getDeadTarget:atkArray ];
        
        if ( targetOne == INVALID_ID )
        {
            return NO;
        }
    }
    else if ( skill.Target == STT_HEALTHALL )
    {
        int target = [ self getDeadTarget:atkArray ];
        
        if ( target == INVALID_ID )
        {
            return NO;
        }
    }
    
     NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ atkArray objectAtIndex:i ];
        
        if ( !def.Dead )
        {
            continue;
        }
        
        if ( ( rand() % 100 ) < skill.Hit * 100.0f )
        {
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHitRelive" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
            
            int hp = 0;
            
            HitConfigData* hitRandom = [ self pHitRandom:atk :def ];
            
            hp = def.RealBaseData.MaxHP * hitRandom.Value * skill.Power;
            def.RealBaseData.HP += hp;
            def.Dead = NO;
            
            [ hpArrayAtk replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:hp ] ];
        }
        else
        {
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHitReliveMiss" , nil ) ];
            [ mapLayer battleLog:str ];
        }
    }
    
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightEnemy:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightSelf:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    if ( skill.SP == 0 )
    {
        atk.RealBaseData.SP = 0;
    }
    else
    {
        atk.RealBaseData.SP -= skill.SP;
    }
    
    return YES;
}


- ( BOOL ) useSkillDeath:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        int hp = 0;
        
        if ( ( rand() % 100 ) < skill.Hit * 100.0f )
        {
            hp = MAX_HP;
            
        }
        else
        {
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightMiss" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
        }
        
        
        if ( hp )
        {
            def.RealBaseData.HP -= hp;
            
            [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
            
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
            
            NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , BRHS_HIT2 ];
            str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
            [ mapLayer battleLog:str ];
        }
        
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightSelf:hpArrayDef :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightEnemy:hpArrayDef :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}

- ( BOOL ) useSkillDeath1:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
 
    if ( ( rand() % 100 ) > skill.Hit * 100.0f )
    {
        return NO;
    }
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        int hp = MAX_HP;
        
        
        if ( hp )
        {
            def.RealBaseData.HP -= hp;
            
            [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
            
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
            
            NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , BRHS_HIT2 ];
            str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
            [ mapLayer battleLog:str ];
        }
        
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightSelf:hpArrayDef :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightEnemy:hpArrayDef :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}

- ( BOOL ) useSkillDeath2:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        if ( [ self hasBuff:def :skill.SkillID ] )
        {
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit6" , nil ) ];
            [ mapLayer battleLog:str ];
        }
        else
        {
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHit7" , nil ) , def.Name , skill.Des3 ];
            [ mapLayer battleLog:str ];
        }
        
        [ self addBuff:skill.SkillID :skill.Turn :skill.Power :def ];
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}

- ( BOOL ) useSkillDeath3:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    if ( ( rand() % 100 ) > skill.Hit * 100.0f )
    {
        return NO;
    }
    
    int targetOne = INVALID_ID;
    if ( skill.Target == STT_TARGET )
    {
        targetOne = [ self getOneTarget:targets :defArray ];
    }
    
    BOOL b1 = NO;
    
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ defArray objectAtIndex:i ];
        
        if ( def.RealBaseData.HP > def.RealBaseData.MaxHP * skill.Power )
        {
            return NO;
        }
        
        int hp = MAX_HP;
        
        if ( !b1 )
        {
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
            [ mapLayer battleLog:str ];
            b1 = YES;
        }
        
        if ( hp )
        {
            def.RealBaseData.HP -= hp;
            
            [ hpArrayDef replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:-hp ] ];
            
            NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightDamage" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
            
            NSString* str2 = [ NSString stringWithFormat:@"FightDamageHP%d" , BRHS_HIT2 ];
            str = [ NSString localizedStringWithFormat:NSLocalizedString( str2 , nil ) , hp ];
            [ mapLayer battleLog:str ];
        }
        
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightSelf:hpArrayDef :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightEnemy:hpArrayDef :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


- ( BOOL ) useSkillDeath2Buff:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    if ( ( rand() % 100 ) < skill.Hit * 100.0f )
    {
        int hp = MAX_HP;
        
        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightBut" , nil ) ];
        [ mapLayer battleLog:str ];
        
        str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightBuff1" , nil ) , atk.Name , skill.Des3 , hp ];
        [ mapLayer battleLog:str ];
        
        int t = [ self getSelfTarget:atkArray :atk ];
        atk.RealBaseData.HP -= hp;
        
        [ hpArrayAtk replaceObjectAtIndex:t withObject:[ NSNumber numberWithInt:-hp ] ];
        
        switch ( atk.Group )
        {
            case GROUP_ENEMY:
                [ LogUI fightEnemy:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
                break;
            case GROUP_PLAYER:
                [ LogUI fightSelf:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
                break;
            default:
                break;
        }
        
        return YES;
    }
    
    return NO;
}


- ( BOOL ) useSkillDeath4:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    int targetOne = [ self getSelfTarget:atkArray :atk ];
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    hpArrayAtk = [ [ NSMutableArray alloc ] init ];
    hpArrayDef = [ [ NSMutableArray alloc ] init ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        [ hpArrayAtk addObject:[ NSNumber numberWithInt:0 ] ];
    }
    for ( int i = 0 ; i < defArray.count ; ++i )
    {
        [ hpArrayDef addObject:[ NSNumber numberWithInt:0 ] ];
    }
    
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ atkArray objectAtIndex:i ];
        
        int hp = 0;
        
        if ( ( rand() % 100 ) < skill.Hit * 100.0f )
        {
            hp = def.RealBaseData.MaxHP * skill.Power;
            
        }
        else
        {
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightMiss" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
        }
        
        
        if ( hp )
        {
            def.RealBaseData.HP += hp;
            def.Dead = NO;
            
            [ hpArrayAtk replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:hp ] ];
            
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHealth" , nil ) , def.Name , hp ];
            [ mapLayer battleLog:str ];
        }
        
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightEnemy:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightSelf:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    [ hpArrayAtk release ];
    [ hpArrayDef release ];
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


- ( BOOL ) useSkillDeath5:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < atkArray.count ; ++i )
    {
        CreatureCommonData* def = [ atkArray objectAtIndex:i ];
        
        int hp = 0;
        
        if ( ( rand() % 100 ) < skill.Hit * 100.0f )
        {
            hp = def.RealBaseData.MaxHP * skill.Power;
        }
        else
        {
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightMiss" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
        }
        
        if ( def.Dead )
        {
            hp = def.RealBaseData.MaxHP * skill.Power;
        }
        else
        {
            hp = -MAX_HP;
        }
        
        if ( hp > 0 )
        {
            def.RealBaseData.HP += hp;
            def.Dead = NO;
            
            [ hpArrayAtk replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:hp ] ];
            
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHealth" , nil ) , def.Name , hp ];
            [ mapLayer battleLog:str ];
        }
        else
        {
            def.RealBaseData.HP += hp;
            
            [ hpArrayAtk replaceObjectAtIndex:i withObject:[ NSNumber numberWithInt:hp ] ];
        }
        
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightEnemy:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightSelf:hpArrayAtk :skill.Effect :BRHS_HIT2 ];
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}



- ( BOOL ) useSkillHatred:( CreatureCommonData* )atk :( int )skillID
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHatred" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];

    
    SkillBuff* buff = [ self addBuff:skill.SkillID :skill.Turn :0.0f :atk ];
    
    atk.RealBaseData.SP -= skill.SP;
    
    float power = atk.RealBaseData.MaxHP * skill.Power;
    int hp = power;
    atk.RealBaseData.HP += hp;
    atk.RealBaseData.MaxHP += hp;
    buff.Power = power;
    
    power = atk.RealBaseData.PDef * skill.Power;
    atk.RealBaseData.PDef += power;
    buff.Power1 = power;
    
    int t = [ self getSelfTarget:atkArray :atk ];
    [ hpArrayAtk replaceObjectAtIndex:t withObject:[ NSNumber numberWithFloat:power ] ];
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            [ LogUI fightEnemyF:hpArrayAtk :skill.Effect ];
            break;
        case GROUP_PLAYER:
            [ LogUI fightSelfF:hpArrayAtk :skill.Effect ];
            break;
    }
    
    return YES;
}



- ( BOOL ) useSkillDefAttr:( CreatureCommonData* )atk :( int )skillID :( int )t
{
    SkillConfigData* skill = [ [ SkillConfig instance ] getSkill:skillID ];
    
    NSArray* array = atkArray;
    NSMutableArray* hpArray = hpArrayAtk;
    
    int targetOne = INVALID_ID;
    BOOL other = NO;
    
    
    switch ( skill.Target )
    {
        case STT_TARGET:
            hpArray = hpArrayDef;
            array = defArray;
            targetOne = [ self getOneTarget:targets :defArray ];
            other = YES;
            break;
        case STT_TARGETALL:
            hpArray = hpArrayDef;
            array = defArray;
            other = YES;
            break;
        case STT_HEALTH:
            targetOne = [ self getOneTarget:targetsSelf :atkArray ];
            break;
        case STT_SELF:
            targetOne = [ self getSelfTarget:atkArray :atk ];
            break;
        case STT_HEALTHALL:
            break;
    }
    
    
    if ( !skill.Turn )
    {
        return NO;
    }
    
    NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightSkill" , nil ) , skill.Name ];
    [ mapLayer battleLog:str ];
    
    for ( int i = 0 ; i < array.count ; ++i )
    {
        if ( targetOne >= 0 && i != targetOne )
        {
            continue;
        }
        
        CreatureCommonData* def = [ array objectAtIndex:i ];
        
        float power = 0;
        
        if ( other )
        {
            if ( ( rand() % 100 ) < skill.Hit * 100.0f )
            {
                str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHitAttr2" , nil ) , def.Name ];
                [ mapLayer battleLog:str ];
            }
            else
            {
                str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightMiss" , nil ) , def.Name ];
                [ mapLayer battleLog:str ];
                
                continue;
            }
        }
        else
        {
            str = [ NSString localizedStringWithFormat:NSLocalizedString( @"FightHitAttr1" , nil ) , def.Name ];
            [ mapLayer battleLog:str ];
        }
        
        switch ( t )
        {
            case STGE_MAXHP:
            {
                power = def.RealBaseData.MaxHP * skill.Power;
                int hp = power;
                def.RealBaseData.HP += hp;
                def.RealBaseData.MaxHP += hp;
                
                if ( def.RealBaseData.HP < 0 )
                {
                    def.RealBaseData.HP = 1;
                }
            }
                break;
            case STGE_MAXSP:
            {
                power = def.RealBaseData.MaxSP * skill.Power;
                int sp = power;
                def.RealBaseData.SP += sp;
                def.RealBaseData.MaxSP += sp;
                
                if ( def.RealBaseData.SP < 0 )
                {
                    def.RealBaseData.SP = 0;
                }
            }
                break;
            case STGE_DEFATTR:
            {
                power = skill.Power;
                def.RealAttrDefence[ skill.Attribute ] += power;
            }
                break;
            case STGE_SPEED:
            {
                power = def.RealBaseData.Agile * skill.Power;
                def.RealBaseData.Agile += power;
            }
                break;
            case STGE_MISS:
            {
                power = skill.Power;
                def.RealBaseData.Miss += skill.Power;
            }
                break;
            case STGE_HIT:
            {
                power = skill.Power;
                def.RealBaseData.Hit += power;
            }
                break;
            case STGE_PATK:
            {
                power = def.RealBaseData.PAtk * skill.Power;
                def.RealBaseData.PAtk += power;
            }
                break;
            case STGE_MATK:
            {
                power = def.RealBaseData.MAtk * skill.Power;
                def.RealBaseData.MAtk += power;
            }
                break;
            case STGE_PDEF:
            {
                power = def.RealBaseData.PDef * skill.Power;
                def.RealBaseData.PDef += power;
            }
                break;
            case STGE_MDEF:
            {
                power = def.RealBaseData.MDef * skill.Power;
                def.RealBaseData.MDef += power;
            }
                break;
            case STGE_CT:
            {
                power = skill.Power;
                def.RealBaseData.Critical += power;
            }
                break;
            default:
                break;
        }
        
        [ hpArray replaceObjectAtIndex:i withObject:[ NSNumber numberWithFloat:power ] ];
        
        if ( skill.Turn )
        {
            [ self addBuff:skill.SkillID :skill.Turn :power :def ];
        }
    }
    
    switch ( atk.Group )
    {
        case GROUP_ENEMY:
            if ( other )
            {
                [ LogUI fightSelfF:hpArray :skill.Effect ];
            }
            else
            {
                [ LogUI fightEnemyF:hpArray :skill.Effect ];
            }
            break;
        case GROUP_PLAYER:
            if ( other )
            {
                [ LogUI fightEnemyF:hpArray :skill.Effect ];
            }
            else
            {
                [ LogUI fightSelfF:hpArray :skill.Effect ];
            }
            break;
        default:
            break;
    }
    
    atk.RealBaseData.SP -= skill.SP;
    
    return YES;
}


@end



