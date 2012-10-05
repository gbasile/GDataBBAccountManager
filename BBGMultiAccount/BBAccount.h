//
//  BBAccount.h
//  GMultiAccountManager
//
//  Created by Giuseppe Basile on 05/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GTMOAuth2Authentication;


//!	BBAccount Protocol
@protocol BBAccount <NSObject, NSCoding>	
	//! The valid GTMOAuth2Authentication token
	@property (retain, nonatomic)  GTMOAuth2Authentication* authToken;
	//!	The username of the authenticated user, equivalent to the mail address
	@property (nonatomic, readonly) NSString *identifier;	
@end

//!	A single authenticated account
@interface BBAccount : NSObject <BBAccount>
+ (id)accountWithAuthToken:(GTMOAuth2Authentication *)auth;
@end
