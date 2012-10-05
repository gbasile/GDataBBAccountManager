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

+ (NSSet *)keyPathsForValuesAffectingIdentifier
{
	return [NSSet setWithObject:@"authToken"];
}

#pragma NSCoding Protocol
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self.authToken persistenceResponseString]	forKey:@"authToken"];
    [aCoder encodeObject:[self.authToken userEmail] forKey:@"userMail"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super init]) 
	{
        NSString *authResponseString = [aDecoder decodeObjectForKey:@"authToken"];
        NSString *userMail = [aDecoder decodeObjectForKey:@"userMail"];
        
        Class signInClass = [GTMOAuth2WindowController signInClass];
        NSURL *tokenURL = [signInClass googleTokenURL];
        NSString *redirectURI = [signInClass nativeClientRedirectURI];
        
        GTMOAuth2Authentication *theAuthToken;
        theAuthToken = [GTMOAuth2Authentication authenticationWithServiceProvider:kGTMOAuth2ServiceProviderGoogle
                                                                 tokenURL:tokenURL
                                                              redirectURI:redirectURI
                                                                 clientID:kBBOAuthGoogleClientID
                                                             clientSecret:kBBOAuthGoogleClientSecret];
		[theAuthToken setKeysForResponseString:authResponseString];
        theAuthToken.userEmail = userMail;
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
