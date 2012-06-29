//
//  BBGMultiAccountManager.m
//  GMultiAccountManager
//
//  Created by Giuseppe Basile on 05/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#import "BBGMultiAccountManager.h"

#import "BBGMultiAccountManagerErrors.h"
#import "GTMOAuth2WindowController.h"
#import "BBGMultiAccountFileManager.h"
#import "BBAccount.h"
#import "NSError+convenience.h"

#define defaultBBAccountIndex 0

@interface BBGMultiAccountManager ()

@property (atomic, readwrite, retain) NSMutableArray *accounts;
@property (nonatomic, retain) NSString *clientID;
@property (nonatomic, retain) NSString *clientSecret;
@property (nonatomic, retain) NSString *scope;
@property (nonatomic, retain) id<BBGMultiAccountDataManager> dataManager;

//! Persist the accounts into the BBGMultiAccountDataManager manager (if any)
- (void)persistAccountsIntoDataManager;
//! Restore the accounts from the BBGMultiAccountDataManager manager (if any)
//! and store in into accounts property
- (void)restoreAccountsFromDataManager;
@end

@implementation BBGMultiAccountManager
@synthesize accounts = _accounts;
@synthesize clientID = _clientID;
@synthesize clientSecret = _clientSecret;
@synthesize scope = _scope;
@synthesize dataManager = _dataManager;

#pragma mark - Register
+ (void)registerWithClientId:(NSString *)clientID
                clientSecret:(NSString *)clientSecret
                       scope:(NSString *)scope
{
	return [self registerWithClientId:clientID 
						 clientSecret:clientSecret
								scope:scope
						  dataManager:[BBGMultiAccountFileManager fileManager]];
}

+ (void)registerWithClientId:(NSString *)clientID
                clientSecret:(NSString *)clientSecret
                       scope:(NSString *)scope 
				 dataManager:(id<BBGMultiAccountDataManager>)dataManager
{
	[self instance].clientID = clientID;
	[self instance].clientSecret = clientSecret;
	[self instance].scope = scope;
	[self instance].accounts = [NSMutableArray array];
	
	if ([dataManager conformsToProtocol:@protocol(BBGMultiAccountDataManager)])
	{
		[self instance].dataManager = dataManager;
	}
	
	[[self instance] restoreAccountsFromDataManager];
}

#pragma mark - Add account
+ (void)addAccount
{
	[self addAccountWithCompletionBlock:NULL];
}

+ (void)addAccountWithCompletionBlock:(void (^)(id<BBAccount> account, NSError *error))block
{
    [[[self instance] loginWindowController] signInSheetModalForWindow:nil completionHandler:^(GTMOAuth2Authentication *auth, NSError *error) {
		if (error != nil) 
		{
			if ([error code] == kGTMOAuth2ErrorWindowClosed) 
			{
				if (block != NULL) 
				{
					block(nil, nil);
					return;
				}	
			}
			else 
			{
				if (block != NULL) 
				{
					block(nil, error);
					return;
				}
			}
			return;
		}
		
		BBAccount *newAccount = [BBAccount accountWithAuthToken:auth];
		if ([[self instance].accounts containsObject:newAccount]) 
		{
			NSError *theError = [NSError errorWithDomain:BBAccountManagerErrorDomain
													code:BBAccountManagerAlreadyPresentError 
												userInfo:nil];
			theError = [NSError errorWithError:theError localizedDescription:@"The account already exist exist"];
			if (block != NULL) 
			{
				block(nil, theError);
				return;
			}
		}
		
		if (block != NULL) 
		{
			block(newAccount, nil);
		}	
		
		[[[self instance] mutableArrayValueForKey: @"accounts"] addObject: newAccount];		
		[[self instance] persistAccountsIntoDataManager];
    }];
}

#pragma mark - Accounts
+ (void)accountsWithCompletionBlock:(void (^)(NSArray *accounts, NSError *error))block
{
	if (block != NULL)
	{
		block([self instance].accounts, nil);
	}
}

+ (NSArray *)accounts
{
	return [self instance].accounts;
}

#pragma mark - Remove Accounts
+ (void)removeAccount:(id<BBAccount>)account
{
	[self removeAccount:account withCompletionBlock:NULL];
}

+ (void)removeAccount:(id<BBAccount>)accountToRemove withCompletionBlock:(void (^)(BOOL success, NSError *error))block
{
	BBGMultiAccountManager *instance = [self instance];
	
	NSError *error = nil;
	
	if ([instance.accounts containsObject:accountToRemove]) 
	{
		[[instance mutableArrayValueForKey:@"accounts"] removeObject:accountToRemove]; 
	}
	else
	{
		if (block != NULL) 
		{
			NSError *theError = [NSError errorWithDomain:BBAccountManagerErrorDomain
													code:BBAccountManagerNotExistingError 
												userInfo:nil];
			theError = [NSError errorWithError:theError localizedDescription:@"The account does not exist"];
			block(NO, theError);
			return;
		}
	}
	
	if (block != NULL) 
	{
		block(YES, error);
	}
	
	[[self instance] persistAccountsIntoDataManager];	
}

