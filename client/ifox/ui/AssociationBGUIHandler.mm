//
//  AssociationUIHandler.m
//  sc
//
//  Created by fox on 13-12-13.
//
//

#import "AssociationBGUIHandler.h"
#import "GameSceneManager.h"

@implementation AssociationBGUIHandler

static AssociationBGUIHandler* gAssociationBGUIHandler;
+ (AssociationBGUIHandler*) instance
{
    if ( !gAssociationBGUIHandler )
    {
        gAssociationBGUIHandler = [ [ AssociationBGUIHandler alloc] init ];
        [ gAssociationBGUIHandler initUIHandler:@"AssociationBGView" isAlways:YES isSingle:NO ];
    }
    
    return gAssociationBGUIHandler;
}


@end


