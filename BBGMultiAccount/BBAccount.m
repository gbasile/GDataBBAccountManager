//
//  BBAccount.m
//  GMultiAccountManager
//
//  Created by Giuseppe Basile on 05/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#import "BBAccount.h"
#import "GTMOAuth2Authentication.h"
#import "GTMOAuth2WindowController.h"
#import "BBGMultiAccountConfig.h"

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

- (NSString *)keychainKeyForUsername:(NSString *)username
{
    return [NSString stringWithFormat:@"Archy Login:%@", self.identifier];
}

+ (NSSet *)keyPathsForValuesAffectingIdentifier
{
	return [NSSet setWithObject:@"authToken"];
}

#pragma NSCoding Protocol
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // **** Restore me when I can resume a token without the Keychain ****
    // **** Start HERE ****
    // [aCoder encodeObject:[self.authToken persistenceResponseString]	forKey:@"authToken"];
    // **** END HERE ****
    
    [aCoder encodeObject:self.identifier forKey:@"userEmail"];
    [GTMOAuth2WindowController saveAuthToKeychainForName:self.identifier authentication:self.authToken];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) 
	{
        // **** Restore me when I can resume a token without the Keychain ****
        // **** Start HERE ****
//      NSString *authResponseString = [aDecoder decodeObjectForKey:@"authToken"];
//		GTMOAuth2Authentication *theAuthToken = [[[GTMOAuth2Authentication alloc] init] autorelease];
//		[theAuthToken setKeysForResponseString:authResponseString];
//		self.authToken = theAuthToken;
        // **** END HERE ****
        
        NSString *userEmail = [aDecoder decodeObjectForKey:@"userEmail"];
		GTMOAuth2Authentication *auth = [GTMOAuth2WindowController authForGoogleFromKeychainForName:userEmail
                                                                                           clientID:kBBOAuthGoogleClientID
                                                                                       clientSecret:kBBOAuthGoogleClientSecret];
        auth.userEmail = userEmail;
        self.authToken = auth;
        
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
