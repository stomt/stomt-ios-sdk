//
//  HTTPResponseChecker.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "HTTPResponseChecker.h"
#import "dbg.h"
#import "Stomt.h"

#define __DGB__

@implementation HTTPResponseChecker

+ (HTTPERCode)checkResponseCode:(NSURLResponse*)response;
{
	@synchronized(self)
	{
		if(!response) _err("No response object given! Aborting...");
		HTTPERCode rt = ERR;
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
		NSInteger statusCode = [httpResponse statusCode];
		
		switch(statusCode){
			case 200:
			{
				rt = OK;
				break;
			}
			case 403:
			{
				rt = POST_ALR;
				_warn("Stomt already posted.");
				break;
			}
			case 419:
			{
				rt = OLD_TOKEN;
				_warn("Access token expired, logging out...");
				break;
			}
			case 401:
			{
				rt = WRONG_APPID;
				_warn("Your APPID is not valid. Request a new one on stomt.com");
				break;
			}
			case 404:
			{
				rt = NOT_FOUND;
				_warn("The resource you were looking for couldn't be found.");
				break;
			}
			default:
				return (HTTPERCode)statusCode;
		}
		return rt;
	}
error:
	return 0;
}

+ (NSError*)errorWithResponseCode:(HTTPERCode)responseCode withData:(NSData *)data
{
	@synchronized(self) {
		NSError* rt;
		switch (responseCode) {
		case OK:
			{
				break;
			}
		case OLD_TOKEN:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtInvalidTokenDomain" code:OLD_TOKEN userInfo:@{@"NSLocalizedDescriptionKey":@"The Access Token used for this session has expired.",@"NSLocalizedFailureReasonErrorKey":@"You may have recently logged in somewhere else.",@"NSLocalizedRecoverySuggestionErrorKey":@"Refresh your Access Token with +requestNewAccessTokenInBackgroundWithBlock: Stomt class method. If the error persists, logout and then sign in again."}];
				break;
			}
			case WRONG_APPID:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtWrongAppIDDomain" code:WRONG_APPID userInfo:@{@"NSLocalizedDescriptionKey":@"Unauthorized. The provided appID is not valid.",@"NSLocalizedFailureReasonErrorKey":[NSNull null],@"NSLocalizedRecoverySuggestionErrorKey":@"Request a new appID from stomt's app section."}];
				break;
			}
			case POST_ALR:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtAlreadyPostedDomain" code:POST_ALR userInfo:@{@"NSLocalizedDescriptionKey":@"The stomt you are trying to send has already been posted.",@"NSLocalizedFailureReasonErrorKey":[NSNull null],@"NSLocalizedRecoverySuggestionErrorKey":@"Change the stomt's text body."}];
				break;
			}
			case NOT_FOUND:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtResourceNotFoundDomain" code:NOT_FOUND userInfo:@{@"NSLocalizedDescriptionKey":@"The requested resource couldn't be found in stomt's servers.",@"NSLocalizedFailureReasonErrorKey":[NSNull null],@"NSLocalizedRecoverySuggestionErrorKey":@"Try requesting another resource and/or check your request parameters."}];
				break;
			}
			default:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtUnknownErrorDomain" code:0 userInfo:@{@"NSLocalizedDescriptionKey":@"UNKNOWN ERROR",@"NSLocalizedFailureReasonErrorKey":[NSString stringWithFormat:@"%s",data.bytes],@"NSLocalizedRecoverySuggestionErrorKey":@"Contact @H3xept for further details."}];
				break;
			}
		}
		return rt;
	}
}
@end
