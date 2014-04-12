//
//  GameEventData.h
//  sc
//
//  Created by fox on 14-1-13.
//
//

#import "GameData.h"

@interface EventData : GameData
{
    
}

@property ( nonatomic , assign ) NSMutableDictionary* Dic;

+ ( EventData* )instance;

- ( void ) setCompleteEvent:( int )i;
- ( int ) getCompleteEvent:( int )i;
- ( BOOL ) checkCompleteEventNext:( int )i;

@end
