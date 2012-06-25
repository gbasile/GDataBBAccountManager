//
//  BBGMultiAccountFileManager.h
//  GMultiAccountManager
//
//  Created by Giuseppe Basile on 19/05/12.
//  Copyright (c) 2012 Archy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBGMultiAccountManager.h"

@interface BBGMultiAccountFileManager : NSObject <BBGMultiAccountDataManager>
+ (id)fileManager;
@end
