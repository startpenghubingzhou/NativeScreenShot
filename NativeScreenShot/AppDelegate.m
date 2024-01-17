//
//  AppDelegate.m
//  NativeScreenShot
//
//  Created by phbz on 2024/1/17.
//  Copyright © 2024 phbz. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    xpc_connection_t connectionObj;
    xpc_object_t dictobj;
    xpc_object_t arrayobj;
    xpc_object_t strobj;
    
    connectionObj = xpc_connection_create("com.apple.systemuiserver.screencapture", dispatch_get_main_queue());
    // Put this connection in a legacy mode
    xpc_connection_set_legacy(connectionObj);
    xpc_connection_set_event_handler(connectionObj, ^(xpc_object_t _Nonnull object){
        [self getMessage:object];
    });
    
    // Maybe create arguments to be sent
    dictobj = xpc_dictionary_create(NULL, nil, 0);
    xpc_dictionary_set_uint64(dictobj, "message", 1);
    arrayobj = xpc_array_create(NULL, 0);
    strobj = xpc_string_create("-uUpi");
    xpc_array_append_value(arrayobj, strobj);
    xpc_dictionary_set_value(dictobj, "args", arrayobj);
    xpc_connection_send_message_with_reply(connectionObj, dictobj, dispatch_get_main_queue(), ^(xpc_object_t _Nonnull object){
        [self handlePicture:object];
    });
    
    // Start the xpc connection task
    xpc_connection_resume(connectionObj);
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {

}

- (void)getMessage:(xpc_object_t _Nonnull)object {
    xpc_object_t obj; // rax
    xpc_type_t typeret; // rax
    xpc_type_t v5; // r14
    char* dbgstr; // r15
    const char* dictstr; // r14
    
    obj = object;
    typeret = xpc_get_type(obj);
    if (typeret == XPC_TYPE_ERROR)
    {
        dictstr = xpc_dictionary_get_string(obj, XPC_ERROR_KEY_DESCRIPTION);
        NSLog(@"screencapture XPC message error during setup: %s\n", dictstr);
    }
    else
    {
        dbgstr = xpc_copy_description(obj);
        if (dbgstr)
        {
            NSLog(@"screencapture XPC message error during setup - unknown XPC message type %p for connection handler: %@\n", v5, obj);
            free(dbgstr);
        }
    }
}

- (void)handlePicture:(xpc_object_t _Nonnull)object {
    xpc_object_t obj;
    xpc_type_t typeret;
    char* dbgstr;
    
    obj = object;
    typeret = xpc_get_type(obj);
    if (typeret == XPC_TYPE_ERROR)
    {
        NSLog(@"screencapture XPC message returned error: %s\n", xpc_dictionary_get_string(obj, XPC_ERROR_KEY_DESCRIPTION));
    }
    else
    {
        if (typeret != XPC_TYPE_DICTIONARY)
        {
            dbgstr = xpc_copy_description(obj);
            if (dbgstr)
            {
                NSLog(@"screencapture XPC message returned error - unknown XPC message type %p for reply: %@\n", dbgstr, typeret);
                free(dbgstr);
            }
        }
    }
    exit(0);
}

@end
