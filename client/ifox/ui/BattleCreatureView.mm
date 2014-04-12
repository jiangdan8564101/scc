//
//  BattleCreatureView.m
//  sc
//
//  Created by fox on 13-9-2.
//
//

#import "BattleCreatureView.h"

@implementation BattleCreatureView




- ( void ) setData:( CreatureCommonData* )c
{
    NSString* str = [ NSString stringWithFormat:@"CB%@B" , c.Action ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:HEAD_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    [ imageView setImage:image ];
    
    [ self updateData:c ];
}

- ( void ) updateData:( CreatureCommonData* )c
{
    CGRect f = hpView.frame;
    f.size.width = bgView.frame.size.width * ( c.RealBaseData.HP / c.RealBaseData.MaxHP );
    
    if ( f.size.width < 0.05f )
    {
        f.size.width = 0.0f;
    }
    if ( f.size.width > bgView.frame.size.width )
    {
        f.size.width = bgView.frame.size.width;
    }
    [ hpView setFrame:f ];
    
    f = spView.frame;
    f.size.width = bgView.frame.size.width * ( c.RealBaseData.SP / c.RealBaseData.MaxSP );
    
    if ( f.size.width < 0.05f )
    {
        f.size.width = 0.0f;
    }
    if ( f.size.width > bgView.frame.size.width )
    {
        f.size.width = bgView.frame.size.width;
    }
    [ spView setFrame:f ];
    
    f = fsView.frame;
    f.size.width = bgView.frame.size.width * ( c.RealBaseData.FS / (float)c.RealBaseData.MaxFS );
    
    if ( f.size.width < 0.05f )
    {
        f.size.width = 0.0f;
    }
    if ( f.size.width > bgView.frame.size.width )
    {
        f.size.width = bgView.frame.size.width;
    }
    [ fsView setFrame:f ];
    
    [ lvLabel setLabelText:[ NSString stringWithFormat:@"LV:%d" , c.Level ] ];
    [ hpLabel setLabelText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.HP , (int)c.RealBaseData.MaxHP ] ];
    [ spLabel setLabelText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.SP , (int)c.RealBaseData.MaxSP ] ];
    [ fsLabel setLabelText:[ NSString stringWithFormat:@"%d/%d" , (int)c.RealBaseData.FS , (int)c.RealBaseData.MaxFS ] ];
}

- ( void ) initBattleCreatureView
{
    numberViewOri = ( BattleNumberView* )[ self viewWithTag:200 ];
    imageView = ( UIImageView* )[ self viewWithTag:100 ];
    
    view = ( UIView* )[ self viewWithTag:110 ];
    
    
    hpView = ( UIImageView* )[ self viewWithTag:300 ];
    spView = ( UIImageView* )[ self viewWithTag:301 ];
    fsView = ( UIImageView* )[ self viewWithTag:302 ];
    bgView = ( UIImageView* )[ self viewWithTag:310 ];
    
    hpLabel = ( UILabelStroke* )[ self viewWithTag:320 ];
    spLabel = ( UILabelStroke* )[ self viewWithTag:321 ];
    fsLabel = ( UILabelStroke* )[ self viewWithTag:322 ];
    lvLabel = ( UILabelStroke* )[ self viewWithTag:323 ];
    
    effect = (UIEffectAction*)[ self viewWithTag:400 ];
    [ effect initUIEffect:self :@selector( onEffectOver: ) ];
}


- ( void ) releaseBattleCreatureView
{
    
}

- ( void ) startFight
{
    
    [ UIView animateWithDuration:0.05f
                      animations:^{
                          view.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                      }completion:^(BOOL finish){
                          [ UIView animateWithDuration:0.70f
                                            animations:^{
                                                view.transform = CGAffineTransformMakeScale(1.101f, 1.101f);
                                                //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                            }completion:^(BOOL finish){
                                                [ UIView animateWithDuration:0.1f
                                                                  animations:^{
                                                                      view.transform = CGAffineTransformMakeScale(1, 1);
                                                                      
                                                                  }completion:^(BOOL finish){
                                                                      
                                                                  }];
                                            }];
                      }];
}


- ( void ) onEffectOver:( NSString* )eff
{

}

- ( void ) fightF:( float )f :( NSString* )eff :( BOOL )sound
{
    if ( f > 0 )
    {
        
    }
    else if ( f < 0 )
    {
        
    }
    else
    {
        return;
    }
    
    if ( eff )
    {
        effect.PlaySound = sound;
        [ effect playEffect:eff ];
    }
}


- ( void ) fight:( int )hp :( int )hit :( NSString* )eff :( BOOL )sound
{
    [ self.layer removeAllAnimations ];
    
    if ( numberView )
    {
        [ numberView removeFromSuperview ];
    }
    
    numberView =  [ NSKeyedUnarchiver unarchiveObjectWithData:
                   [ NSKeyedArchiver archivedDataWithRootObject:numberViewOri ] ];
    
    [ numberViewOri.superview addSubview:numberView ] ;
    
    if ( hp > 0 )
    {
        [ numberView initView:@"c" :31 :46 ];
        [ numberView setNumber:hp ];
    }
    else if ( hp < 0 )
    {
        if ( hit == BRHS_HIT1 )
        {
            [ numberView initView:@"bbb" :31 :46 ];
            [ numberView setNumber:hp ];
        }
        else if( hit == BRHS_HIT5 )
        {
            [ numberView initView:@"bb" :31 :46 ];
            [ numberView setNumber:hp ];
        }
        else
        {
            [ numberView initView:@"b" :31 :46 ];
            [ numberView setNumber:hp ];
        }
    }
    else
    {
        [ numberView removeFromSuperview ];
        numberView = NULL;
        return;
    }
    
    if ( eff )
    {
        effect.PlaySound = sound;
        [ effect playEffect:eff ];
    }
    
    
    if ( hp < 0 )
    {
        CALayer* viewLayer = [ self layer ];
        CABasicAnimation* animation=[CABasicAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.08f / GAME_SPEED;
        animation.repeatCount = 3;
        animation.autoreverses=YES;
        animation.fromValue=[ NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, -0.03, 0.0, 0.0, 0.03 ) ];
        animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, 0.03, 0.0, 0.0, 0.03) ];
        [viewLayer addAnimation:animation forKey:@"wiggle" ];
        
//        [ UIView animateWithDuration:0.15f
//                          animations:^{
//                              view.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
//                          }completion:^(BOOL finish){
//                              [ UIView animateWithDuration:0.10f
//                                                animations:^{
//                                                    view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//                                                    //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
//                                                }completion:^(BOOL finish){
//                                                    
//                                                }];
//                          }];
    }
    
    
    [ UIView animateWithDuration:0.2f / GAME_SPEED
                      animations:^{
                          numberView.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                          //nv.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                      }completion:^(BOOL finish){
                          [ UIView animateWithDuration:0.15f / GAME_SPEED
                                            animations:^{
                                                numberView.transform = CGAffineTransformMakeScale(0.99f, 0.99f );
                                                //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                            }completion:^(BOOL finish){
                                                [ UIView animateWithDuration:0.3f / GAME_SPEED
                                                                  animations:^{
                                                                      numberView.transform = CGAffineTransformMakeScale(1, 1);
                                                                      //nv.transform = CGAffineTransformMakeScale(1, 1);
                                                                  }completion:^(BOOL finish){
                                                                      [ numberView clearNumber ];
                                                                      [ numberView removeFromSuperview ];
                                                                      numberView = NULL;
                                                                  }];
                                            }];
                      }];
    
}


- ( void ) update:( float )d
{
    [ effect update:d ];
    [ numberView update:d ];
}

@end
