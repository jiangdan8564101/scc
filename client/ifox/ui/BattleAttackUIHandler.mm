//
//  BattleAttackUIHandler.m
//  sc
//
//  Created by fox on 13-5-5.
//
//

#import "BattleAttackUIHandler.h"
#import "BattleStage.h"

@implementation BattleAttackUIHandler


static BattleAttackUIHandler* gBattleAttackUIHandler;
+ (BattleAttackUIHandler*) instance
{
    if ( !gBattleAttackUIHandler )
    {
        gBattleAttackUIHandler = [ [ BattleAttackUIHandler alloc] init ];
        [ gBattleAttackUIHandler initUIHandler:@"BattleAttackView" isAlways:YES isSingle:NO ];
    }
    
    return gBattleAttackUIHandler;
}


- ( void ) onInited
{
//    viewHP1 = (BattleNumberView*)[ view viewWithTag:2000 ];
//    [ viewHP1 initView:@"a" :21 :32 ];
//    [ viewHP1 setNumber:123 ];
//    viewHP2 = (BattleNumberView*)[ view viewWithTag:2001 ];
//    [ viewHP2 initView:@"a" :21 :32 ];
//    [ viewHP2 setNumber:123 ];
//    
//
//    //results[ 0 ].hp = 42;
//    
//    [self playTurn ];
    
//    [ view1 setNumber:123 ];
//    [ view1 changeNumber:555 ];
//    [ view1 changeNumber:123 ];
}

- ( void ) update:(float)delay
{
    [ viewHP1 update:delay ];
    [ viewHP2 update:delay ];
}


- ( void ) setData:( battleResult* )r
{
    result = *r;
}


- ( void ) nextTurn
{
    playTurn++;
    
    if ( playTurn == result.turn )
    {
        [ self visible:NO ];
        
        // end
        [ [ BattleStage instance ] endPlayAttackUI ];
        
        return;
    }
    
    [ self playTurn ];
}


- ( void ) playTurn
{
    battleResultTurn& t = result.turns[ playTurn ];
    
    UIImage* image = nil;
    
    t.type = BATTLE_RESULT_DAMAGE;
    
    
        
    BattleNumberView* nv = [ [ BattleNumberView alloc ] init ];
    [ nv setType:1 ];
    [ view addSubview:nv ];
    
    switch ( t.type )
    {
        case BATTLE_RESULT_DAMAGE:
            image = [ UIImage imageNamed:@"battleSdamage.png" ];
            [ nv initView:@"b" :31 :46 ];
            [ nv setNumber:t.hp ];
            break;
        case BATTLE_RESULT_CRITICAL:
            image = [ UIImage imageNamed:@"battleScritical.png" ];
            [ nv initView:@"b" :31 :46 ];
            [ nv setNumber:t.hp ];
            break;
        case BATTLE_RESULT_MISS:
            image = [ UIImage imageNamed:@"battleSmiss.png" ];
            break;
        case BATTLE_RESULT_RECOVERY:
            image = [ UIImage imageNamed:@"battleSrecovery.png" ];
            [ nv initView:@"c" :31 :46 ];
            [ nv setNumber:t.hp ];
            break;
        default:
            break;
    }
    
    
    UIImageView* v = [ [ UIImageView alloc ] initWithImage:image ];
    [ view addSubview:v ];

    
    
    if ( t.side == 1 )
    {
        [ v setCenter:CGPointMake( 400 , 330 ) ];
        [ nv setCenter:CGPointMake( 400 , 400 ) ];
        
        [ [ view viewWithTag:1030 ] setHidden:NO ];
        [ [ view viewWithTag:1031 ] setHidden:YES ];
    }
    else
    {
        [ v setCenter:CGPointMake( 640 , 330 ) ];
        [ nv setCenter:CGPointMake( 640 , 400 ) ];
        
        [ [ view viewWithTag:1030 ] setHidden:YES ];
        [ [ view viewWithTag:1031 ] setHidden:NO ];
    }
    
    [ UIView animateWithDuration:0.2f
                     animations:^{
                         v.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                         //nv.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                     }completion:^(BOOL finish){
                         [ UIView animateWithDuration:0.15f
                                          animations:^{
                                              v.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                              //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                          }completion:^(BOOL finish){
                                              [ UIView animateWithDuration:0.5f
                                                               animations:^{
                                                                   v.transform = CGAffineTransformMakeScale(1, 1);
                                                                   //nv.transform = CGAffineTransformMakeScale(1, 1);
                                                               }completion:^(BOOL finish){
                                                                   [ v removeFromSuperview ];
                                                                   [ v release ];
                                                                   
                                                                   [ nv removeFromSuperview ];
                                                                   [ nv release ];
                                                                   
                                                                   [ self nextTurn ];
                                                               }];
                                          }];
                     }];
    
}


- ( void ) play
{
    playTurn = 0;
    
    [ self visible:YES ];
    [ self playTurn ];
}


@end



