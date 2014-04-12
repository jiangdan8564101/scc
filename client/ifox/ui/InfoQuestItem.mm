//
//  InfoQuestItem.m
//  sc
//
//  Created by fox on 13-12-5.
//
//

#import "InfoQuestItem.h"
#import "QuestData.h"

@implementation InfoQuestItem
@synthesize QuestID ;

- ( void ) setData:( NSObject* )dd
{
    QuestConfigData* d = (QuestConfigData*)dd;
    
    NSString* str = [ NSString stringWithFormat:@"%@" , d.Img ];
    NSString* path = [ [ NSBundle mainBundle ] pathForResource:str ofType:@"png" inDirectory:ICON_PATH ];
    UIImage* image = [ UIImage imageWithContentsOfFile:path ];
    
    UIImageView* imageView = (UIImageView*)[ self viewWithTag:40 ];
    [ imageView setImage:image ];
    
    int over = [ [ [ QuestData instance ].Data objectForKey:[ NSNumber numberWithInt:d.QuestID ] ] intValue ];
    
    UIImageView* imagec = (UIImageView*)[ self viewWithTag:30 ];
    [ imagec setHidden:over != QDT_COMPLETE ];
    
    
    QuestID = d.QuestID;
}


- ( void ) updateData
{
    
}


- ( void ) setSelect:( BOOL )b
{
    
}

@end
