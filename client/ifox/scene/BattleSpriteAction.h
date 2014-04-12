//
//  BattleSpriteAction.h
//  sc
//
//  Created by fox on 13-2-13.
//
//

#import <Foundation/Foundation.h>
#import "BattleSprite.h"
#import "cocos2d.h"

@interface BattleSpriteAction : NSObject
{
    BOOL loading;
    BOOL onLoad;
    
    CCAnimation* animation;
    CCAnimate* animate;
    
    CCTexture2D* texture;
    
    NSMutableArray* frameArray;
    NSDictionary* actionDic;
    
    NSString* actionID;
    
    
    
    CCSprite* owner;
    NSObject* target;
    SEL sel;
    
    BOOL loop;
    
    CGRect textureRect;
    
    BOOL inited;
    NSString* isloading;
    
    int width;
    int height;
    int fc;
    float spd;
}


@property ( nonatomic ) BOOL UseAgain , UseAsync , NoClear , UseDefault;
@property ( nonatomic , assign ) CCSprite* Owner;
@property ( nonatomic , readonly ) NSString* ActionID;
@property ( nonatomic , assign ) CCTexture2D* Texture;
@property ( nonatomic ) int ActionIndex;

- ( CGRect ) getRect;

- ( void ) setLoop:( BOOL )loop;
- ( BOOL ) setAction:( int )d;
- ( BOOL ) playEffect:( NSObject* )t :( SEL )s;
- ( void ) setActionID:( NSString* )i;
- ( void ) clearAction;

- ( void ) initAction:( CCSprite* )o;
- ( void ) releaseAction;

@end
