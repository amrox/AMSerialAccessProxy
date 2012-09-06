//
//  AMSerialAccessProxy.h
//  AMSerialAccessProxy
//
//  Created by Andy Mroczkowski on 9/5/12.
//  Copyright (c) 2012 Andy Mroczkowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMSerialAccessProxy : NSProxy

- (id)initWithObject:(id)object;

@property (retain, readonly) id object;

- (void) performBlock:(dispatch_block_t)block;

@end