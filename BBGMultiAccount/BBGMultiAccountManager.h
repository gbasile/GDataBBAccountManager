//
//  BBGMultiAccountManager.h
//  GMultiAccountManager
//
//  Created by Giuseppe Basile on 05/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BBDataManagerPersistenceException @"BBDataManagerPersistenceException"
#define BBDataManagerRestoreException @"BBDataManagerRestoreException"

@protocol BBAccount;

@protocol BBGMultiAccountDataManager <NSObject>

//! Restore the list of accounts.
//! @param error	Error reference
//! @return			NSArray or nil if an error occours
- (NSArray *)restoreAccountsWithError:(NSError **)error;

//! Persist the list of accounts.
//! @param accounts	The list of accounts
//! @param error	Error reference
//! @return			YES if operations works
- (BOOL)persistAccounts:(NSArray *)accounts error:(NSError **)error;
@end

@protocol BBGMultiAccountManager <NSObject>
+ (NSArray *)accounts;
+ (id<BBAccount>)defaultAccount;
@end

@interface BBGMultiAccountManager : NSObject <BBGMultiAccountManager>

//! A shared instance of the account manager
+ (BBGMultiAccountManager *)instance;

//!	Mandatory! Set the Google Parameters necessary 
//!	to login against your application. 
//! Remember to config BBGMultiAccountConfig.h with your data
+ (void)register;

//!	Mandatory! Set the Google Parameters necessary 
//! @param dataManager  The Manager will store/restore the accounts data.
//! Remember to config BBGMultiAccountConfig.h with your data
+ (void)registerWithDataManager:(id<BBGMultiAccountDataManager>)dataManagerOrNil;

//!	Start the procedures to authenticate your application
//!	against the scopes
+ (void)addAccount;

//!	Start the procedures to authenticate your application
//!	against the scopes
//! @param parentWindowOrNil    The window when show the modal login
+ (void)addAccountWithModalWindow:(NSWindow *)parentWindowOrNil;

//!	Start the procedures to authenticate your application showing login window
//! as sheet for provided window
//! @param window A modal window (can be nil).
//!	@param block	Completion block
+ (void)addAccountWithModalWindow:(NSWindow *)window completionBlock:(void (^)(id<BBAccount> account, NSError *error))block;

//!	Return the list of existing account
//!	@param block	Completion block
+ (void)accountsWithCompletionBlock:(void (^)(NSArray *accounts, NSError *error))block;

//!	Remove the provided Account, if exist.
//!	@param account	The account to delete
+ (void)removeAccount:(id<BBAccount>)account;

//!	Remove the provided Account, if exist.
//!	@param account	The account to delete
//!	@param block	Completion block
+ (void)removeAccount:(id<BBAccount>)account withCompletionBlock: (void (^)(BOOL success, NSError *error))block;

//!	Set this account as default. 
//!	NB: only one account can be the default. The default account
//! is the one at position defaultBBAccountIndex
//!	@param account	The account to mark as principal
+ (void)setDefaultAccount:(id<BBAccount>)account;

//!	Set this account as default.
//!	NB: only one account can be the default. The default account
//! is the one at position defaultBBAccountIndex
//!	@param account	The account to mark as principal
//!	@param block	Completion block
+ (void)setDefaultAccount:(id<BBAccount>)account withCompletionBlock:(void (^)(BOOL success, NSError *error))block;

//! Return the default account or nil
//! @return		the default account or nil
+ (id<BBAccount>)defaultAccount;

//! Exchange account position with another one
//! @param theAccount the first account
//! @param theAccount the second account
//! @return Whenever the action success or fail
+ (BOOL)exchangePositionOfAccount:(id<BBAccount>)theAccount withAccount:(id<BBAccount>)otherAccount;

//! Move the related account to a new position
//! @param	theAccount	The account to move
//! @param	index		The new position
//! @return		Whenever the action success or fail
+ (BOOL)moveAccount:(id<BBAccount>)theAccount atIndex:(NSUInteger)index;

//! Return the array of accounts
//! @return		the accounts array
+ (NSArray *)accounts;

@end
