//
//  STImagePoolDelegate.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 21/06/16.
//  Copyright © 2016 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "block_declarations.h"

@class STWebImageView;

@protocol STImagePoolDelegate <NSObject>
@required
- (STWebImageView*)dequeueImageWithIdentifier:(NSString*)identifier orDownloadFromURL:(NSURL*)url withBlock:(BooleanCompletion)completion;
@end
