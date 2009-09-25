//
//  WordClockView.m
//  WordClock
//
//  Created by AJ Austinson on 9/23/09.
//  Copyright (c) 2009, __MyCompanyName__. All rights reserved.
//

#import "WordClockView.h"


@implementation WordClockView

static NSString * const MyModuleName = @"com.radpants.WordClock";
-refreshScreen{
	if(web){
		NSString *path = [[NSString alloc] initWithString:[@"http://radpants.com/word_clock/word_clock.html#" stringByAppendingString:params]];
		NSURL *url = [NSURL alloc];
		[url initWithString:path];
		
		NSURLRequest *request = [NSURLRequest alloc];
		[request initWithURL:url];
		[web.mainFrame loadRequest: request];
	}
}
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
	
	[[web preferences] setJavaScriptEnabled:YES];
	[[web preferences] setPrivateBrowsingEnabled:YES];
	
	// Set up preferences
	
	ScreenSaverDefaults *defaults;	
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];	
	[defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		@"NO", @"mentionWeather",
		@"NO", @"nightAndDay",
		@"", @"zipcode",
		@"Light", @"theme",
		@"Large", @"textSize",
		@"The time is", @"introText",
		@"", @"params",
		nil]];
	// ------------------
	
	
	
	[self addSubview:web];
	
	if (self) {
		params = [[NSString alloc] initWithString:[defaults stringForKey:@"params"]];
		
		[self refreshScreen];
		
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
	//[preview setStringValue:@"Testing..123."];
	
	ScreenSaverDefaults *defaults;
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
	
	//set intro text
	[introTextInput setStringValue: [[defaults stringForKey:@"introText"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	//set night/day flag
	[nightAndDayCheckbox setState: [defaults boolForKey:@"nightAndDay"]];
	//set theme color
	[themeSelector selectItemWithTitle: [defaults stringForKey:@"theme"]];
	//set theme text size
	[textSizeSelector selectItemWithTitle: [defaults stringForKey:@"textSize"]];
	//set weather flag
	[weatherCheckbox setState: [defaults boolForKey:@"mentionWeather"]];
	//set zipcode
	[zipCodeInput setStringValue: [defaults stringForKey:@"zipcode"]];
	
	if([nightAndDayCheckbox state]==NSOnState){
		// disable theme selector
		[themeSelector setEnabled:NO];
	}
	else{
		// enable theme selector
		[themeSelector setEnabled:YES];
	}
	
	if([weatherCheckbox state]==NSOnState){
		// enable zipcode input
		[zipCodeInput setEnabled:YES];
	}
	else{
		// disable zipcode input
		[zipCodeInput setEnabled:NO];
	}
	
    return preferencesSheet;
}

-updatePreviewText{
	if([weatherCheckbox state]==NSOnState){
		[preview setStringValue:[introText stringByAppendingString:@" a quarter past 9 in the evening, and it's 72 degrees out."]];
	}
	else{
		[preview setStringValue:[introText stringByAppendingString:@" a quarter past 9 in the evening."]];
	}	
}

- (IBAction)cancelClick:(id)sender{
	[[NSApplication sharedApplication] endSheet:preferencesSheet];
}
-(IBAction)changeWeatherValue:(id)sender{
	if([weatherCheckbox state]==NSOffState){
		[zipCodeInput setEnabled:NO];
	}
	else{
		[zipCodeInput setEnabled:YES];
	}
	[self updatePreviewText];
}
-(IBAction)changeNightAndDayValue:(id)sender{
	if([nightAndDayCheckbox state]==NSOffState){
		[themeSelector setEnabled:YES];
	}
	else{
		[themeSelector setEnabled:NO];
	}
	[self updatePreviewText];
}
- (IBAction)setPreferences:(id)sender{

	ScreenSaverDefaults *defaults;
	defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
	[defaults setBool:[weatherCheckbox state] forKey:@"mentionWeather"];
	[defaults setBool:[nightAndDayCheckbox state] forKey:@"nightAndDay"];	
	[defaults setObject:[[introTextInput stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"introText"];
	[defaults setObject:[zipCodeInput stringValue] forKey:@"zipcode"];
	[defaults setObject:[themeSelector titleOfSelectedItem] forKey:@"theme"];
	[defaults setObject:[textSizeSelector titleOfSelectedItem] forKey:@"textSize"];
	
	// create the params string
	
	introText = [[NSString alloc] initWithString:[[introTextInput stringValue] stringByReplacingOccurrencesOfString:@" " withString:@"\%20"]];
	
	params = [[NSString alloc] initWithFormat:@"introText=%@&weather=%@&zipcode=%@&nightAndDay=%@&defaultTheme=%@&textSize=%@", 
		[introText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
		([weatherCheckbox state] ? @"true" : @"false"),
		[zipCodeInput stringValue],
		([nightAndDayCheckbox state] ? @"true" : @"false"),
		[themeSelector titleOfSelectedItem],
		[textSizeSelector titleOfSelectedItem],
		nil];
	//NSRunAlertPanel(@"Test",params,@"okay",@"uhh",@"oh");
	
	// write the params
	[defaults setObject:params forKey:@"params"];
	
	// save preferences
	[defaults synchronize];
	[self refreshScreen];
	// close the preferences panel
	[[NSApplication sharedApplication] endSheet:preferencesSheet];
}

- (IBAction)updatePreview:(id)sender{
	introText = [introTextInput stringValue];
	[self updatePreviewText];
	//[preview setStringValue:[introTextInput stringValue]];
	//update text to show what things will look like
}

@end
