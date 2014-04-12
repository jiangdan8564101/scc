//
//  TalkUIHandler.m
//  sc
//
//  Created by fox on 13-11-26.
//
//

#import "TalkUIHandler.h"
#import "CreatureConfig.h"
#import "GameSceneManager.h"
#import "PlayerData.h"
#import "PublicUIHandler.h"
#import "InfoQuestUIHandler.h"
#import "PlayerInfoUIHandler.h"
#import "TeamUIHandler.h"
#import "GameAudioManager.h"
#import "ItemConfig.h"
#import "AlertUIHandler.h"
#import "ItemData.h"
#import "QuestData.h"
#import "SceneUIHandler.h"
#import "AlertUIHandler.h"
#import "PlayerEmployData.h"
#import "PlayerCreatureData.h"
#import "GameDataManager.h"

@implementation TalkUIHandler

static TalkUIHandler* gTalkUIHandler;
+ (TalkUIHandler*) instance
{
    if ( !gTalkUIHandler )
    {
        gTalkUIHandler = [ [ TalkUIHandler alloc] init ];
        [ gTalkUIHandler initUIHandler:@"TalkUIView" isAlways:YES isSingle:NO ];
    }
    
    return gTalkUIHandler;
}


- ( void ) onInited
{
    [ super onInited ];
    
    labelName = ( UILabel* )[ view viewWithTag:1000 ];
    labelText = ( UITextView* )[ view viewWithTag:1100 ];
    imageViewRight = ( UIImageView* )[ view viewWithTag:1200 ];
    imageViewMiddle = ( UIImageView* )[ view viewWithTag:1201 ];
    imageViewLeft = ( UIImageView* )[ view viewWithTag:1202 ];
    imageViewName = ( UIImageView* )[ view viewWithTag:1001 ];
    imageViewBG = ( UIImageView* )[ view viewWithTag:1002 ];
    whiteView = (UIView*)[ view viewWithTag:5555 ];
    
    centerPointRight = imageViewRight.center;
    centerPointMiddle = imageViewMiddle.center;
    centerPointLeft = imageViewLeft.center;

    strText = [ [ NSMutableString alloc ] init ];
    
    UIButton* button = ( UIButton* )[ view viewWithTag:1300 ];
    [ button addTarget:self action:@selector(onButton) forControlEvents:UIControlEventTouchUpInside ];
    
    colorMask = view.backgroundColor.retain;
}


- ( void ) onOpened
{
    if ( [ view alpha ] != 1.0f )
    {
        [ super onOpened ];
    }
    
    wait = NO;
    
    [ imageViewRight setImage:NULL ];
    [ imageViewMiddle setImage:NULL ];
    [ imageViewLeft setImage:NULL ];
    
    activeData = NULL;
    activeStep = NULL;
    
    object = NULL;
    sel = NULL;
}


- ( void ) onClosed
{
    [ super onClosed ];
}


- ( UIImageView* ) getImageRight
{
    return imageViewRight;
}
- ( UIImageView* ) getImageMiddle
{
    return imageViewMiddle;
}
- ( UIImageView* ) getImageLeft
{
    return imageViewLeft;
}

- ( void ) clearImage
{
    [ imageViewRight setImage:NULL ];
    [ imageViewMiddle setImage:NULL ];
    [ imageViewLeft setImage:NULL ];
}

