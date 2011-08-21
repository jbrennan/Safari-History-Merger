//
//  JBAppDelegate.h
//  HistoryMerger
//
//  Created by Jason Brennan on 11-08-16.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JBAppDelegate : NSObject <NSApplicationDelegate> {
	NSTextField *_oldTextField;
	NSTextField *_theNewTextField;
	NSTextField *_outputTextField;
	NSProgressIndicator *_progressSpinner;
}


@property (strong) IBOutlet NSWindow *window;

- (IBAction)mergeButtonWasPressed:(NSButton *)sender;
- (IBAction)theNewBrowseWasPressed:(id)sender;
- (IBAction)oldBrowseWasPressed:(id)sender;
- (IBAction)outputDirBrowseWasPressed:(id)sender;
@property (strong) IBOutlet NSTextField *oldTextField;
@property (strong) IBOutlet NSTextField *theNewTextField;
@property (strong) IBOutlet NSTextField *outputTextField;
@property (strong) IBOutlet NSProgressIndicator *progressSpinner;
@end