#pragma mark - Default Account
+ (void)setDefaultAccount:(id<BBAccount>) account
{
	[self setDefaultAccount:account withCompletionBlock:NULL];
}

+ (void)setDefaultAccount:(id<BBAccount>)newDefaultAccount withCompletionBlock:(void (^)(BOOL success, NSError *error))block
{
	BBGMultiAccountManager *instance = [self instance];
	NSUInteger theIndex = [instance.accounts indexOfObject:newDefaultAccount];
	if (theIndex == NSNotFound) 
	{
		if (block != NULL) 
		{
			NSError *theError = [NSError errorWithDomain:BBAccountManagerErrorDomain
													code:BBAccountManagerNotExistingError 
												userInfo:nil]; 
			theError = [NSError errorWithError:theError localizedDescription:@"The account does not exist"];
			block(NO, theError);
			return;
		}
	}
	
	[[instance mutableArrayValueForKey:@"accounts"] exchangeObjectAtIndex:theIndex withObjectAtIndex:defaultBBAccountIndex];
	
	if (block != NULL)
	{
		block(YES, nil);
	}
	
	[[self instance] persistAccountsIntoDataManager];
}

+ (id<BBAccount>) defaultAccount
{
    return [[self instance].accounts lastObject];
}

#pragma mark - Exchange position
+ (BOOL) exchangePositionOfAccount:(id<BBAccount>)theAccount withAccount:(id<BBAccount>)otherAccount
{
	NSUInteger theAccountPosition = [[self instance].accounts indexOfObject:theAccount];
	NSUInteger otherAccountPosition = [[self instance].accounts indexOfObject:otherAccount];
	if (theAccountPosition == NSNotFound || otherAccountPosition == NSNotFound) 
	{
		return NO;
	}
	
	[[[self instance] mutableArrayValueForKey:@"accounts"] exchangeObjectAtIndex:theAccountPosition withObjectAtIndex:otherAccountPosition];
	[[self instance] persistAccountsIntoDataManager];
	return YES;
}

+ (BOOL)moveAccount:(id<BBAccount>)theAccount atIndex:(NSUInteger)index
{
	if (index >= [[self instance].accounts count]) 
	{
		return NO;
	}
	
	NSUInteger theAccountPosition = [[self instance].accounts indexOfObject:theAccount];
	if (theAccountPosition == NSNotFound) 
	{
		return NO;
	}
	
	if (theAccountPosition == index)
	{
		return YES;
	}
	
	id obj = [[self instance].accounts objectAtIndex:theAccountPosition];
    [obj retain];
    [[[self instance] mutableArrayValueForKey:@"accounts"] removeObjectAtIndex:theAccountPosition];
	if (index >= [[self instance].accounts count]) 
	{
		[[[self instance] mutableArrayValueForKey:@"accounts"] addObject:obj];
    }
	else 
	{
        [[[self instance] mutableArrayValueForKey:@"accounts"] insertObject:obj atIndex:index];
	}
	[obj release];
    return YES;
}

#pragma mark - Private Methods
- (void) persistAccountsIntoDataManager
{
	if ([self.dataManager conformsToProtocol:@protocol(BBGMultiAccountDataManager)]) 
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSError *theError;
			if (![self.dataManager persistAccounts:self.accounts error:&theError]) 
			{
				@throw [NSException exceptionWithName:BBDataManagerPersistenceException
											   reason:@"Impossible to persist accounts into Data Manager"
											 userInfo:[theError userInfo]];
			}
		});
	}
}

- (void)restoreAccountsFromDataManager
{
	if ([self.dataManager conformsToProtocol:@protocol(BBGMultiAccountDataManager)]) 
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
			NSError *error = nil;
			NSArray *restoredAccounts = [self.dataManager restoreAccountsWithError:&error];
			if (restoredAccounts == nil && error != nil) {
				@throw [NSException exceptionWithName:BBDataManagerRestoreException 
											   reason:@"Impossible to restore existing accounts from Data Manager"
											 userInfo:[error userInfo]];
			}
			
			[self setAccounts:[NSMutableArray arrayWithArray:restoredAccounts]];
		});
	}
}

#pragma mark - Singleton

+ (BBGMultiAccountManager *)instance
{
    static dispatch_once_t dispatchOncePredicate;
    static BBGMultiAccountManager *myInstance = nil;
    
    dispatch_once(&dispatchOncePredicate, ^{
        myInstance = [[self alloc] init];
        myInstance.accounts = [NSMutableArray array];
    });
    
    return myInstance;
}

- (GTMOAuth2WindowController *)loginWindowController
{
	NSBundle *frameworkBundle = [NSBundle bundleForClass:[GTMOAuth2WindowController class]];
	GTMOAuth2WindowController *loginWindowController = [GTMOAuth2WindowController controllerWithScope:self.scope 
																							 clientID:self.clientID 
																						 clientSecret:self.clientSecret
																					 keychainItemName:nil 
																					   resourceBundle:frameworkBundle];
	// Resize login window so the user has not to scroll
//	NSRect frame = [[loginWindowController window] frame];
//	frame.size.height += 50;
//	[[loginWindowController window] setFrame:frame
//									 display:YES
//									 animate:YES];
//	[[loginWindowController window] center];
	
    return loginWindowController;
}

@end
