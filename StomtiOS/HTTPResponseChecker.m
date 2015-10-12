//
//  HTTPResponseChecker.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "HTTPResponseChecker.h"
#import "dbg.h"

@implementation HTTPResponseChecker

+ (HTTPHRCode)checkResponseCode:(NSURLResponse*)response;
{
	@synchronized(self)
	{
		if(!response) _err("No response object given! Aborting...");
		HTTPHRCode rt = ERR;
		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
		NSInteger statusCode = [httpResponse statusCode];
		
		switch(statusCode){
			case 200:
				rt = OK;
				break;
			case 419:
				rt = OLD_TOKEN;
				break;
			case 500:
				rt = WRONG_APPID;
				break;
		}
		return rt;
	}
error:
	return 0;
}
@end
