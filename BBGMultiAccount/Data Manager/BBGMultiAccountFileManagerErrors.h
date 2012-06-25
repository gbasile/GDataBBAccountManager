//
//  BBGMultiAccountFileManagerErrors.h
//  MACExample
//
//  Created by Giuseppe Basile on 22/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#define BBDataManagerErrorDomain @"com.BBGMultiAccountManager.DataManagerErrorDomain"
typedef enum {
	BBDataManagerPersistError				= 984,	//! Error while persisting data
	BBDataManagerRestoreError				= 985,	//! Error while restoring data
} DataManagerErrorTypeEnum;