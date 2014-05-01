//
//  WorkOutlayUIHandler.m
//  sc
//
//  Created by fox on 13-12-4.
//
//

#import "WorkOutlayUIHandler.h"
#import "PlayerData.h"
#import "PlayerCreatureData.h"
#import "UILabelNumber.h"
#import "WorkUpConfig.h"
#import "GameSceneManager.h"
#import "LevelUpPriceConfig.h"

@implementation WorkOutlayUIHandler


static WorkOutlayUIHandler* gWorkOutlayUIHandler;
+ ( WorkOutlayUIHandler* ) instance
{
    if ( !gWorkOutlayUIHandler )
    {
        gWorkOutlayUIHandler = [ [ WorkOutlayUIHandler alloc] init ];
        [ gWorkOutlayUIHandler initUIHandler:@"WorkOutlayView" isAlways:YES isSingle:NO ];
    }
    
    return gWorkOutlayUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    UIButton* button = (UIButton*)[ view viewWithTag:200 ];
    [ button addTarget:self action:@selector(onCloseClick) forControlEvents:UIControlEventTouchUpInside ];
}


- ( void ) onOpened
{
    [ super onOpened ];
    
    [ self hiddenPay:YES ];
}


- ( void ) onClosed
{
    [ super onClosed ];
    
    }

- (void) animationCloseFinished:( NSString* )animationID finished:( BOOL )finished context:( BOOL )context
{
    [ super animationCloseFinished:animationID finished:finished context:context ];
    
    UILabelNumber* label = ( UILabelNumber* )[ view viewWithTag:2001 ];
    [ label SetNumber:0 ];
    
    label = ( UILabelNumber* )[ view viewWithTag:1000 ];
    [ label SetNumber:0 ];
    
    label = ( UILabelNumber* )[ view viewWithTag:1001 ];
    [ label SetNumber:0 ];
    label = ( UILabelNumber* )[ view viewWithTag:1002 ];
    [ label SetNumber:0 ];
    label = ( UILabelNumber* )[ view viewWithTag:1003 ];
    [ label SetNumber:0 ];
    label = ( UILabelNumber* )[ view viewWithTag:1004 ];
    [ label SetNumber:0 ];
    
    label = ( UILabelNumber* )[ view viewWithTag:1010 ];
    [ label SetNumber:0 ];
    label = ( UILabelNumber* )[ view viewWithTag:1011 ];
    [ label SetNumber:0 ];
    label = ( UILabelNumber* )[ view viewWithTag:1012 ];
    [ label SetNumber:0 ];
    label = ( UILabelNumber* )[ view viewWithTag:1013 ];
    [ label SetNumber:0 ];
    label = ( UILabelNumber* )[ view viewWithTag:1014 ];
    [ label SetNumber:0 ];
    
    label = ( UILabelNumber* )[ view viewWithTag:2000 ];
    [ label SetNumber:0 ];
    
    label = ( UILabelNumber* )[ view viewWithTag:3001 ];
    [ label SetNumber:0 ];

}


- ( void ) hiddenPay:( BOOL )b
{
    UIView* view1 = [ view viewWithTag:3000 ];
    [ view1 setHidden:b ];
    view1 = [ view viewWithTag:3001 ];
    [ view1 setHidden:b ];
    view1 = [ view viewWithTag:3003 ];
    [ view1 setHidden:b ];
}



- ( void ) onCloseClick
{
    if ( isShowPay )
    {
        return;
    }
    
    [ self visible:NO ];
    
    if ( [ [ GameSceneManager instance ] checkScene:GS_ASSOCIATION ] )
    {
        [ [ GameSceneManager instance ] activeScene:GS_CITY ];
    }
    
    playSound( PST_OK );
}


