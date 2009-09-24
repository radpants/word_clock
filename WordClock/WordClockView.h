//
//  WordClockView.h
//  WordClock
//
//  Created by AJ Austinson on 9/23/09.
//  Copyright (c) 2009, __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <WebKit/WebKit.h>

@interface WordClockView : ScreenSaverView 
{
	WebView *web;
	
	IBOutlet id preferencesSheet;
	
	IBOutlet NSTextField *preview;
}

-(IBAction)updatePreview:(id)sender;
-(IBAction)setPreferences:(id)sender;
-(IBAction)cancelClick:(id)sender;

//@property (nonatomic, retain) NSTextField *preview;
@end
