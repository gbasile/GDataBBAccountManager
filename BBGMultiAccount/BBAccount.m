//
//  BBAccount.m
//  GMultiAccountManager
//
//  Created by Giuseppe Basile on 05/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#import "BBAccount.h"
#import "GTMOAuth2Authentication.h"

@implementation BBAccount
@synthesize authToken, identifier;

+ (id)accountWithAuthToken:(GTMOAuth2Authentication *)auth 
{
	BBAccount *theAccount = [[BBAccount alloc] init];
	[theAccount setAuthToken:auth];
	return [theAccount autorelease];
}

- (NSString *)identifier
{
	return self.authToken.userEmail;
}

+ (NSSet *)keyPathsForValuesAffectingIdentifier
{
	return [NSSet setWithObject:@"authToken"];
}

#pragma NSCoding Protocol
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:[self.authToken persistenceResponseString]	forKey:@"authToken"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) 
	{
        NSString *authResponseString = [aDecoder decodeObjectForKey:@"authToken"];
		GTMOAuth2Authentication *theAuthToken = [[[GTMOAuth2Authentication alloc] init] autorelease];
		[theAuthToken setKeysForResponseString:authResponseString];
		self.authToken = theAuthToken;
    }
    return self;
}

#pragma NSObject Protocol
- (BOOL)isEqual:(BBAccount *)object
{
	if (self.identifier	== nil || object.identifier == nil) 
	{
		return NO;
	}
    return [self.identifier isEqualToString:object.identifier];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[Account] %@", self.identifier];
}

@end
