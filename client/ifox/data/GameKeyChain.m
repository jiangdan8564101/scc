//
//  GameKeyChain.m
//  sc
//
//  Created by fox on 13-8-24.
//
//

#import "GameKeyChain.h"
#import <AdSupport/AdSupport.h>

@implementation GameKeyChain

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            kSecClassGenericPassword,kSecClass,
            service, kSecAttrService,
            service, kSecAttrAccount,
             kSecAttrAccessibleAfterFirstUnlock, kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSString *idfv = [ [ [ UIDevice currentDevice] identifierForVendor ] UUIDString ];
    if ( idfv )
    {
        service = [ NSString stringWithFormat:@"%@.%@" , service , idfv ];
    }
    
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service
{
    id ret = nil;
    NSString *idfv = [ [ [ UIDevice currentDevice] identifierForVendor ] UUIDString ];
    if ( idfv )
    {
        service = [ NSString stringWithFormat:@"%@.%@" , service , idfv ];
    }
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:( id)kSecReturnData];
    [keychainQuery setObject:( id)kSecMatchLimitOne forKey:( id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    OSStatus s = SecItemCopyMatching( ( CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData );
    if ( s == noErr)
    {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:( NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
        
         CFRelease( keyData );
        
    }
    
   
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete(( CFDictionaryRef)keychainQuery);
}

@end
