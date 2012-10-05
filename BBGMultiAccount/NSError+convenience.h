//
//  NSError+convenience.h
//
//  Created by Giuseppe Basile on 11/05/12.
//  Copyright (c) 2012 Sharit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (convenience)

//! Generate a NSError from an existing one
//! @param newDomain		The new domain 
//! @param newCode			The new error code
//! @return the new NSError *
+ (NSError *) errorWithError:(NSError *)error domain:(NSString *)newDomain errorCode:(NSInteger)newCode;

//! Generate a NSError from an existing one with a new localizedDescription
//! @param localizedDesc	The new localizedString
//! @return the new NSError *
+ (NSError *) errorWithError:(NSError *)error localizedDescription:(NSString *)localizedString;

@end
