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
	kAuthRequest,
	kStomtCreationRequest,
	kImageUploadRequest,
	kLogoutRequest,
	kStomtRequest,
	kFeedRequest,
	kTargetRequest,
	kBasicTargetRequest,
	kFacebookAuthenticationRequest
}RequestType;

typedef enum{
	OK,ERR,OLD_TOKEN,WRONG_APPID
}HTTPHRCode;

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

#endif