- ( void ) animationJumpFinished
{
    [ UIView setAnimationDelegate:nil ];
    
    UIImageView* imageView = ( UIImageView* )[ view viewWithTag:3002 ];
    [ imageView setTransform:CGAffineTransformMakeScale( 1.0f , 1.0f ) ];
    
    [ UIView beginAnimations:@"zoom in2" context:nil ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDidStopSelector:@selector(animationJumpFinished1) ];
    [ UIView setAnimationDuration:0.1f ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    
    [ imageView setTransform:CGAffineTransformMakeScale( 0.98f , 0.98f ) ];
    
    [ UIView commitAnimations ];
}

- ( void ) animationJumpFinished1
{
    [ UIView setAnimationDelegate:nil ];
    
    UIImageView* imageView = ( UIImageView* )[ view viewWithTag:3002 ];
    [ imageView setTransform:CGAffineTransformMakeScale( 0.98f , 0.98f ) ];
    
    [ UIView beginAnimations:@"zoom in3" context:nil ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDidStopSelector:@selector(animationJumpFinished2) ];
    [ UIView setAnimationDuration:0.1f ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    
    [ imageView setTransform:CGAffineTransformMakeScale( 1.0f , 1.0f ) ];
    
    [ UIView commitAnimations ];
}

- ( void ) animationJumpFinished2
{
    [ UIView setAnimationDelegate:nil ];
    
    isShowPay = NO;
}

- ( void ) onJumpOver
{
    if ( isShowPay )
    {
        UILabelNumber* label = (UILabelNumber*)[ view viewWithTag:3001 ];
        [ label JumpNumber:[ PlayerData instance ].getGold :1.0f :self :@selector( onJumpOver1 ) ];
    }
}

- ( void ) onJumpOver1
{
    UIImageView* imageView = ( UIImageView* )[ view viewWithTag:3003 ];
    [ imageView setTransform:CGAffineTransformMakeScale( 3.0f , 3.0f ) ];
    [ imageView setAlpha:0.1f ];
    
    [ UIView beginAnimations:@"zoom in1" context:nil ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDidStopSelector:@selector(animationJumpFinished) ];
    [ UIView setAnimationDuration:0.3f ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    
    
    [ imageView setTransform:CGAffineTransformMakeScale( 1.0f , 1.0f ) ];
    [ imageView setAlpha:1.0f ];
    
    [ UIView commitAnimations ];
    
}


- ( void ) update:(float)delay
{
    UILabelNumber* label = ( UILabelNumber* )[ view viewWithTag:2001 ];
    [ label update:delay ];
    
    label = ( UILabelNumber* )[ view viewWithTag:1000 ];
    [ label update:delay ];
    label = ( UILabelNumber* )[ view viewWithTag:1001 ];
    [ label update:delay ];
    label = ( UILabelNumber* )[ view viewWithTag:1002 ];
    [ label update:delay ];
    label = ( UILabelNumber* )[ view viewWithTag:1003 ];
    [ label update:delay ];
    label = ( UILabelNumber* )[ view viewWithTag:1004 ];
    [ label update:delay ];
    
    label = ( UILabelNumber* )[ view viewWithTag:1010 ];
    [ label update:delay ];
    label = ( UILabelNumber* )[ view viewWithTag:1011 ];
    [ label update:delay ];
    label = ( UILabelNumber* )[ view viewWithTag:1012 ];
    [ label update:delay ];
    label = ( UILabelNumber* )[ view viewWithTag:1013 ];
    [ label update:delay ];
    label = ( UILabelNumber* )[ view viewWithTag:1014 ];
    [ label update:delay ];
    
    label = ( UILabelNumber* )[ view viewWithTag:2000 ];
    [ label update:delay ];
    
    label = ( UILabelNumber* )[ view viewWithTag:3001 ];
    [ label update:delay ];
}


- ( void ) updateData:( int )day
{
    UILabelNumber* label = ( UILabelNumber* )[ view viewWithTag:2001 ];
    [ label JumpNumber:day :1.0f :NULL :NULL  ];
    
    int goldCount = 0;
    int goldEmploy = 0;
    
    WorkUpConfigData* data = [ [ WorkUpConfig instance ] getWorkUp:[ PlayerData instance ].WorkRank ];
    
    NSMutableDictionary* dic = [ PlayerCreatureData instance ].PlayerDic;
    
    goldCount -= data.Gold;
    goldCount -= data.DayGold * dic.allValues.count * day;
    
    label = ( UILabelNumber* )[ view viewWithTag:1000 ];
    [ label setText:@"" ];
    label = ( UILabelNumber* )[ view viewWithTag:1001 ];
    [ label setText:@"" ];
    label = ( UILabelNumber* )[ view viewWithTag:1002 ];
    [ label JumpNumber:-data.DayGold * dic.allValues.count :1.0f :NULL :NULL ];
    label = ( UILabelNumber* )[ view viewWithTag:1003 ];
    [ label setText:@""];
    label = ( UILabelNumber* )[ view viewWithTag:1004 ];
    [ label setText:@"" ];
    
    label = ( UILabelNumber* )[ view viewWithTag:1010 ];
    [ label JumpNumber:-data.Gold :1.0f :NULL :NULL ];
    label = ( UILabelNumber* )[ view viewWithTag:1011 ];
    [ label JumpNumber:0 :1.0f :NULL :NULL ];
    label = ( UILabelNumber* )[ view viewWithTag:1012 ];
    [ label JumpNumber:-data.DayGold * dic.allValues.count * day :1.0f :NULL :NULL ];
    label = ( UILabelNumber* )[ view viewWithTag:1013 ];
    [ label JumpNumber:[ PlayerData instance ].SellGold :1.0f :NULL :NULL ];
    label = ( UILabelNumber* )[ view viewWithTag:1014 ];
    
    
    for ( int i = 0 ; i < dic.allValues.count ; ++i )
    {
        CreatureCommonData* comm = [ dic.allValues objectAtIndex:i ];
        
        goldEmploy -= [ comm getEmployPrice ];
    }
    
    goldCount += [ PlayerData instance ].SellGold;
    goldCount += goldEmploy;
    
    
    [ label JumpNumber:goldEmploy :1.0f :NULL :NULL ];
    
    label = ( UILabelNumber* )[ view viewWithTag:2000 ];
    [ label JumpNumber:goldCount :1.0f :self :@selector(onJumpOver) ];
    
    //label = ( UILabelNumber* )[ view viewWithTag:3001 ];
    //[ label JumpNumber:0 :1.0f :NULL :NULL ];
    
}


- ( void ) showPay
{
    isShowPay = YES;

    [ self hiddenPay:NO ];
    
    UILabelNumber* label = (UILabelNumber*)[ view viewWithTag:3001 ];
    [ label SetNumber:0 ];
    
    UIImageView* imageView = ( UIImageView* )[ view viewWithTag:3003 ];
    [ imageView setTransform:CGAffineTransformMakeScale( 3.0f , 3.0f ) ];
    [ imageView setAlpha:0.0f ];
}



@end
