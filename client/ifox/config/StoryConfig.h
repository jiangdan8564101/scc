//
//  StoryConfig.h
//  sc
//
//  Created by fox on 13-12-29.
//
//

#import "GameConfig.h"


@interface StoryConfigData : NSObject
@property ( nonatomic ) int ID , Index;
@property ( nonatomic , assign ) NSString* Name;
@property ( nonatomic , assign ) NSString* Des;
@end


@interface StoryConfig : GameConfig

@property ( nonatomic , assign ) NSMutableArray* Array;

+ ( StoryConfig* ) instance;

@end
