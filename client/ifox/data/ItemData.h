//
//  ItemData.h
//  sc
//
//  Created by fox on 13-9-7.
//
//

#import "GameData.h"
#import "ItemConfig.h"
#import "AlchemyConfig.h"


@interface PackItemData : NSObject
{
    
}

@property ( nonatomic ) int Number , ItemID;
@property ( nonatomic ) BOOL newItem;
@property ( nonatomic ) BOOL alchemyItem;

@end



@interface ItemData : GameData
{
    NSMutableDictionary* types[ ICDT_COUNT ];
}

@property ( nonatomic , assign ) NSMutableDictionary* Items;

- ( PackItemData* ) getItem:( int )i;

- ( NSMutableDictionary* ) getType:( int )t;

- ( NSArray* ) useHPItem:( NSArray* )c;
- ( NSArray* ) useSPItem:( NSArray* )c;
- ( NSArray* ) useFSItem:( NSArray* )c;

- ( PackItemData* ) addItem:( int )i :( int )n;
- ( void ) removeItem:( int )i :( int )n;
- ( void ) initItem:( PackItemData* )d;

- ( void ) sellItem:( int )i :( int )n;
- ( void ) buyItem:( int )i :( int )n;

- ( int ) alchemyNum:( int )i;
- ( BOOL ) canAlchemy:( int )i :( int )n;
- ( void ) alchemyItem:( int )i :( int )n;

+ ( ItemData* ) instance;


@end
