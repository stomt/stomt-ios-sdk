//
//  StomtTestCase.m
//  StomtiOS
//
//  Created by Max Klenk on 30/09/15.
//  Copyright © 2015 Leonardo Cascianelli. All rights reserved.
//

#import "StomtTestCase.h"
#import "Stomt.h"

@implementation StomtTestCase

- (void)setUp {
    [super setUp];
    
    // custom setUp
    [Stomt setAppID:@"sXUs7glmc2xeCpceIgrSorG6z"];
	[Stomt setAPIHost:@"https://test.rest.stomt.com"];
    self.timeout = 5;
}

//-----------------------------------------------------------------------------
// Helper
//-----------------------------------------------------------------------------
- (UIImage*)createImage {
    UIImage *image1 = [UIImage imageNamed:@"image1.png"];
    UIImage *image2 = [UIImage imageNamed:@"image2.png"];
    
    CGSize newSize = CGSizeMake(300, 300);
    UIGraphicsBeginImageContext( newSize );
    
    [image1 drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    [image2 drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
}


@end
