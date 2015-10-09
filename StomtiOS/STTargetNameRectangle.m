//
//  STTargetNameRectangle.m
//  ProjectName
//
//  Created by H3xept on 04/10/15.
//  Copyright (c) 2015 H3xept. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import "STTargetNameRectangle.h"


@implementation STTargetNameRectangle

#pragma mark Initialization

+ (void)initialize
{
}

#pragma mark Drawing Methods

+ (void)drawCanvas1WithFrame: (CGRect)frame
{
    //// Color Declarations
    UIColor* color2 = [UIColor colorWithRed: 0.728 green: 0.728 blue: 0.728 alpha: 1];


    //// Subframes
    CGRect page1 = CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 0.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 1);


    //// Page-1
    {
        //// Rectangle-1 Drawing
        UIBezierPath* rectangle1Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(page1) + floor(CGRectGetWidth(page1) * 0.00000 + 0.5), CGRectGetMinY(page1) + floor(CGRectGetHeight(page1) * 0.00000 + 0.5), floor(CGRectGetWidth(page1) * 1.00000 + 0.5) - floor(CGRectGetWidth(page1) * 0.00000 + 0.5), floor(CGRectGetHeight(page1) * 1.00000 + 0.5) - floor(CGRectGetHeight(page1) * 0.00000 + 0.5)) cornerRadius: 2];
        [color2 setStroke];
        rectangle1Path.lineWidth = 1;
        [rectangle1Path stroke];
    }
}

@end