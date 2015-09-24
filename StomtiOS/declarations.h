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
	kStateError,kStateSuccess
}kState;

typedef enum{
	kAuthRequest,kStomtCreationRequest,kImageUploadRequest,kLogoutRequest,kStomtRequest
}RequestType;

typedef enum{
	OK,ERR,OLD_TOKEN
}HTTPHRCode;

typedef enum{
	kSTImageCategoryAvatar,kSTImageCategoryCover,kSTImageCategoryStomt
}kSTImageCategory;


#endif
