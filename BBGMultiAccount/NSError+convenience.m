//
//  NSError+convenience.m
//
//  Created by Giuseppe Basile on 11/05/12.
//  Copyright (c) 2012 Sharit. All rights reserved.
//

#import "NSError+convenience.h"

@implementation NSError (convenience)

+ (NSError *) errorWithError:(NSError *)error domain:(NSString *)newDomain errorCode:(NSInteger)newCode
{
	if (![error isKindOfClass:[NSError class]]) {
		return nil;
	}
	if (![newDomain isKindOfClass:[NSString class]]) {
		return error;
	}
	NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionary];
	if ([error localizedDescription]) {
		[userInfoDict setObject:[error localizedDescription] forKey:NSLocalizedDescriptionKey];
	}
	if ([error localizedFailureReason]) {
		[userInfoDict setObject:[error localizedFailureReason] forKey:NSLocalizedFailureReasonErrorKey];
	}
	if ([error localizedRecoverySuggestion]) {
		[userInfoDict setObject:[error localizedRecoverySuggestion] forKey:NSLocalizedRecoveryOptionsErrorKey];
	}
	return [NSError errorWithDomain:newDomain code:newCode userInfo:userInfoDict];
}

+ (NSError *) errorWithError:(NSError *)error localizedDescription:(NSString *)localizedString
{
	if (![localizedString isKindOfClass:[NSString class]]) {
		return error;
	}
	
	if (![error isKindOfClass:[NSError class]]) {
		return nil;
	}
	NSMutableDictionary *userInfoDict = [NSMutableDictionary dictionaryWithDictionary: [error userInfo]];
	[userInfoDict setObject:localizedString forKey:NSLocalizedDescriptionKey];
	return [NSError errorWithDomain:[error domain] code:[error code] userInfo:userInfoDict];
}

@end
