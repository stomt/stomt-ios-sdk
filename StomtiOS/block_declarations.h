//
//  BlockDeclarations.h
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 10/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#ifndef StomtiOS_BlockDeclarations_h
#define StomtiOS_BlockDeclarations_h

@class Foundation;
@class STUser;
@class STObject;

typedef void (^ BooleanCompletion)(BOOL succeeded);
typedef void (^ AuthenticationBlock)(NSError* error, STUser* user);
typedef void (^ StomtCreationBlock)(NSError*, STObject* stomt);
#endif
