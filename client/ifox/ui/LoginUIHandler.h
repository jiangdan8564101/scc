//
//  LoginUIHandler.h
//  sc
//
//  Created by fox on 12-10-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIHandlerZoom.h"

@interface LoginUIHandler : UIHandlerZoom
{
    UIButton* newGameButton;
    UIButton* loadGameButton;
}


+ ( LoginUIHandler* ) instance;


@end

