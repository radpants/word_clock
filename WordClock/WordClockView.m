//
//  WordClockView.m
//  WordClock
//
//  Created by AJ Austinson on 9/23/09.
//  Copyright (c) 2009, __MyCompanyName__. All rights reserved.
//

#import "WordClockView.h"


@implementation WordClockView

- (id)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
	self = [super initWithFrame:frame isPreview:isPreview];
    
	
	
	// create a new WebView
	if(isPreview==YES){
		// is the window being created as a preview
		NSRect previewFrame = NSMakeRect(0,0,347,256);
		web = [[WebView alloc]initWithFrame:previewFrame];
	}
	else{
		// or is it the actual screensaver
		web = [[WebView alloc]initWithFrame:frame];
	}
	NSString *path = @"http://radpants.com/word_clock/word_clock.html";
	//NSString *path = @"http://google.com";
	NSURL *url = [NSURL alloc];
	[url initWithString:path];
	NSURLRequest *request = [NSURLRequest alloc];
	[request initWithURL:url];
	[web.mainFrame loadRequest: request];
	
	[self addSubview:web];
	
	if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow*)configureSheet
{
	[NSBundle loadNibNamed:@"Preferences" owner:self];
	
    return preferencesSheet;
}
- (IBAction)cancelClick:(id)sender{
	[[NSApplication sharedApplication] endSheet:preferencesSheet];
}
- (IBAction)setPreferences:(id)sender{
	//set intro text
	//set night/day flag
	//set theme color
	//set theme text size
	//set weather flag
	//set zipcode
}

- (IBAction)updatePreview:(id)sender{
	//update text to show what things will look like
}

@end
