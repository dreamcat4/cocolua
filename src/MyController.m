//
//  MyController.m
//  cocolua
//
//  Created by Mikhail Kalugin on 6/23/09.
//  Copyright 2009 YourSway. All rights reserved.
//

#import "MyController.h"
#import "LuaObjCBridge.h"

@interface MyController ()

- (NSString*)runScript:(NSString*)scriptPath withArgument:(NSString*)data;
- (void)acceptResult:(NSObject*)result;

@end


@implementation MyController

- (id) init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}


- (IBAction)doItButtonClicked:(id)sender {
	NSBundle * bundle = [NSBundle bundleForClass:[MyController class]];
	NSString * scriptPath = [bundle pathForResource:@"script" ofType:@"lua"];
	if (!scriptPath) {
		[textView setString:@"Failed to get script's path."];
		return;
	}
	scriptResult = @"Script hasn't set anything.";
	NSString * runResult = [self runScript:scriptPath withArgument:[textView string]];
	[textView setString:[NSString stringWithFormat:@"Run result: %@\nScript result: %@\n", runResult, (scriptPath?[scriptResult description]:@"nil")]];
}

- (NSString*)runScript:(NSString*)scriptPath withArgument:(NSString*)data {
	NSString * result = nil;
	
	// Set up a Lua interpreter
	lua_State* interpreter;
	interpreter=lua_objc_init(); // interpreter is now available for all lua_* function calls.
	
	// Pass input parameters into Lua
	lua_objc_pushpropertylist( interpreter, data );
	lua_setglobal( interpreter, "argument" );        // This will be the name in Lua
	
	lua_objc_pushid(interpreter, self);	
	lua_setglobal(interpreter, "resultAcceptor");
	
	// Use Lua to run a script
	luaL_dofile( interpreter, [ scriptPath UTF8String ] );
	
	// Get the error status
	char *luaError = (char *)lua_tostring(interpreter, -1);
	
	if( luaError != NULL )
	{
		// Error has occured so return the information
		result = [ NSString stringWithCString: luaError ];
	}
	else
	{
		// No error so get the return values
		lua_getglobal( interpreter, "result" );   // Name in Lua
		
		// Check that the return value is an NSString or derived class
		if( [ lua_objc_topropertylist( interpreter, 1 ) isKindOfClass: [ NSString class ] ] )
		{
			// Copy the string here because the original will be lost when the Lua
			// interpreter instance is closed
			result = [ lua_objc_topropertylist( interpreter, 1 ) 
					  mutableCopyWithZone: nil ];
		}
		else
		{
			// Display an error message
			result = @"Invalid class type returned";
		}
	}
	
	//Stop the Lua interpreter
	lua_close(interpreter);                    
	
	return result;
}

- (void)acceptResult:(NSObject*)result {
	scriptResult = result;
}

@end
