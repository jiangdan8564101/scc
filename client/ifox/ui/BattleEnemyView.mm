//
//  BattleEnemyView.m
//  sc
//
//  Created by fox on 13-9-3.
//
//

#import "BattleEnemyView.h"

@implementation BattleEnemyView



- ( void ) setData:( CreatureCommonData* )c :( BOOL )b :( BOOL )s
{
    sp = s;
    comm = c;
    boss = b;
    
    NSString* str = [ NSString stringWithFormat:@"CB%@AA" , c.BattleAction && c.BattleAction.length ?  c.BattleAction : c.Action ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:CREATURE_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    //[ imageView setImage:image ];
    
    CGSize sz = image.size;
    [ imageView setImage:image ];
    CGRect rect = imageView.frame;
    
    if ( gActualResource.type >= RESPAD2 )
    {
        
    }
    else
    {
        sz.width *= 0.5f;
        sz.height *= 0.5f;
    }
    
    rect.size = sz;
    rect.size.width *= b ? 1.5f : 0.75f;
    rect.size.height *= b ? 1.5f : 0.75f;
    
    if ( !b && rect.size.width > self.frame.size.width * 1.7f )
    {
        float f = rect.size.width / ( self.frame.size.width * 1.7f );
        
        rect.size.width = ( self.frame.size.width * 1.7f );
        rect.size.height /= f;
    }
    
    if ( b && rect.size.width > self.frame.size.width * 3.0f )
    {
        float f = rect.size.width / ( self.frame.size.width * 3.0f );
        
        rect.size.width = ( self.frame.size.width * 3.0f );
        rect.size.height /= f;
    }
    
    CGPoint point = centerPoint;
    point.x += -rect.size.width * 0.5f;
    point.y += -rect.size.height * 0.6f;
    
    rect.origin = point;
    
    [ imageView setFrame:rect ];

    rectBossHP.origin.y = rect.origin.y + rect.size.height + rectBossHP.size.height * 0.5f;

    imageViewHP.frame = b ? rectBossHP : rectHP;
    imageViewHPBG.frame = b ? rectBossHPBG : rectHPBG;
    
    imageViewHP.hidden = b;
    imageViewHPBG.hidden = b;
    
    
    hpWidth = b ? rectBossHP.size.width : rectHP.size.width;
    [ self updateHpImageView ];
    
    [ self updateImageGrow ];
}


- ( void ) updateImageGrow
{
//    CALayer* layer = [ imageView layer ];
//    layer.borderColor = [ [ UIColor whiteColor ] CGColor ];
//    layer.borderWidth = 5.0f;

    if ( sp )
    {
        UIColor* color = [ UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha: timeSP ];
        
        imageView.layer.shadowColor = color.CGColor;
        imageView.layer.shadowOffset = CGSizeMake( 1 , 1 );
        imageView.layer.shadowOpacity = 1.0f;
        imageView.layer.shadowRadius = 10.0f;
        
//        imageView.layer.shadowColor = [ UIColor redColor ].CGColor;
//        imageView.layer.shadowOffset = CGSizeMake( 3 , 3 );
//        imageView.layer.shadowOpacity = 0.75f;
//        imageView.layer.shadowRadius = 2.0f;
    }
    else
    {
        imageView.layer.shadowColor = nil;
        imageView.layer.shadowRadius = 0.0f;
    }
}

- ( void ) updateHpImageView
{
    CGRect f = imageViewHP.frame;
    f.size.width = hpWidth * ( comm.RealBaseData.HP / comm.RealBaseData.MaxHP );
    
    if ( f.size.width < 0.05f )
    {
        f.size.width = 0.0f;
    }
    
    if ( f.size.width > hpWidth )
    {
        f.size.width = hpWidth;
    }
    
    [ imageViewHP setFrame:f ];
}

- ( void ) initBattleEnemyView
{
    numberViewOri = ( BattleNumberView* )[ self viewWithTag:200 ];
    imageView = ( UIImageView* )[ self viewWithTag:100 ];
    
    centerPoint = imageView.center;
    
    imageViewHP = (UIImageView*)[ self viewWithTag:301 ];
    imageViewHPBG = (UIImageView*)[ self viewWithTag:300 ];
    
    centerPointHP = imageViewHP.center;
    rectHP = imageViewHP.frame;
    rectBossHP = CGRectMake( rectHP.origin.x - rectHP.size.width * 0.5f , rectHP.origin.y , rectHP.size.width * 2.0f , rectHP.size.height );
    rectHPBG = imageViewHPBG.frame;
    //rectBossHPBG = CGRectMake( rectHPBG.origin.x - rectHPBG.size.width * 0.5f , rectHPBG.origin.y , rectHPBG.size.width * 2.0f , rectHPBG.size.height );
    
    hpWidth = imageViewHP.frame.size.width;
    
    effect = ( UIEffectAction* )[ self viewWithTag:400 ];
    [ effect initUIEffect:self :@selector( onEffectOver: ) ];
    
}


- ( void ) releaseBattleEnemyView
{
    
}


- ( void ) startFight
{
    [ UIView animateWithDuration:0.05f
                      animations:^{
                          self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                      }completion:^(BOOL finish){
                          [ UIView animateWithDuration:0.70f
                                            animations:^{
                                                self.transform = CGAffineTransformMakeScale(1.101f, 1.101f);
                                                //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                            }completion:^(BOOL finish){
                                                [ UIView animateWithDuration:0.1f
                                                                  animations:^{
                                                                      self.transform = CGAffineTransformMakeScale(1, 1);
                                                                      
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
    
//    ProfessionConfigData* pro = [ [ ProfessionConfig instance ] getProfessionConfig:com.ProfessionID ];
//    [ effect playEffect:pro.Effect ];

    if ( eff )
    {
        effect.PlaySound = sound;
        [ effect playEffect:eff ];
    }
    
    [ self updateHpImageView ];
    
    if ( hp < 0 )
    {
        CALayer* viewLayer = [ imageView.superview layer ];
        CABasicAnimation* animation=[CABasicAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.08f / GAME_SPEED;
        animation.repeatCount = 3;
        animation.autoreverses=YES;
        animation.fromValue=[ NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, -0.03, 0.0, 0.0, 0.03 ) ];
        animation.toValue=[NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, 0.03, 0.0, 0.0, 0.03) ];
        [viewLayer addAnimation:animation forKey:@"wiggle" ];
        
        [ UIView animateWithDuration:0.1f / GAME_SPEED
                          animations:^{
                                imageView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                          }completion:^(BOOL finish){
                              [ UIView animateWithDuration:0.15f / GAME_SPEED
                                                animations:^{
                                                        imageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                                   
                                                    //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                                }completion:^(BOOL finish){
                                                    
                                                }];
                          }];

        
//        [ UIView animateWithDuration:0.15f
//                          animations:^{
//                              imageView.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
//                          }completion:^(BOOL finish){
//                              [ UIView animateWithDuration:0.10f
//                                                animations:^{
//                                                    imageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//                                                    //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
//                                                }completion:^(BOOL finish){
//                                                    
//                                                }];
//                          }];
    }
    
    
    if ( hit == BRHS_HIT1 )
    {
        numberView.transform = CGAffineTransformMakeScale(2.3f, 2.3f);
    }
    else if ( hit == BRHS_HIT5 )
    {
        numberView.transform = CGAffineTransformMakeScale(6.3f, 6.3f);
    }
    else
    {
        numberView.transform = CGAffineTransformMakeScale(4.3f, 4.3f);
    }
    
    
    [ UIView animateWithDuration:0.2f / GAME_SPEED
                      animations:^{
                          if ( hit == BRHS_HIT1 )
                          {
                              numberView.transform = CGAffineTransformMakeScale(2.3f, 2.3f);
                          }
                          else if ( hit == BRHS_HIT5 )
                          {
                              numberView.transform = CGAffineTransformMakeScale(6.3f, 6.3f);
                          }
                          else
                          {
                              numberView.transform = CGAffineTransformMakeScale(4.3f, 4.3f);
                          }
                          
                          //nv.transform = CGAffineTransformMakeScale(1.3f, 1.3f);
                      }completion:^(BOOL finish){
                          [ UIView animateWithDuration:0.15f / GAME_SPEED
                                            animations:^{
                                                if ( hit == BRHS_HIT1 )
                                                {
                                                    numberView.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                                }
                                                else if ( hit == BRHS_HIT5 )
                                                {
                                                    numberView.transform = CGAffineTransformMakeScale(1.69f, 1.69f);
                                                }
                                                else
                                                {
                                                    numberView.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                                }
                                                //nv.transform = CGAffineTransformMakeScale(0.99f, 0.99f);
                                            }completion:^(BOOL finish){
                                                [ UIView animateWithDuration:0.3f / GAME_SPEED
                                                                  animations:^{
                                                                      if ( hit == BRHS_HIT1 )
                                                                      {
                                                                          numberView.transform = CGAffineTransformMakeScale(1, 1);
                                                                      }
                                                                      else if ( hit == BRHS_HIT5 )
                                                                      {
                                                                          numberView.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
                                                                      }
                                                                      else
                                                                      {
                                                                          numberView.transform = CGAffineTransformMakeScale(1, 1);
                                                                      }
                                                                      
                                                                      
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
    
    if ( sp )
    {
        if ( addSP )
        {
            timeSP += d;
        }
        else
        {
            timeSP -= d;
        }
        
        [ self updateImageGrow ];
        
        if ( timeSP >= 1.0f )
        {
            addSP = NO;
        }
        
        if ( timeSP <= 0.0f )
        {
            addSP = YES;
        }
    }
}


@end
