//
//  MonsterUIHandler.m
//  sc
//
//  Created by fox on 13-12-13.
//
//

#import "MonsterUIHandler.h"

@implementation MonsterUIHandler

static MonsterUIHandler* gMonsterUIHandler;
+ (MonsterUIHandler*) instance
{
    if ( !gMonsterUIHandler )
    {
        gMonsterUIHandler = [ [ MonsterUIHandler alloc] init ];
        [ gMonsterUIHandler initUIHandler:@"MonsterView" isAlways:YES isSingle:NO ];
    }
    
    return gMonsterUIHandler;
}

- ( void ) setBG:( NSString* )name
{
    UIImageView* imageView = (UIImageView*)[ view viewWithTag:1000 ];
    
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:name ofType:@"jpg" inDirectory:@"" ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    [ imageView setImage:image ];
}

@end


