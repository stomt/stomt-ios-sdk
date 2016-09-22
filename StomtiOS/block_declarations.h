//
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#ifndef StomtiOS_block_declarations_h
#define StomtiOS_block_declarations_h

@class Foundation;
@class STUser;
@class STObject;
@class STImage;
@class STFeed;
@class STTarget;
@class UIImage;
@class STComment;


typedef void (^ BooleanCompletion)(NSError* error, NSNumber* succeeded);
typedef void (^ AuthenticationBlock)(NSError* error, STUser* user);
typedef void (^ StomtCreationBlock)(NSError* error, STObject* stomt);
typedef void (^ ImageUploadBlock)(NSError* error, STImage* image);
typedef void (^ FeedRequestBlock)(NSError* error, STFeed* feed);
typedef void (^ TargetRequestBlock)(NSError* error, STTarget* target);
typedef void (^ UserAvailabilityBlock)(NSError* error, NSNumber* available);
typedef void (^ ImageDownloadBlock)(NSError* error, UIImage* image);
typedef void (^ CommentsRequestBlock)(NSError* error, NSArray* comments);
typedef void (^ CommentCreationBlock)(NSError* error, STComment* comment);
#endif
