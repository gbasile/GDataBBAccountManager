//
//  BBAppDelegate.h
//  GMultiAccountManager
//
//  Created by Giuseppe Basile on 05/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BBGMultiAccountManager;

@interface BBAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (readonly) BBGMultiAccountManager *multiAccountManager;

@property (assign) IBOutlet NSArrayController *accountsArrayController;
- (IBAction)addAccount:(id)sender;
- (IBAction)deleteAccount:(id)sender;
- (IBAction)setAsDefaultButtonPressed:(id)sender;

@end
