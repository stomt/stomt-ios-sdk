//
//  StomtRequest.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "block_declarations.h"
#import "declarations.h"

@class STObject;
@class CLLocation;
@class UIImage;

@interface StomtRequest : NSObject
@property (nonatomic,strong) NSURLRequest* apiRequest;
@property (nonatomic,readonly) RequestType requestType;

//Request constructors

+ (StomtRequest*)authenticationRequestWithEmailOrUser:(NSString*)user password:(NSString*)pass;
+ (StomtRequest*)stomtCreationRequestWithStomtObject:(STObject *)stomtObject;
+ (StomtRequest*)imageUploadRequestWithImage:(UIImage *)image forTargetID:(NSString*)targetID withImageCategory:(kSTImageCategory)category;
+ (StomtRequest*)logoutRequest;
+ (StomtRequest*)stomtRequestWithIdentifierOrURL:(NSString*)location;
//Request senders

- (void)autenticateInBackgroundWithBlock:(AuthenticationBlock)completion;
- (void)sendStomtInBackgroundWithBlock:(StomtCreationBlock)completion;
- (void)uploadImageInBackgroundWithBlock:(ImageUploadBlock)completion;
- (void)logoutInBackgroundWithBlock:(BooleanCompletion)completion;
- (void)requestStomtInBackgroundWithBlock:(StomtCreationBlock)completion;
@end
