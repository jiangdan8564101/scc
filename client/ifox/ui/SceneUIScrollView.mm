//
//  SceneUIScrollView.m
//  sc
//
//  Created by fox on 13-2-11.
//
//

#import "SceneUIScrollView.h"
#import "BattleMapScene.h"
#import "GameSceneManager.h"
#import "BattleNetHandler.h"
#import "SceneData.h"
#import "PlayerData.h"


@implementation SceneUIScrollView

- ( void ) setData:( SceneMap* )sm
{
//    if ( sceneMap == sm )
//    {
//        [ object performSelector:sel withObject:select ];
//        return;
//    }
    
    sceneMap = sm;
    
    int show = 0;
    
    NSArray* array = sceneDic.allValues;
    for ( int i = 0 ; i < array.count ; i++ )
    {
        SceneUIItemView* v = (SceneUIItemView*)[ array objectAtIndex:i ];
        [ v removeFromSuperview ];
    }
    [ sceneDic removeAllObjects ];
    
    
    
    for ( int i = 0 ; i < sm.SubScenes.count ; i++ )
    {
        SubSceneMap* ssm = [ sm.SubScenes objectAtIndex:i ];

//        if ( ssm.Story > [ PlayerData instance ].Story )
//        {
//            continue;
//        }
        
        SceneDataItem* sceneDataItem = [ [ SceneData instance ] getSceneData:ssm.ID ];
        
        BOOL b = NO;
        if ( !sceneDataItem )
        {
            [ [ SceneData instance ] activeSceneData:ssm.ID ];
            b = YES;
        }
        
        
        NSData* tempArchiveView = [ NSKeyedArchiver archivedDataWithRootObject:itemView ];
        SceneUIItemView* viewOfSelf = [ NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView ];
        
        
        [ self addSubview:viewOfSelf ];
        
        UIButton* button = (UIButton*)[ viewOfSelf viewWithTag:200 ];
        [ button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside ];
        
        [ viewOfSelf setData:ssm ];
        
        CGRect rect = viewOfSelf.frame;
        rect.origin.y = i * rect.size.height + 2 + i * 2;
        [ viewOfSelf setFrame:rect ];
        
        [ sceneDic setObject:viewOfSelf forKey:[ NSNumber numberWithInt:viewOfSelf.SubSceneID ] ];
        
        [ viewOfSelf setNew:b ];
        
        if ( i == show )
        {
            [ button setSelected:YES ];
            [ object performSelector:sel withObject:viewOfSelf ];
            select = viewOfSelf;
        }
        
        
        if ( sceneDataItem.Per < 0.5f )
        {
            break;
        }
    }
    
    [ self setContentSize:CGSizeMake( 0 , itemView.frame.size.height * sm.SubScenes.count + 2 + sm.SubScenes.count * 2 ) ];
    
//    [ UIScrollView animateWithDuration:0.8f
//                                 delay:0.1f
//                               options:UIViewAnimationCurveLinear
//                            animations:^{
//                                self.contentOffset = CGPointMake( itemView.frame.size.height * show + show * 2 , 0);
//                            }
//                            completion:^(BOOL finished){}
//     ];
}


- ( void ) onButton:( UIButton* )button
{
    SceneUIItemView* iv = (SceneUIItemView*)button.superview;
    
    NSArray* array = sceneDic.allValues;
    
    for ( int i = 0 ; i < array.count ; i++ )
    {
        SceneUIItemView* v = (SceneUIItemView*)[ array objectAtIndex:i ];
        
        UIButton* button = (UIButton*)[ v viewWithTag:200 ];
        [ button setSelected:NO ];
    }
    
    [ button setSelected:YES ];
    
    [ object performSelector:sel withObject:iv ];
    
    select = iv;
}


- ( void ) initItemView:(SceneUIItemView *)item :(NSObject *)obj :(SEL)s
{
    itemView = item;
    sceneDic = [ [ NSMutableDictionary alloc ] init ];
    
    object = obj;
    sel = s;
}


- ( void ) releaseItemView
{
    NSArray* array = sceneDic.allValues;
    for ( int i = 0 ; i < array.count ; i++ )
    {
        SceneUIItemView* v = (SceneUIItemView*)[ array objectAtIndex:i ];
        [ v removeFromSuperview ];
    }
    
    [ sceneDic removeAllObjects ];
    [ sceneDic release ];
    sceneDic = NULL;
}


@end
