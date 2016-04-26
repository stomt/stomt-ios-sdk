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
		HTTPERCode rt;
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
		NSInteger statusCode = [httpResponse statusCode];
		
		switch(statusCode){
			case 200:
			{
				rt = OK;
				break;
			}
			case 409:
			{
				rt = CONFLICT;
				break;
			}
			case 400:
			{
				rt = BAD_REQUEST;
				break;
			}
			case 403:
			{
				rt = FORBIDDEN;
				_warn("Forbidden.");
				break;
			}
			case 401:
			{
				rt = UNAUTH;
				_warn("Unauthorized.");
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
			case UNAUTH:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtUnauthorizedDomain" code:UNAUTH userInfo:@{@"NSLocalizedDescriptionKey":@"Unauthorized. The provided appID/token/credentials are not valid or connection timeout has occurred.",@"NSLocalizedFailureReasonErrorKey":[NSNull null],@"NSLocalizedRecoverySuggestionErrorKey":@"Request a new appID from stomt's app section or try to login again."}];
				break;
			}
			case CONFLICT:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtAlreadyPostedDomain" code:CONFLICT userInfo:@{@"NSLocalizedDescriptionKey":@"The resource you are trying to create already exists.",@"NSLocalizedFailureReasonErrorKey":[NSNull null],@"NSLocalizedRecoverySuggestionErrorKey":@"Create a unique resource."}];
				break;
			}
			case NOT_FOUND:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtResourceNotFoundDomain" code:NOT_FOUND userInfo:@{@"NSLocalizedDescriptionKey":@"The requested resource couldn't be found in stomt's servers.",@"NSLocalizedFailureReasonErrorKey":[NSNull null],@"NSLocalizedRecoverySuggestionErrorKey":@"Try requesting another resource and/or check your request parameters."}];
				break;
			}
			case BAD_REQUEST:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtBadRequestErrorDomain" code:400	userInfo:@{@"NSLocalizedDescriptionKey":@"BAD REQUEST",@"NSLocalizedFailureReasonErrorKey":[NSString stringWithFormat:@"%s",data.bytes],@"NSLocalizedRecoverySuggestionErrorKey":@"Contact @H3xept for further details."}];
				break;
			}
			case FORBIDDEN:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtForbiddenDomain" code:403 userInfo:@{@"NSLocalizedDescriptionKey":@"Forbidden",@"NSLocalizedFailureReasonErrorKey":[NSString stringWithFormat:@"%@ - %@",@"The requested resource cannot be accessed.",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]],@"NSLocalizedRecoverySuggestionErrorKey":@""}];
				break;
			}
			default:
			{
				rt = [[NSError alloc] initWithDomain:@"StomtUnknownErrorDomain" code:0 userInfo:@{@"NSLocalizedDescriptionKey":@"Internal server error.",@"NSLocalizedFailureReasonErrorKey":[NSString stringWithFormat:@"%s",data.bytes],@"NSLocalizedRecoverySuggestionErrorKey":@"Contact @H3xept for further details."}];
				break;
			}
		}
		return rt;
	}
}
@end
