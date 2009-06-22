//
//  MyController.m
//  cocolua
//
//  Created by Mikhail Kalugin on 6/23/09.
//  Copyright 2009 YourSway. All rights reserved.
//

#import "MyController.h"


@implementation MyController

- (IBAction)doItButtonClicked:(id)sender {
	NSBundle * bundle = [NSBundle bundleForClass:[MyController class]];
	NSString * scriptPath = [bundle pathForResource:@"script" ofType:@"lua"];
	if (!scriptPath) {
		[textView setString:@"Failed to get script's path."];
		return;
	}
	[textView setString:scriptPath];
}

@end
