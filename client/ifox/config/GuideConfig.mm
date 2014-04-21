//
//  GuideConfig.m
//  sc
//
//  Created by fox on 13-11-28.
//
//

#import "GuideConfig.h"


@implementation GuideConfigStep
@synthesize Font , Employ;
@synthesize Str , Alert , FadeIn , FadeOut , White , Day , UI , Music , Sound , Name , NameID , ItemID , Gold;
@synthesize CreatureRight , CreatureLeft , CreatureMiddle , ActionLeft , ActionMiddle , ActionRight;
@synthesize FadeInRight , FadeOutRight , FadeInLeft , FadeOutLeft;
@synthesize FadeInMiddleLeft , FadeInMiddleRight , FadeOutMiddleLeft , FadeOutMiddleRight;
@synthesize LeftMoveRight , RightMoveLeft , RotationLeft , RotationRight;
@synthesize LeftRight , UpDown;
@synthesize StopMusic;
@end

@implementation GuideConfigData
@synthesize Steps , Story , NextStory , WorkRank , BG , GuideID , NextID , NextScene , CheckScene , Mask , BGFadeRight , BGFadeLeft , BGFade , CheckBattle , CheckBattleEnd;
@end

@implementation GuideConfig
@synthesize Dic;
@synthesize StoryDic;


GuideConfig* gGuideConfig = NULL;
+ ( GuideConfig* ) instance
{
    if ( !gGuideConfig )
    {
        gGuideConfig = [ [ GuideConfig alloc ] init ];
    }
    
    return gGuideConfig;
}


- ( GuideConfigData* ) getData:( int )i
{
    return [ Dic objectForKey:[ NSNumber numberWithInt:i ] ];
}


- ( GuideConfigData* ) getStoryData:( int )s
{
    return [ StoryDic objectForKey:[ NSNumber numberWithInt:s ] ];
}

- ( void ) initConfig
{
    Dic = [ [ NSMutableDictionary alloc ] init ];
    StoryDic = [ [ NSMutableDictionary alloc ] init ];

    [ self loadFile:@"guide0" ];
    [ self loadFile:@"guide0000" ];
    [ self loadFile:@"guide0050" ];
    
}

- ( void ) loadFile:( NSString* )str
{
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"xml" inDirectory:XML_PATH ];
    
    if ( !path )
    {
        return;
    }
    
    NSFileHandle* file = [ NSFileHandle fileHandleForReadingAtPath:path ];
    if ( !file )
    {
        return;
    }
    
    NSData* data = [ file readDataToEndOfFile ];
    [ file closeFile ];
    
    NSXMLParser* parser = [ [ NSXMLParser alloc] initWithData:data ];
    [ parser setDelegate:self ];
    [ parser parse ];
    [ parser release ];
}


- ( void ) releaseConfig
{
    [ Dic removeAllObjects ];
    [ Dic release ];
    Dic = NULL;
}


