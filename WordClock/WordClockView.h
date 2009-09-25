//
//  WordClockView.h
//  WordClock
//
//  Created by AJ Austinson on 9/23/09.
//  Copyright (c) 2009, __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>
#import <WebKit/WebKit.h>
#import <AppKit/AppKit.h>

@interface WordClockView : ScreenSaverView 
{
	WebView *web;
	
	IBOutlet id preferencesSheet;
	
	IBOutlet NSTextField *introTextInput;
	IBOutlet NSButton *weatherCheckbox;
	IBOutlet NSTextField *zipCodeInput;
	IBOutlet NSButton *nightAndDayCheckbox;
	IBOutlet NSPopUpButton *themeSelector;
	IBOutlet NSPopUpButton *textSizeSelector;
	IBOutlet NSTextField *preview;
	
	Boolean mentionWeather;
	Boolean nightAndDay;
	NSString *theme;
	NSString *textSize;
	NSString *zipCode;
	NSString *introText;
	NSString *params;
}
-refreshScreen;
-updatePreviewText;
-(IBAction)updatePreview:(id)sender;
-(IBAction)changeWeatherValue:(id)sender;
-(IBAction)changeNightAndDayValue:(id)sender;
-(IBAction)setPreferences:(id)sender;
-(IBAction)cancelClick:(id)sender;

//@property (nonatomic, retain) NSTextField *preview;
@end
