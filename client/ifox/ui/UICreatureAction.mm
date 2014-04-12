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

@implementation UICreatureAction



- ( UIImage* ) getSubImage:( CGRect )rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect( image.CGImage, rect);
    UIImage* image1 = [ UIImage imageWithCGImage:subImageRef ];
    
    CGImageRelease( subImageRef );
    return image1;
}



- ( void ) setLoop:( BOOL )b
{
    loop = b;
}


- ( void ) setScale:( float )s
{
    scale = s;
}


- ( void ) setPos:( CGPoint )point
{
    position = point;
}


- ( void ) initCreatureActionView:(NSString*)i
{
    if ( inited )
    {
        return;
    }
    
    [ imagePath release ];
    imagePath = [ [ NSString alloc ] initWithString:i ];
    
    inited = YES;
    
    loop = YES;
    
    scale = 1.0f;
    
    [ actionID release ];
    actionID = [ [ NSString alloc ] initWithString:i ];
}


- (void) clearAnimating
{
    [ self stopAnimating ];
    
    [ self setImage:NULL ];
    
    imageEnd = NULL;
}


- ( void ) releaseCreatureActionView
{
    if ( !inited )
    {
        return;
    }
    
    [ image release ];
    image = NULL;
    
    imageEnd = NULL;
    
    [ self clearAnimating ];
    
    inited = NO;
    
    [ actionID release ];
    actionID = NULL;
    
    [ action release ];
    action = NULL;
    
    direction = 0;
}


- ( void ) removeFromSuperview
{
    [ self releaseCreatureActionView ];
    [ super removeFromSuperview ];
}


- ( void ) setAction:( NSString* )a :( int )d
{
    if ( !inited )
    {
        return;
    }
    
    if ( [ action isEqualToString:a ] && direction == d )
    {
        return;
    }
    
    [ action release ];
    action = [ [ NSString alloc ] initWithString:a ];
    direction = d;
    
        //dispatch_async( [ GameUIManager instance ].LoadingQueue , ^{
            
            NSString* aid = NULL;
            
            if ( [ action isEqualToString:CAT_STAND ] )
            {
                aid = [ NSString stringWithFormat:@"%@A" , actionID ];
            }
            else if ( [ action isEqualToString:CAT_MOVE ] )
            {
                aid = [ NSString stringWithFormat:@"%@B" , actionID ];
            }
            
            NSString* path = [ [ NSBundle mainBundle ] pathForResource:aid ofType:@"png" inDirectory:ACTION_PATH ];
            
            if ( !path )
            {
                return;
            }
            
            UIImage* img = [ UIImage imageWithContentsOfFile:path ];
            [ imagePath release ];
            
            imagePath = NULL;
            
            [ image release ];
            image = img.retain;
            
            NSMutableArray* array = [ [ NSMutableArray alloc ] init ];
            
            
            int w = CGImageGetWidth( image.CGImage );
            int h = CGImageGetHeight( image.CGImage );
            
            int fc = 4;
            float spd = 0.2f;
            
            int xa = 0;
            int ya = 0;
            
            int xs = 0;
            int ys = 0;
            
            if ( [ action isEqualToString:CAT_MOVE ] )
            {
                xa = w / 4;
                ya = h / 4;
                
                xs = 0;
                ys = d;
            }
            else if( [ action isEqualToString:CAT_STAND ] )
            {
                xa = w / 2;
                ya = h / 2;
            }
            
            int xo = xa / 2;
            int yo = ya;
            
            CGRect rect = CGRectMake( xs , ys * ya , xa , ya );

            for ( int i = 0 ; i < fc ; i++ )
            {
                imageEnd = [ self getSubImage:rect ];
                [ array addObject:imageEnd ];
                
                rect.origin.x += xa;
                
                while ( rect.origin.x + rect.size.width > w )
                {
                    rect.origin.x = 0;
                    rect.origin.y += ya;
                }
            }
            
            [ self setImage:NULL ];
            
            [ self setAnimationImages:array ];
            [ self setAnimationDuration:spd * fc / GAME_SPEED ];
            
            [ array removeAllObjects ];
            [ array release ];
            array = NULL;
            
            rect = self.frame;
            rect.origin.x = -xo + position.x;
            rect.origin.y = -yo + position.y;
            rect.size.width = xa;
            rect.size.height = ya;
            [ self setFrame:rect ];
            
            if ( loop )
            {
                [ self setAnimationRepeatCount:NSIntegerMax ];
            }
            else
            {
                [ self setAnimationRepeatCount:1 ];
            }
            
            [ self startAnimating ];
        //});
    
}



@end
