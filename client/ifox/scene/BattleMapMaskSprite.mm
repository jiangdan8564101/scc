//
//  BattleMapMaskSprite.m
//  sc
//
//  Created by fox on 13-5-1.
//
//

#import "BattleMapMaskSprite.h"
#import "ClientDefine.h"

@implementation BattleMapMaskSprite

@synthesize RectMask;


- ( void ) setGroup:( int )g
{
    [ self setTextureRect:RectMask ];
    
//    switch ( g )
//    {
//        case GROUP_NULL:
//            [ self setTextureRect:RectMask ];
//            break;
//        case GROUP_PLAYER:
//            [ self setTextureRect:CGRectMake( RectMask.origin.x , RectMask.origin.y + 330 , RectMask.size.width , RectMask.size.height ) ];
//            break;
//        case GROUP_ENEMY:
//            [ self setTextureRect:CGRectMake( RectMask.origin.x , RectMask.origin.y + 588 , RectMask.size.width , RectMask.size.height ) ];
//            break;
//        case GROUP_NPC:
//            [ self setTextureRect:CGRectMake( RectMask.origin.x , RectMask.origin.y + 846 , RectMask.size.width , RectMask.size.height ) ];
//            break;
//        default:
//            [ self setTextureRect:CGRectMake( RectMask.origin.x , RectMask.origin.y + 1104 , RectMask.size.width , RectMask.size.height ) ];
//            break;
//    }
}

@end
