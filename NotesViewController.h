//
//  NotesViewController.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotesViewController;

@protocol NotesViewControllerDelegate

- (void)notesViewControllerDone:(NotesViewController *)controller;

@end



@interface NotesViewController : UIViewController <UITextViewDelegate> {
	IBOutlet UITextView *textView;
	NSString *text;
	
	id <NotesViewControllerDelegate> delegate;
}

@property (retain) IBOutlet UITextView *textView;
@property (retain) NSString *text;
@property (assign) id <NotesViewControllerDelegate> delegate;

@end
