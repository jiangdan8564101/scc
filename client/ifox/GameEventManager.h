//
//  GameEventManager.h
//  sc
//
//  Created by fox on 14-1-13.
//
//

#import <Foundation/Foundation.h>
#import "EventConfig.h"


@interface GameEventManager : NSObject
{
    
}

@property ( nonatomic , assign ) EventConfigData* ActiveEvent;

+ ( GameEventManager* )instance;

- ( void ) checkBattleEvent:( int )sub;
- ( void ) endEvent:( BOOL )b;
- ( void ) checkEventComplete;
- ( void ) clearEvent;

@end
