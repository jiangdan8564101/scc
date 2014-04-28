//
//  UICreatureAction.m
//  sc
//
//  Created by fox on 13-1-17.
//
//

#import "UICreatureAction.h"
#import "GameUIManager.h"
#import "ClientDefine.h"
#import "UIEffectAction.h"
#import "EffectConfig.h"
#import "GameAudioManager.h"

@implementation UIEffectAction
@synthesize PlaySound;




- ( void ) setIndex:( int )i
{
	if ( i >= 0 && i < [ imageNames count] )
	{
		index = i;
		
		[ self setImageAtIndex:index ];
	}
}

- ( void ) setImageAtIndex:( int )i
{
	NSString* name = [ imageNames objectAtIndex:i ];
	
	UIImage* img = [ UIImage imageWithContentsOfFile:name ];
	
	[ self setImage:img ];
}

- ( void ) update:( float )d
{
    if ( started )
    {
        time += d;
        
        if ( time > duration )
        {
            time -= duration;
            
            [ self updateFrame ];
        }
    }
}

- ( void ) updateFrame
{
	index++;
    
	if ( index < imageNames.count )
	{
		[ self setImageAtIndex:index ];
    }
	else
	{
        [ self clearAnimating ];
	}
    
}

- ( void ) initUIEffect:( NSObject* )obj :( SEL )s
{
    if ( inited )
    {
        return;
    }
    
    object = obj;
    sel = s;
    
    inited = YES;
    position = self.center;
    PlaySound = YES;
    
    duration = 0.0f;
    index = 0;
    
    started = NO;
    
    imageNames = [ [ NSMutableArray alloc ] init ];
}


- (void) clearAnimating
{
    [ imageNames removeAllObjects ];
    index = 0;
    duration = 0.0f;
    started = NO;
    time = 0.0f;
    [ self setImage:NULL ];
}


- ( void ) releaseUIEffect
{
    if ( !inited )
    {
        return;
    }
    
    [ self clearAnimating ];
    
    inited = NO;
    
    [ actionID release ];
    actionID = NULL;
    
    [ imageNames release ];
    imageNames = NULL;
}


- ( void ) removeFromSuperview
{
    [ self releaseUIEffect ];
    [ super removeFromSuperview ];
}


- ( void ) playEffect:( NSString* )i
{
    if ( !inited )
    {
        return;
    }
    
    [ self clearAnimating ];
    
    [ actionID release ];
    actionID = [ [ NSString alloc ] initWithString:i ];
    
    for ( int i = 0 ; i < 100 ; ++i )
    {
        NSString* path = [ [ NSBundle mainBundle ] pathForResource:[ NSString stringWithFormat:@"%d" , i ] ofType:@"png" inDirectory:[ NSString stringWithFormat:@"%@/%@" , EFFECT_PATH , actionID ]];
        
        if ( !path )
        {
            break;
        }
        
        [ imageNames addObject:path ];
    }
    
    if ( !PlaySound )
    {
        [ object performSelector:sel withObject:actionID afterDelay:( imageNames.count - 2 )* duration ];
        
        return;
    }
    
    int w = 0;
    int h = 0;
    
    UIImage* img = [ UIImage imageWithContentsOfFile:[ imageNames objectAtIndex:0 ] ];
    
    [ self setImage:img ];
    
    w = CGImageGetWidth( img.CGImage );
    h = CGImageGetHeight( img.CGImage );
    index = 0;
    time = 0;
    
    int fc = imageNames.count;
    duration = 0.034f;
    
    [ self setAnimationDuration:duration * fc / GAME_SPEED ];
    
    
    [ object performSelector:sel withObject:actionID afterDelay:( imageNames.count - 2 )* duration ];
    
    EffectConfigData* data = [ [ EffectConfig instance ] getData:actionID ];
    
    int px = data.PosX;
    int py = data.PosY;
    
    CGRect rect = self.frame;
    rect.origin.x = -w * 0.5f + position.x + px;
    rect.origin.y = -h * 0.5f + position.y + py;
    rect.size.width = w;
    rect.size.height = h;
    [ self setFrame:rect ];
    
    started = YES;
    
    [ [ GameAudioManager instance ] playSound:actionID ];
}



@end
