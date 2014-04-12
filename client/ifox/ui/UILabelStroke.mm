//
//  UILabelStroke.m
//  ixyhz
//
//  Created by Rain on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UILabelStroke.h"
#import "GameDefine.h"

@implementation UILabelStroke

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        strokeLineWidth = 24;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        strokeLineWidth = 24;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    // self.font = [UIFont fontWithName:@"YaHei Consolas Hybrid" size:14];
    // self.shadowColor = [UIColor blackColor];
    // self.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    if (strokeLineWidth < 1)
    {
        strokeLineWidth = 1;
    }
    
    UIColor* textColor = self.textColor;
    
    if ( !strokeColor )
    {
        if ( self.shadowColor )
        {
            strokeColor = self.shadowColor.retain;
        }
        else
        {
            strokeColor = [ [ UIColor alloc ] initWithRed:33.0f/255 green:33.0f/255 blue:33.0f/255 alpha:1.0f ];
        }
    }
    
    //self.shadowColor = strokeColor;
    //self.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    CGContextRef cf = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cf, strokeLineWidth);
    CGContextSetLineJoin(cf, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(cf, kCGTextStroke);
    self.textColor = strokeColor;
    [super drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(cf, kCGTextFill);
    self.textColor = textColor;
    [super drawTextInRect:rect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setStrokeColor:(UIColor *)color
{
    [ strokeColor release ];
    strokeColor = color.retain;
}

- (void) setStrokeLineWidth:(CGFloat)lineWidth
{
    strokeLineWidth = lineWidth;
}

- (void)removeFromSuperview
{
    [ strokeColor release ];
    strokeColor = nil;
    
    [ super removeFromSuperview ];
}

- (void)dealloc
{
    if (strokeColor)
    {
        [strokeColor release];
        strokeColor = nil;
    }
    [super dealloc];
}


-(void)setLabelText:(NSString *)t
{
    //[ self setStrokeColor:strokeColor ];
    [ self setStrokeLineWidth:2 ];
    //[self setFont:[UIFont fontWithName:@"Helvetica" size:strokeLineWidth ]];
    //[self setBackgroundColor:[ UIColor blackColor] ];
    //[self setTextColor:[UIColor colorWithRed:11.0f/255 green:249.0f/255 blue:234.0f/255 alpha:1]];
    //[ self setTextAlignment:UITextAlignmentCenter ];
    [ self setText:t ];
}

@end
