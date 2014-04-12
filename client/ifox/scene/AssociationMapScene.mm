//
//  AssociationMapScene.m
//  sc
//
//  Created by fox on 13-12-13.
//
//

#import "AssociationMapScene.h"
#import "AssociationBGUIHandler.h"
#import "PlayerData.h"
#import "GuideConfig.h"
#import "TalkUIHandler.h"
#import "WorkOutlayUIHandler.h"


@implementation AssociationMapScene

AssociationMapScene* gAssociationMapScene = NULL;
+ ( AssociationMapScene* )instance
{
    if ( !gAssociationMapScene )
    {
        gAssociationMapScene = [ [ AssociationMapScene alloc ] init ];
    }
    
    return gAssociationMapScene;
}


- ( void ) onEnterMap
{
    [ [ AssociationBGUIHandler instance ] visible:YES ];
    
    if ( [ PlayerData instance ].GoPay )
    {
        GuideConfigData* data = [ [ GuideConfig instance ] getData:SOT_PAY ];
        
        if ( data.NextStory > [ PlayerData instance ].Story )
        {
            [ PlayerData instance ].Story = data.NextStory;
            
            data = [ [ GuideConfig instance ] getStoryData: data.NextStory ];
            
            [ [ TalkUIHandler instance ] visible:YES ];
            [ [ TalkUIHandler instance ] setData:data.GuideID ];
            
        }
        else
        {
            [ [ TalkUIHandler instance ] visible:YES ];
            [ [ TalkUIHandler instance ] setData:1030 ];
        }
        
        day = [ [ PlayerData instance ] getDay ];
        [ [ PlayerData instance ] pay ];
        [ [ TalkUIHandler instance ] setSel:self :@selector( onPay ) ];
    }
    else
    {
        
        if ( ![ [ PlayerData instance ] checkWorkRank ] )
        {
            [ [ TalkUIHandler instance ] visible:YES ];
            [ [ TalkUIHandler instance ] setData:SOT_NOTOPEN5 ];
        }
        else
        {
            [ [ TalkUIHandler instance ] visible:YES ];
            [ [ TalkUIHandler instance ] setData:2000 ];
            
            [ [ PlayerData instance ] levelUpWorkRank ];
        }
        
    }
    
    [ [ GameAudioManager instance ] playMusic:@"BGM003" :0 ];
}


- ( void ) onExitMap
{
    [ [ AssociationBGUIHandler instance ] visible:NO ];
}


- ( void ) onPay
{
    [ [ WorkOutlayUIHandler instance ] visible:YES ];
    [ [ WorkOutlayUIHandler instance ] showPay ];
    [ [ WorkOutlayUIHandler instance ] updateData:day ];
}

@end
