//
//  BBGMultiAccountManagerErrors.h
//  MACExample
//
//  Created by Giuseppe Basile on 22/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#define BBAccountManagerErrorDomain @"com.BBGMultiAccountManager.AccountManagerErrorDomain"
typedef enum {
	BBAccountManagerAlreadyPresentError		= 235,	//! The Account you are trying to add already exist
	BBAccountManagerNotExistingError		= 236,	//! The Account does not exist
} AccountManagerErrorTypeEnum;
