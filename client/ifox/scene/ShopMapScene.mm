//
//  ShopMapScene.m
//  sc
//
//  Created by fox on 13-11-25.
//
//

#import "ShopMapScene.h"
#import "ShopUIHandler.h"
#import "ShopUIBGHandler.h"
#import "TalkUIHandler.h"

@implementation ShopMapScene


ShopMapScene* gShopMapScene = NULL;
+ ( ShopMapScene* )instance
{
    if ( !gShopMapScene )
    {
        gShopMapScene = [ [ ShopMapScene alloc ] init ];
    }
    
    return gShopMapScene;
}


- ( void ) onEnterMap
{
    [ [ ShopUIBGHandler instance ] visible:YES ];
    
    [ [ TalkUIHandler instance ] visible:YES ];
    [ [ TalkUIHandler instance ] setData:1300 ];
    [ [ TalkUIHandler instance ] setSel:self :@selector( onOver ) ];
    
}


- ( void ) onOver
{
    [ [ ShopUIBGHandler instance ] setImage:[ [ TalkUIHandler instance ] getImageRight ] ];
    [ [ ShopUIHandler instance ] visible:YES ];
    [ [ TalkUIHandler instance ] clearImage ];
}

- ( void ) onExitMap
{
    [ [ ShopUIBGHandler instance ] visible:NO ];
    [ [ ShopUIHandler instance ] visible:NO ];
}

@end
