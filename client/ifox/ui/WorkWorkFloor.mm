//
//  WorkWorkFloor.m
//  sc
//
//  Created by fox on 13-1-17.
//
//

#import "WorkWorkFloor.h"
#import "ItemData.h"
#import "UIEffectAction.h"
#import "GameAudioManager.h"

@implementation WorkWorkFloor
@synthesize ItemID , Type;

- ( UIView* )hitTest:( CGPoint )point withEvent:( UIEvent* )event
{
    if ( !CGRectContainsPoint( [ self bounds ], point ) )
        return nil;
    else
    {
        if ( self.hidden )
        {
            return nil;
        }
        
        UIImage* image = [ self backgroundImageForState:UIControlStateNormal ];
        CFDataRef bitmapData = CGDataProviderCopyData( CGImageGetDataProvider( image.CGImage ) );
        int* pc = (int*)CFDataGetBytePtr( bitmapData );
        pc += (int)(point.y * image.size.width) + (int)point.x;
        int n = *pc;
        
        CFRelease( bitmapData );
        
        if ( n < 0 )
        {
            return self;
        }
        else
        {
            return nil;
        }
    }
}


- ( void ) setCreatureAction:( NSString* )a
{
    [ self clearCreatureAction ];
    
    creatureAction = [ [ UICreatureAction alloc ] init ];
    [ creatureAction initCreatureActionView:a ];
    [ creatureAction setPos:ccp( self.frame.size.width / 2 , self.frame.size.height / 2 + 10 ) ];
    [ creatureAction setAction:CAT_STAND :0 ];
    [ self addSubview:creatureAction ];
    [ creatureAction release ];
}


- ( void ) setItem:( int )item
{
    ItemConfigData* ic = [ [ ItemConfig instance ] getData:item ];
    
    NSString* str = [ NSString stringWithFormat:@"%@" , ic.Img ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:ICON_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    //UIButton* button = (UIButton*)[ self viewWithTag:200 ];
    [ self setImage:image forState:UIControlStateNormal ];
    
    ItemID = item;
    [ [ ItemData instance ] removeItem:ItemID :1 ];
    
    [ effect removeFromSuperview ];
    [ effect release ];
    effect = NULL;
    effect = [ [ UIEffectAction alloc ] init ];
    effect.frame = CGRectMake( self.frame.size.width / 2 , self.frame.size.height / 2 , 1, 1 );
    [ effect initUIEffect:self :@selector( onActionOver: ) ];
    [ effect playEffect:@"MVS903" ];
    [ self addSubview:effect ];
    
    
}

- ( void ) onActionOver:( NSString* )str
{
    [ effect removeFromSuperview ];
    [ effect release ];
    effect = NULL;
    
    
}

- ( void ) clearItem
{
    [ self setImage:NULL forState:UIControlStateNormal ];
    
    [ effect releaseUIEffect ];
    [ effect release ];
    effect = NULL;
}


- ( void ) removeItem
{
    if ( ItemID && ItemID != INVALID_ID )
    {
        ItemID = INVALID_ID;
        [ [ ItemData instance ] addItem:ItemID :1 ];
    }
    
    [ self setImage:NULL forState:UIControlStateNormal ];
}


- ( void ) clearCreatureAction
{
    [ creatureAction removeFromSuperview ];
    creatureAction = NULL;
}

- ( void ) update:( float )d
{
    [ effect update:d ];
}

@end
