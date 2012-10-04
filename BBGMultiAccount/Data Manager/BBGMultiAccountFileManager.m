//
//  BBGMultiAccountFileManager.m
//  GMultiAccountManager
//
//  Created by Giuseppe Basile on 19/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#import "BBGMultiAccountFileManager.h"
#import "BBGMultiAccountFileManagerErrors.h"

@interface BBGMultiAccountFileManager ()
- (NSURL *)URLAccountsFile;
@end
@implementation BBGMultiAccountFileManager

+ (id)fileManager
{
	return [[[BBGMultiAccountFileManager alloc] init] autorelease];
}

#pragma mark - Protocol BBGMultiAccountDataManager

- (NSArray *)restoreAccountsWithError:(NSError **)error;
{
	NSURL *archiveURL = [self URLAccountsFile];
	NSArray *accounts;
	@try {
		accounts = [NSKeyedUnarchiver unarchiveObjectWithFile:[archiveURL path]];
	}
	@catch (NSException *exception) {
		if (error != NULL)
		{
			*error = [NSError errorWithDomain:BBDataManagerErrorDomain 
										 code:BBDataManagerRestoreError 
									 userInfo:nil];
		}
		return nil;
	}
	
	return accounts;
}

- (BOOL)persistAccounts:(NSArray *)accounts error:(NSError **)error
{
	NSURL *archiveURL = [self URLAccountsFile];
	if (![NSKeyedArchiver archiveRootObject:accounts toFile:[archiveURL path]]) {
		if (error != NULL)
		{
			*error = [NSError errorWithDomain:BBDataManagerErrorDomain 
										 code:BBDataManagerPersistError
									 userInfo:nil];
		}
		return NO;
	}
	return YES;
}

#pragma mark - Private methods

- (NSURL *)URLAccountsFile
{
	NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    NSURL *supportDirectoryURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
	NSString *projectName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
	if (projectName == nil) {
		projectName = @"BBGMultiAccountManager";
	}
	NSURL *supportApplicationDirectoryURL = [supportDirectoryURL URLByAppendingPathComponent:projectName];
	if (![fileManager fileExistsAtPath:[supportApplicationDirectoryURL path]]) 
	{
		NSError *theError = nil;
        if (![fileManager createDirectoryAtPath:[supportApplicationDirectoryURL path] withIntermediateDirectories:YES attributes:nil error:&theError])
		{
			return nil;
		}
	}
	
	return [supportApplicationDirectoryURL URLByAppendingPathComponent:@"GBBAccounts"];
}

@end
