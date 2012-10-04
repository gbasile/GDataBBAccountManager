//
//  BBAppDelegate.m
//  GMultiAccountManager
//
//  Created by Giuseppe Basile on 05/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#import "BBAppDelegate.h"

#import "BBGMultiAccountManager.h"
#import "BBAccount.h"
#import "BBMultiAccountConfig.h"

@implementation BBAppDelegate
@synthesize accountsArrayController = _accountsArrayController;

@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [BBGMultiAccountManager registerWithClientId:kBBOAuthGoogleClientID
                                    clientSecret:kBBOAuthGoogleClientSecret
                                           scope:KBBOauthGoogleScope];
}


- (IBAction)addAccount:(id)sender {
	[BBGMultiAccountManager addAccountModalForWindow:[self window] withCompletionBlock:^(id<BBAccount> account, NSError *error) {
		if (error != nil) 
		{
			[self.window presentError:error];
		} else {
			NSLog(@"account added");
		}
    }];
}

- (IBAction)deleteAccount:(id)sender {
	BBAccount *theAccount = [[self.accountsArrayController selectedObjects] objectAtIndex:0];
	[BBGMultiAccountManager removeAccount:theAccount withCompletionBlock:^(BOOL success, NSError *error) {
		if (error != nil) 
		{
			[self.window presentError:error];
		} else {
			NSLog(@"account removed");
		}
	}];
}

- (IBAction)setAsDefaultButtonPressed:(id)sender
{
	BBAccount *theAccount = [[self.accountsArrayController selectedObjects] objectAtIndex:0];
    [BBGMultiAccountManager setDefaultAccount:theAccount withCompletionBlock:^(BOOL success, NSError *error) {
		if (error != nil) 
		{
			[self.window presentError:error];
		} else {
			NSLog(@"account marked as default");
		}
    }];
}

- (BBGMultiAccountManager *) multiAccountManager
{
	return [BBGMultiAccountManager instance];
}
@end
