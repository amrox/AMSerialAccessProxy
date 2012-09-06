//
//  AMSerialAccessProxy.m
//  AMSerialAccessProxy
//
//  Created by Andy Mroczkowski on 9/5/12.
//  Copyright (c) 2012 Andy Mroczkowski. All rights reserved.
//

#import "AMSerialAccessProxy.h"

@interface AMSerialAccessProxy ()
@property (retain, readwrite) id object;
@property (assign, readwrite) dispatch_queue_t queue;
@end


@implementation AMSerialAccessProxy

@synthesize object = _object;
@synthesize queue = _queue;

- (id)initWithObject:(id)object
{
    _object = [object retain];
    _queue = dispatch_queue_create("net.mrox.serialaccessproxy", NULL);
    return self;
}

- (void)dealloc
{
    [_object release];
    dispatch_release(_queue);
    [super dealloc];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [(id)self.object methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation setTarget:self.object];
    
    if (dispatch_get_current_queue() == self.queue) {
        [anInvocation invoke];
    } else {
        __block typeof(self) blockself = self;
        dispatch_sync(blockself.queue, ^{
            [anInvocation invoke];
        });
    }
}

- (void) performBlock:(dispatch_block_t)block
{
    if (dispatch_get_current_queue() == self.queue) {
        block();
    } else {
        dispatch_sync(self.queue, block);
    }
}

@end
