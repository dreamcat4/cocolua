//
//  MyController.h
//  cocolua
//
//  Created by Mikhail Kalugin on 6/23/09.
//  Copyright 2009 YourSway. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyController : NSObject {
	IBOutlet NSTextView * textView;
}

- (IBAction)doItButtonClicked:(id)sender;

@end
