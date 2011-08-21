//
//  JBAppDelegate.m
//  HistoryMerger
//
//  Created by Jason Brennan on 11-08-16.
//  Copyright (c) 2011 Jason Brennan. All rights reserved.
//

#import "JBAppDelegate.h"

@implementation JBAppDelegate
@synthesize oldTextField = _oldTextField;
@synthesize theNewTextField = _theNewTextField;
@synthesize outputTextField = _outputTextField;
@synthesize progressSpinner = _progressSpinner;

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

- (IBAction)mergeButtonWasPressed:(NSButton *)sender {
	NSString *oldFile = [self.oldTextField stringValue];
	NSString *newFile = [self.theNewTextField stringValue];
	
	
	if (![oldFile length]) return;
	if (![newFile length]) return;
	
	
	NSString *outputFile = [[self.outputTextField stringValue] stringByAppendingPathComponent:@"Merged_History.plist"];
	
	
	[self.progressSpinner startAnimation:self];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
		// Read in the 2 plists
		NSLog(@"Going to merge... starting.");
		NSDate *currentDate = [NSDate date];
		NSDictionary *oldPlist = [NSDictionary dictionaryWithContentsOfFile:oldFile];
		NSMutableDictionary *newPlist = [NSMutableDictionary dictionaryWithContentsOfFile:newFile];
		
		NSString *historyKey = @"WebHistoryDates";
		
		//NSArray *mergedArray = [[oldPlist valueForKey:historyKey] arrayByAddingObjectsFromArray:[newPlist valueForKey:historyKey]];
		
		
		// Iterate over both arrays, nested, and match up any history items
		NSArray *oldHistoryArray = [oldPlist valueForKey:historyKey];
		NSArray *newHistoryArray = [newPlist valueForKey:historyKey];
		
		
		// Start it off with just the contents of the NEW history. Will merge in new items as needed.
		NSMutableArray *mergedArray = [NSMutableArray arrayWithArray:newHistoryArray];
		
		for (NSDictionary *oldHistoryItem in oldHistoryArray) {
			
			NSString *oldHistoryAddress = [oldHistoryItem valueForKey:@""];
			NSNumber *oldHistoryCount = [oldHistoryItem valueForKey:@"visitCount"];
			
			
			// now iterate over the new ones, see if it exists in there, and if so, add the counts together and break
			BOOL exists = NO;
			for (NSDictionary *newHistoryItem in newHistoryArray) {
				
				if (![[newHistoryItem valueForKey:@""] isEqualToString:oldHistoryAddress])
					continue;
				
				// It was equal. update its visit count with totals from the OLD history
				NSNumber *newHistoryCount = [newHistoryItem valueForKey:@"visitCount"];
				NSNumber *newTotalVisitCount = [NSNumber numberWithInteger:([oldHistoryCount integerValue] + [newHistoryCount integerValue])];
				
				[newHistoryItem setValue:newTotalVisitCount forKey:@"visitCount"];
				exists = YES;
				break;
				
			}
			
			
			if (!exists) {
				// the old history item was not a part of the NEW history file, so it needs to be added to that array now.
				[mergedArray addObject:oldHistoryItem];
			}
			
		}
		
		
		[newPlist setValue:mergedArray forKey:historyKey];
		
		
		
		
		
		// Write the newly merged file back out
		if (![newPlist writeToFile:outputFile atomically:YES]) {
			NSLog(@"There was an error writing the file back out to disk");
		}
		
		NSDate *finished = [NSDate date];
		
		NSLog(@"Finished. Took %f", [finished timeIntervalSinceDate:currentDate]);
		
		dispatch_sync(dispatch_get_main_queue(),^() {
			// Main Queue code
			[self.progressSpinner stopAnimation:self];
		});
		
	});
}

- (IBAction)theNewBrowseWasPressed:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
	
	[openPanel beginWithCompletionHandler:^(NSInteger result) {
		if (NSFileHandlingPanelOKButton == result) {
			[self.theNewTextField setStringValue:[[openPanel URL] path]];
		}
	}];
}

- (IBAction)oldBrowseWasPressed:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
	
	[openPanel beginWithCompletionHandler:^(NSInteger result) {
		if (NSFileHandlingPanelOKButton == result) {
			[self.oldTextField setStringValue:[[openPanel URL] path]];
		}
	}];
}

- (IBAction)outputDirBrowseWasPressed:(id)sender {
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseDirectories:YES];
	[openPanel setCanChooseFiles:NO];
	[openPanel setCanCreateDirectories:YES];
	[openPanel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
	
	[openPanel beginWithCompletionHandler:^(NSInteger result) {
		if (NSFileHandlingPanelOKButton == result) {
			[self.outputTextField setStringValue:[[openPanel URL] path]];
		}
	}];
}
@end
