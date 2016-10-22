//
//  declarations.h
//  Stomt Framework
//
//  Created by Leonardo Cascianelli on 09/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#ifndef __declarations__
#define __declarations__

typedef enum{
	kStateError,
	kStateSuccess
}kState;

typedef enum{
	kSTAuthenticationRouteFacebook = 1
}kSTAuthenticationRoute;

typedef enum{
	kAuthRequest,
	kStomtCreationRequest,
	kImageUploadRequest,
	kLogoutRequest,
	kStomtRequest,
	kFeedRequest,
	kTargetRequest,
	kBasicTargetRequest,
	kFacebookAuthenticationRequest,
	kExternalAuthenticationRequest,
	kAvailabilityRequest,
	kBasicSignupRequest,
	kLoginRequest,
	kCommentsRequest,
	kCommentCreationRequest
}RequestType;

typedef enum{
	OK=200,UNAUTH=401,NOT_FOUND=404,FORBIDDEN=413,BAD_REQUEST=400,CONFLICT=409,INTERNAL_SERVER_ERROR=500
}HTTPERCode;

typedef enum{
	kSTImageCategoryAvatar,kSTImageCategoryCover,kSTImageCategoryStomt
}kSTImageCategory;

typedef enum{
	kStobjectNil = 0,kSTObjectLike,kSTObjectWish
}kSTObjectQualifier;

typedef enum{
	STKeywordFilterVotes = 1 << 0,
	STKeywordFilterReaction = 1 << 1,
	STKeywordFilterImage = 1 << 2,
	STKeywordFilterLabels = 1 << 3,
	STKeywordFilterUrl = 1 << 4
}STKeywordFilter;

typedef enum{
	STStandardFeedHome,
	STStandardFeedDiscover
}STStandardFeed;

#endif