- ( void ) updateCreature:( UIImageView* )imageView :( CGPoint )centerPoint :(int) cID :( NSString* )act
{
    CreatureCommonData* commonData = [ [ CreatureConfig instance ] getCommonData:cID ];
    
    NSString* str = [ NSString stringWithFormat:@"CS%@A%@" , commonData.Action , act ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:CREATURE_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
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
    
    
    
    CGPoint point = centerPoint;
    
    if ( commonData.ImageOffsetX )
    {
        point.x += -sz.width * 0.5f + commonData.ImageOffsetX;
    }
    else
    {
        point.x += -sz.width * 0.5f;
    }
    
    if ( commonData.ImageOffsetY )
    {
        point.y += -sz.height + commonData.ImageOffsetY;
    }
    else
    {
        point.y += -sz.height;
    }
    
    rect.origin = point;
    
    

    [ imageView setFrame:rect ];
    
    //[ imageView setCenter:point ];
}


- ( void ) onOver
{
    setpStart = NO;
    strStart = NO;
    
    if ( activeData.NextScene )
    {
        [ [ GameSceneManager instance ] activeScene:activeData.NextScene ];
        [ self visible:YES ];
    }
    
    if ( activeData.NextStory )
    {
        [ [ PlayerData instance ] setStory:activeData.NextStory ];
        [ [ GameDataManager instance ] saveData ];
    }
    
    if ( activeData.NextID != INVALID_ID )
    {
        [ self setData:activeData.NextID ];
    }
    else
    {
        [ self visible:NO ];
        [ object performSelector:sel withObject:nil ];
    }

    if ( activeData.CheckBattle )
    {
        [ [ SceneUIHandler instance ] startBattle ];
    }

}


- ( void ) setSel:( NSObject* )obj :( SEL )s
{
    object = obj;
    sel = s;
}

- ( void ) playAudio
{
    if ( activeStep.Music )
    {
        [ [ GameAudioManager instance ] playMusic:activeStep.Music :0 ];
    }
    
    if ( activeStep.Sound )
    {
        [ [ GameAudioManager instance ] playSound:activeStep.Sound ];
    }
    
    if ( activeStep.StopMusic )
    {
        [ [ GameAudioManager instance ] stopMusic ];
    }
}

- ( void ) setData:( int )d
{
    [ imageViewRight setImage:NULL ];
    [ imageViewMiddle setImage:NULL ];
    [ imageViewLeft setImage:NULL ];
    
    whiteView.alpha = 0.0f;
    whiteView.userInteractionEnabled = NO;
    
    GuideConfigData* data = [ [ GuideConfig instance ] getData:d ];
    
    if ( data.Mask )
    {
        view.backgroundColor = colorMask;
    }
    else
    {
        view.backgroundColor = [ UIColor clearColor ];
    }
    
    setpStart = YES;
    stepPos = 0;
    
    activeData = data;
    activeStep = [ data.Steps objectAtIndex:0 ];
    
    [ self updateCreature ];
    
    if ( data.ActiveScene )
    {
        [ [ GameSceneManager instance ] activeScene:data.ActiveScene ];
        
        [ self visible:YES ];
    }
    
    [ self setString:activeStep.Str ];
    
    
    if ( data.BG )
    {
        [ [ [ GameSceneManager instance ] getActiveScene ] setBG:data.BG ];
        
        if ( data.BGFade )
            [ [ [ GameSceneManager instance ] getActiveScene ] fade:data.BGFade ];
        if ( data.BGFadeLeft )
            [ [ [ GameSceneManager instance ] getActiveScene ] fadeLeft:data.BGFadeLeft ];
        if ( data.BGFadeRight )
            [ [ [ GameSceneManager instance ] getActiveScene ] fadeRight:data.BGFadeRight ];
    }
    
    
}



- ( void ) animationFadeFinished:( NSString* )ani
{
    waitFade = NO;
    
    whiteView.userInteractionEnabled = NO;
    
    [ UIView setAnimationDelegate:NULL ];
    
    [ self nextStep ];
}


- ( void ) white:( float )f
{
    whiteView.userInteractionEnabled = YES;
    
    whiteView.alpha = 0.99f;
    waitFade = YES;
    
    [ UIView beginAnimations:@"white" context:nil ];
    [ UIView setAnimationDuration:f ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDidStopSelector:@selector(animationFadeFinished:) ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    
    
    whiteView.alpha = 1.0f;
    
    [ UIView commitAnimations ];
}


- ( void ) fadeOut:( float )f
{
    whiteView.userInteractionEnabled = YES;
    
    whiteView.alpha = 1.0f;
    waitFade = YES;
    
    imageViewBG.alpha = 0.0f;
    imageViewName.alpha = 0.0f;
    labelText.alpha = 0.0f;
    labelName.alpha = 0.0f;
    
    [ UIView beginAnimations:@"fade in1" context:nil ];
    [ UIView setAnimationDelay:f / 4.0f ];
    [ UIView setAnimationDuration:f / 2.0f ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    imageViewBG.alpha = 1.0f;
    imageViewName.alpha = 1.0f;
    labelText.alpha = 1.0f;
    labelName.alpha = 1.0f;
    [ UIView commitAnimations ];
    
    
    [ UIView beginAnimations:@"fade out" context:nil ];
    [ UIView setAnimationDuration:f ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDidStopSelector:@selector(animationFadeFinished:) ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    
    
    whiteView.alpha = 0.0f;
    
    [ UIView commitAnimations ];
}


- ( void ) fadeIn:( float )f
{
    whiteView.userInteractionEnabled = YES;
    
    whiteView.alpha = 0.0f;
    waitFade = YES;
    
    imageViewName.alpha = 1.0f;
    imageViewBG.alpha = 1.0f;
    labelText.alpha = 1.0f;
    labelName.alpha = 1.0f;
    
    [ UIView beginAnimations:@"fade out1" context:nil ];
    [ UIView setAnimationDelay:f / 4.0f ];
    [ UIView setAnimationDuration:f / 2.0f ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    imageViewBG.alpha = 0.0f;
    imageViewName.alpha = 0.0f;
    labelText.alpha = 0.0f;
    labelName.alpha = 0.0f;
    [ UIView commitAnimations ];
    
    [ UIView beginAnimations:@"fade in" context:nil ];
    [ UIView setAnimationDuration:f ];
    [ UIView setAnimationDelegate:self ];
    [ UIView setAnimationDidStopSelector:@selector(animationFadeFinished:) ];
    [ UIView setAnimationCurve:UIViewAnimationCurveEaseIn ];
    whiteView.alpha = 1.0f;
    [ UIView commitAnimations ];
}


- ( void ) fadeInRight:( float )f
{
    CGRect rect = imageViewRight.frame;
    
    imageViewRight.frame = CGRectMake( rect.origin.x + 100.0f , rect.origin.y , rect.size.width , rect.size.height );
    imageViewRight.alpha = 0.0f;
    
    [ UIView animateWithDuration:f animations:^{
        imageViewRight.frame = rect;
        imageViewRight.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- ( void ) fadeOutRight:( float )f
{
    CGRect rect = imageViewRight.frame;
    
    imageViewRight.frame = rect;
    imageViewRight.alpha = 1.0f;
    
    [ UIView animateWithDuration:f animations:^{
        imageViewRight.frame = CGRectMake( rect.origin.x + 100.0f , rect.origin.y , rect.size.width , rect.size.height );
        imageViewRight.alpha = 0.0f;
    } completion:^(BOOL finished) {
    }];

}

- ( void ) fadeInLeft:( float )f
{
    CGRect rect = imageViewLeft.frame;
    
    imageViewLeft.frame = CGRectMake( rect.origin.x - 100.0f , rect.origin.y , rect.size.width , rect.size.height );
    imageViewLeft.alpha = 0.0f;
    
    [ UIView animateWithDuration:f animations:^{
        imageViewLeft.frame = rect;
        imageViewLeft.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}


- ( void ) fadeOutLeft:( float )f
{
    CGRect rect = imageViewLeft.frame;
    
    imageViewLeft.frame = rect;
    imageViewLeft.alpha = 1.0f;
    
    [ UIView animateWithDuration:f animations:^{
        imageViewLeft.frame = CGRectMake( rect.origin.x - 100.0f , rect.origin.y , rect.size.width , rect.size.height );
        imageViewLeft.alpha = 0.0f;
    } completion:^(BOOL finished) {
    }];
    
}

- ( void ) rotationLeft:( float )f
{
    [ UIView animateWithDuration:f animations:^{
        
        imageViewLeft.transform = CGAffineTransformMakeRotation( 10 );
        
    } completion:^(BOOL finished) {
        imageViewLeft.transform = CGAffineTransformMakeRotation( 0 );
    }];
    
}
- ( void ) rotationRight:( float )f
{
    [ UIView animateWithDuration:f animations:^{
        
        imageViewRight.transform = CGAffineTransformMakeRotation( 10 );
        
    } completion:^(BOOL finished) {
        
        imageViewRight.transform = CGAffineTransformMakeRotation( 0 );
    }];
    
}


- ( void ) fadeInMiddleLeft:( float )f
{
    CGRect rect = imageViewMiddle.frame;
    
    imageViewMiddle.frame = CGRectMake( rect.origin.x - 100.0f , rect.origin.y , rect.size.width , rect.size.height );
    imageViewMiddle.alpha = 0.0f;
    
    [ UIView animateWithDuration:f animations:^{
        imageViewMiddle.frame = rect;
        imageViewMiddle.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- ( void ) fadeInMiddleRight:( float )f
{
    CGRect rect = imageViewMiddle.frame;
    
    imageViewMiddle.frame = CGRectMake( rect.origin.x + 100.0f , rect.origin.y , rect.size.width , rect.size.height );
    imageViewMiddle.alpha = 0.0f;
    
    [ UIView animateWithDuration:f animations:^{
        imageViewMiddle.frame = rect;
        imageViewMiddle.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- ( void ) fadeOutMiddleLeft:( float )f
{
    CGRect rect = imageViewMiddle.frame;
    
    imageViewMiddle.frame = rect;
    imageViewMiddle.alpha = 1.0f;
    
    [ UIView animateWithDuration:f animations:^{
        imageViewMiddle.frame = CGRectMake( rect.origin.x - 100.0f , rect.origin.y , rect.size.width , rect.size.height );
        imageViewMiddle.alpha = 0.0f;
    } completion:^(BOOL finished) {
    }];
    
}

- ( void ) fadeOutMiddleRight:( float )f
{
    CGRect rect = imageViewMiddle.frame;
    
    imageViewMiddle.frame = rect;
    imageViewMiddle.alpha = 1.0f;
    
    [ UIView animateWithDuration:f animations:^{
        imageViewMiddle.frame = CGRectMake( rect.origin.x + 100.0f , rect.origin.y , rect.size.width , rect.size.height );
        imageViewMiddle.alpha = 0.0f;
    } completion:^(BOOL finished) {
    }];
    
}

- ( void ) leftRight:( float )f
{
    [ UIView animateWithDuration:0.05f animations:^{
        view.center = CGPointMake( view.center.x - 25.0f , view.center.y  );
    } completion:^(BOOL finished) {
        [ UIView animateWithDuration:0.05f animations:^{
            view.center = CGPointMake( view.center.x + 25.0f , view.center.y  );
        } completion:^(BOOL finished) {
            [ UIView animateWithDuration:0.07f animations:^{
                view.center = CGPointMake( view.center.x - 20.0f , view.center.y  );
            } completion:^(BOOL finished) {
                [ UIView animateWithDuration:0.08f animations:^{
                    view.center = CGPointMake( view.center.x + 20.0f , view.center.y  );
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

- ( void ) upDown:( float )f
{
    [ UIView animateWithDuration:0.05f animations:^{
        view.center = CGPointMake( view.center.x, view.center.y + 25.0f );
    } completion:^(BOOL finished) {
        [ UIView animateWithDuration:0.05f animations:^{
            view.center = CGPointMake( view.center.x, view.center.y - 25.0f );
        } completion:^(BOOL finished) {
            [ UIView animateWithDuration:0.07f animations:^{
                view.center = CGPointMake( view.center.x, view.center.y + 20.0f );
            } completion:^(BOOL finished) {
                [ UIView animateWithDuration:0.08f animations:^{
                    view.center = CGPointMake( view.center.x, view.center.y - 20.0f );
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];

}


- ( void ) setString:( NSString* )str
{
    [ self playAudio ];
    
    [ labelText setText:@"" ];
    
    if ( activeStep.Day )
    {
        [ [ PlayerData instance ] goDate:activeStep.Day ];
    }
    
    if ( activeStep.FadeIn )
    {
        [ self fadeIn:activeStep.FadeIn ];
        wait = YES;
        return;
    }
    
    if ( activeStep.FadeOut )
    {
        [ self fadeOut:activeStep.FadeOut ];
        wait = YES;
        return;
    }
    
    if ( activeStep.White )
    {
        [ self white:activeStep.White ];
        wait = YES;
        return;
    }
    
    strDelay = 0;
    strPos = 0;
    strCount = str.length;
    strStart = YES;
    wait = NO;
    wait1 = NO;
    uiDelay = 0.2f;
    
    [ strText setString:str ];
    
    if ( activeStep.UI )
    {
        if ( [ activeStep.UI isEqualToString:@"public" ] )
        {
            [ [ PublicUIHandler instance ] visible:YES ];
            [ [ InfoQuestUIHandler instance ] visible:NO ];
            [ [ PlayerInfoUIHandler instance ] visible:NO ];
            [ [ TeamUIHandler instance ] visible:NO ];
            [ self visible:YES ];
        }
        if ( [ activeStep.UI isEqualToString:@"team" ] )
        {
            [ [ TeamUIHandler instance ] visible:YES ];
            [ [ PlayerInfoUIHandler instance ] visible:NO ];
            [ [ InfoQuestUIHandler instance ] visible:NO ];
            [ self visible:YES ];
        }
        if ( [ activeStep.UI isEqualToString:@"quest" ] )
        {
            [ [ QuestData instance ] checkQuest ];
            
            [ [ InfoQuestUIHandler instance ] visible:YES ];
            [ [ PlayerInfoUIHandler instance ] visible:NO ];
            [ [ TeamUIHandler instance ] visible:NO ];
            [ self visible:YES ];
        }
        if ( [ activeStep.UI isEqualToString:@"employ" ] )
        {
            [ [ InfoQuestUIHandler instance ] visible:NO ];
            [ [ PlayerInfoUIHandler instance ] visible:YES ];
            [ [ PlayerInfoUIHandler instance ] setMode:PlayerInfoUIEmploy ];
            [ [ TeamUIHandler instance ] visible:NO ];
            [ self visible:YES ];
        }
    }
    
}


- ( void ) waitNextStep
{
    wait = YES;
}


- ( void ) nextStep
{
    stepPos++;
    
    
    if ( activeStep.ItemID )
    {
        ItemConfigData* item = [[ ItemConfig instance ] getData:activeStep.ItemID ];
        NSString* str = [ NSString localizedStringWithFormat:NSLocalizedString( @"GetItem" , nil ) , item.Name ];
        [ [ AlertUIHandler instance ] alert:str ];
        [ [ ItemData instance ] addItem:activeStep.ItemID :1 ];
        [ [ GameAudioManager instance ] playSound:@"D0724" ];
    }

    if ( activeStep.Alert )
    {
        [ [ AlertUIHandler instance ] alert:activeStep.Alert ];
    }
    
    if ( activeData.Steps.count == stepPos )
    {
        [ self onOver ];
        return;
    }
    
    activeStep = [ activeData.Steps objectAtIndex:stepPos ];
    
    [ self updateCreature ];
    
    [ self setString:activeStep.Str ];
}


- ( void ) updateCreature
{
    if ( activeStep.Font > 0 )
    {
        if ( gActualResource.type >= RESPAD2 )
        {
            UIFont* font = [ labelText font ];
            [ labelText setFont:[ font fontWithSize:activeStep.Font ] ];
        }
        else
        {
            UIFont* font = [ labelText font ];
            [ labelText setFont:[ font fontWithSize:activeStep.Font - 5 ] ];
        }
    }
    
    if ( activeStep.CreatureRight > 0 )
    {
        [ self updateCreature:imageViewRight :centerPointRight  :activeStep.CreatureRight :activeStep.ActionRight ];
        
        imageViewRight.alpha = 1.0f;
        
        if ( activeStep.FadeInRight )
            [ self fadeInRight:activeStep.FadeInRight ];
        if ( activeStep.FadeOutRight )
            [ self fadeOutRight:activeStep.FadeOutRight ];
        if ( activeStep.RotationRight )
            [ self rotationRight:activeStep.RotationRight ];
    }
    if ( activeStep.CreatureMiddle > 0 )
    {
        [ self updateCreature:imageViewMiddle :centerPointMiddle :activeStep.CreatureMiddle :activeStep.ActionMiddle ];
        
        imageViewMiddle.alpha = 1.0f;
        
        if ( activeStep.FadeInMiddleLeft )
            [ self fadeInMiddleLeft:activeStep.FadeInMiddleLeft ];
        if ( activeStep.FadeInMiddleRight )
            [ self fadeInMiddleRight:activeStep.FadeInMiddleRight ];
        
        if ( activeStep.FadeOutMiddleLeft )
            [ self fadeOutMiddleLeft:activeStep.FadeOutMiddleLeft ];
        if ( activeStep.FadeOutMiddleRight )
            [ self fadeOutMiddleRight:activeStep.FadeOutMiddleRight ];
    }
    if ( activeStep.CreatureLeft > 0 )
    {
        [ self updateCreature:imageViewLeft :centerPointLeft :activeStep.CreatureLeft :activeStep.ActionLeft  ];
        
        imageViewLeft.alpha = 1.0f;
        
        if ( activeStep.FadeInLeft )
            [ self fadeInLeft:activeStep.FadeInLeft ];
        if ( activeStep.FadeOutLeft )
            [ self fadeOutLeft:activeStep.FadeOutLeft ];
        if ( activeStep.RotationLeft )
            [ self rotationLeft:activeStep.RotationLeft ];
    }
    
    if ( activeStep.UpDown )
    {
        [ self upDown:activeStep.UpDown ];
    }
    if ( activeStep.LeftRight )
    {
        [ self leftRight:activeStep.LeftRight ];
    }
    
    if ( activeStep.Employ )
    {
        [ [ PlayerEmployData instance ] employCreature:activeStep.Employ ];
    }
    
    if ( [ activeStep.Name length ] )
    {
        [ labelName setText:activeStep.Name ];
        [ imageViewName setHidden:NO ];
    }
    else if ( activeStep.NameID )
    {
         CreatureCommonData* commonData = [ [ CreatureConfig instance ] getCommonData:activeStep.NameID ];
        [ labelName setText:commonData.Name ];
        [ imageViewName setHidden:NO ];
    }
    else
    {
        [ labelName setText:@"" ];
        [ imageViewName setHidden:YES ];
    }
}

- ( void ) onButton
{
    if ( uiDelay == 0.0f )
    {
        while ( strStart )
        {
            [ self update:0.03f ];
        }
    }
    uiDelay = 0.0f;
    
    if ( [ [ AlertUIHandler instance ] isOpened ] )
    {
        return;
    }
    
    if ( waitFade )
    {
        return;
    }
    
    if ( wait )
    {
        wait = NO;
        wait1 = YES;
        return;
    }
    
    if ( wait1 )
    {
        wait1 = NO;
        wait = NO;
        [ self nextStep ];
    }
}


- ( void ) update:( float )delay
{
    if ( !setpStart )
    {
        return;
    }
    
    if ( wait )
    {
        return;
    }
    
    if ( strStart )
    {
        strDelay += delay;
        
        if ( strDelay >= uiDelay )
        {
            strDelay = 0.0f;
            wait = NO;
            strPos++;
            
            NSRange range;
            range.location = 0;
            range.length = strPos;
            
            NSString* str = [ strText substringWithRange:range ];
            [ labelText setText:str ];
            
            if ( strPos == strCount )
            {
                strStart = NO;
                [ self waitNextStep ];
            }
        }
    }
}

@end