-( void )parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    static GuideConfigData* configData = NULL;
    
    if ( [ elementName isEqualToString:@"guide" ] )
    {
        configData = [ [ GuideConfigData alloc ] init ];
        
        
        configData.Steps = [ [ NSMutableArray alloc ] init ];
        configData.NextID = [ [ attributeDict objectForKey:@"next" ] intValue ];
        configData.GuideID = [ [ attributeDict objectForKey:@"id" ] intValue ];
        configData.Story = [ [ attributeDict objectForKey:@"story" ] intValue ];
        configData.NextStory = [ [ attributeDict objectForKey:@"nextStory" ] intValue ];
        configData.WorkRank = [ [ attributeDict objectForKey:@"workRank" ] intValue ];
        configData.Mask = [ [ attributeDict objectForKey:@"mask" ] intValue ];
        configData.BGFadeLeft = [ [ attributeDict objectForKey:@"bgFadeLeft" ] floatValue ];
        configData.BGFadeRight = [ [ attributeDict objectForKey:@"bgFadeRight" ] floatValue ];
        configData.BGFade = [ [ attributeDict objectForKey:@"bgFade" ] floatValue ];
        configData.CheckBattle = [ [ attributeDict objectForKey:@"checkBattle" ] intValue ];
        configData.CheckBattleEnd = [ [ attributeDict objectForKey:@"checkBattleEnd" ] intValue ];
        
        if ( [ attributeDict objectForKey:@"nextScene" ] )
        {
            configData.NextScene = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"nextScene" ] ];
        }
        
        if ( [ attributeDict objectForKey:@"activeScene" ] )
        {
            configData.ActiveScene = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"activeScene" ] ];
        }
        
        if ( [ attributeDict objectForKey:@"checkScene" ] )
        {
            configData.CheckScene = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"checkScene" ] ];
        }
        
        if ( [ attributeDict objectForKey:@"bg" ] )
        {
            configData.BG = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"bg" ] ];
        }
        
        if ( [ Dic objectForKey:[ NSNumber numberWithInt:configData.GuideID ] ] )
        {
            FLOG0( "configData.GuideID = %d " , configData.GuideID );
            assert( 0 );
        }
        
        [ Dic setObject:configData forKey:[ NSNumber numberWithInt:configData.GuideID ] ];
        
        if ( configData.Story  )
        {
             [ StoryDic setObject:configData forKey:[ NSNumber numberWithInt:configData.Story ] ];
        }
        
        [ configData release ];
    }
    
    if ( [ elementName isEqualToString:@"g" ] )
    {
        GuideConfigStep* cstep = [ [ GuideConfigStep alloc ] init ];
        
        cstep.Str = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"str" ] ];
        
        cstep.FadeOut = [ [ attributeDict objectForKey:@"fadeout" ] floatValue ];
        cstep.FadeIn = [ [ attributeDict objectForKey:@"fadein" ] floatValue ];
        cstep.White = [ [ attributeDict objectForKey:@"white" ] floatValue ];
        cstep.Day = [ [ attributeDict objectForKey:@"day" ] intValue ];
        cstep.ItemID = [ [ attributeDict objectForKey:@"item" ] intValue ];
        cstep.Gold = [ [ attributeDict objectForKey:@"gold" ] intValue ];
        cstep.NameID = [ [ attributeDict objectForKey:@"nameID" ] intValue ];
        cstep.StopMusic = [ [ attributeDict objectForKey:@"stopMusic" ] intValue ];
        
        
        cstep.FadeInRight = [ [ attributeDict objectForKey:@"fadeInRight" ] floatValue ];
        cstep.FadeInMiddleLeft = [ [ attributeDict objectForKey:@"fadeInMiddleLeft" ] floatValue ];
        cstep.FadeInMiddleRight = [ [ attributeDict objectForKey:@"fadeInMiddleRight" ] floatValue ];
        cstep.FadeInLeft = [ [ attributeDict objectForKey:@"fadeInLeft" ] floatValue ];

        cstep.FadeOutLeft = [ [ attributeDict objectForKey:@"fadeOutLeft" ] floatValue ];
        cstep.FadeOutMiddleLeft = [ [ attributeDict objectForKey:@"fadeOutMiddleLeft" ] floatValue ];
        cstep.FadeOutMiddleRight = [ [ attributeDict objectForKey:@"fadeOutMiddleRight" ] floatValue ];
        cstep.FadeOutRight = [ [ attributeDict objectForKey:@"fadeOutRight" ] floatValue ];
        cstep.LeftMoveRight = [ [ attributeDict objectForKey:@"leftMoveRight" ] floatValue ];
        cstep.RightMoveLeft = [ [ attributeDict objectForKey:@"rightMoveLeft" ] floatValue ];
        cstep.RotationLeft = [ [ attributeDict objectForKey:@"rotationLeft" ] floatValue ];
        cstep.RotationRight = [ [ attributeDict objectForKey:@"rotationRight" ] floatValue ];
        
        cstep.LeftRight = [ [ attributeDict objectForKey:@"leftRight" ] floatValue ];
        cstep.UpDown = [ [ attributeDict objectForKey:@"upDown" ] floatValue ];
        
        
        cstep.Employ = [ [ attributeDict objectForKey:@"employ" ] intValue ];
        cstep.Font = [ [ attributeDict objectForKey:@"font" ] intValue ];
        
        
        // creature id
        if ( [ [ attributeDict objectForKey:@"creatureLeft" ] intValue ] )
        {
            cstep.CreatureLeft = [ [ attributeDict objectForKey:@"creatureLeft" ] intValue ];
        }
        if ( [ [ attributeDict objectForKey:@"creatureMiddle" ] intValue ] )
        {
            cstep.CreatureMiddle = [ [ attributeDict objectForKey:@"creatureMiddle" ] intValue ];
        }
        if ( [ [ attributeDict objectForKey:@"creatureRight" ] intValue ] )
        {
            cstep.CreatureRight = [ [ attributeDict objectForKey:@"creatureRight" ] intValue ];
        }
        
        // act id
        if ( [ attributeDict objectForKey:@"actionMiddle" ] )
        {
            cstep.ActionMiddle = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"actionMiddle" ] ];
        }
        if ( [ attributeDict objectForKey:@"actionLeft" ] )
        {
            cstep.ActionLeft = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"actionLeft" ] ];
        }
        if ( [ attributeDict objectForKey:@"actionRight" ] )
        {
            cstep.ActionRight = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"actionRight" ] ];
        }
        
        
        if ( [ attributeDict objectForKey:@"alert" ] )
        {
            cstep.Alert = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"alert" ] ];
        }
        
        
        
        // open ui
        if ( [ attributeDict objectForKey:@"ui" ] )
        {
            cstep.UI = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"ui" ] ];
        }
        if ( [ attributeDict objectForKey:@"music" ] )
        {
            cstep.Music = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"music" ] ];
        }
        if ( [ attributeDict objectForKey:@"sound" ] )
        {
            cstep.Sound = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"sound" ] ];
        }
        if ( [ attributeDict objectForKey:@"name" ] )
        {
            cstep.Name = [ [ NSString alloc ] initWithString:[ attributeDict objectForKey:@"name" ] ];
        }
       
        
        
        
        [ configData.Steps addObject:cstep ];
        [ cstep release ];
    }
}




@end
