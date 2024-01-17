//
//  AppDelegate.h
//  NativeScreenShot
//
//  Created by phbz on 2024/1/17.
//  Copyright © 2024 phbz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <xpc/xpc.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

/* No more information about this internal function except in
   https://github.com/avaidyam/DIYAnimation/wiki/XPC-Internals,
   need to be digged more. */

extern void xpc_connection_set_legacy(xpc_connection_t connection);

@end

