//
//  HTTPResponseChecker.m
//  StomtiOS
//
//  Created by Leonardo Cascianelli on 12/09/15.
//  Copyright (c) 2015 Leonardo Cascianelli. All rights reserved.
//

#import "HTTPResponseChecker.h"

@implementation HTTPResponseChecker

+ (HTTPHRCode)checkResponseCode:(NSURLResponse*)response;
{
	@synchronized(self)
	{
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
		}
		return rt;
	}
}
@end
