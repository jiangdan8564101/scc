//
//  GameKeyChain.h
//  sc
//
//  Created by fox on 13-8-24.
//
//

#import <Foundation/Foundation.h>

@interface GameKeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end
