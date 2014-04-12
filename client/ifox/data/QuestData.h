//
//  QuestData.h
//  sc
//
//  Created by fox on 13-10-15.
//
//

#import "GameData.h"


@interface QuestData : GameData
{
    
}

@property( nonatomic , assign ) NSMutableDictionary* Data;

+ ( QuestData* ) instance;

- ( int ) getQuest:( int )i;
- ( void ) setQuest:( int )i :( int )n;
- ( void ) checkQuest;
- ( void ) checkNewQuest;

@end


