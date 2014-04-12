//
//  SoundHandler.h
//  ixyhz
//
//  Created by fox1 on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface GameSoundHandler : AVAudioPlayer
{
}

- ( void ) setLoop:( BOOL ) b;
- ( void ) initSoundHandler:( NSString* ) name :( NSString* )type;

@end
