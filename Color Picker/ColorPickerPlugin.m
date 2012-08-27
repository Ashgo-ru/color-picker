//
//  ColorPickerPlugin.m
//  Color Picker
//
//  Created by Joe Dakroub on 8/8/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "ColorPickerPlugin.h"
#import "CodaPlugInsController.h"

NSString * const kMenuItemTitle = @"Insert Color...";
NSString * const kPluginName = @"Color Picker";

@interface ColorPickerPlugin ()
{
    NSColorPanel *colorPanel;
    
    CodaPlugInsController *controller;
    CodaTextView *textView;    
}

- (id)initWithController:(CodaPlugInsController*)inController;

@end

@implementation ColorPickerPlugin

//2.0 and lower
- (id)initWithPlugInController:(CodaPlugInsController *)aController bundle:(NSBundle *)aBundle
{
    return [self initWithController:aController];
}

//2.0.1 and higher
- (id)initWithPlugInController:(CodaPlugInsController *)aController plugInBundle:(NSObject <CodaPlugInBundle> *)plugInBundle
{
    return [self initWithController:aController];
}

- (id)initWithController:(CodaPlugInsController *)inController
{
	if ( ! (self = [super init]))
        return nil;
    
    controller = inController;
    [controller registerActionWithTitle:NSLocalizedString(kMenuItemTitle, @"")
                  underSubmenuWithTitle:nil
                                 target:self
                               selector:@selector(showColorPanel:)
                      representedObject:self
                          keyEquivalent:@"^~@c"
                             pluginName:kPluginName];
    
	return self;
}

- (NSString *)name
{
	return kPluginName;
}

- (BOOL)validateMenuItem:(NSMenuItem *)aMenuItem
{
    BOOL result = YES;
	
	if ([aMenuItem title] == kMenuItemTitle)
	{
		CodaTextView *tv = [controller focusedTextView:self];
		
		if (tv == nil)
			result = NO;
	}
	
	return result;
}

- (void)showColorPanel:(id)sender
{
    textView = [controller focusedTextView:self];
    
    if (textView == nil)
        return;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeColor:) name:NSColorPanelColorDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panelDidClose:) name:NSWindowWillCloseNotification object:nil];
    
    colorPanel = [NSColorPanel sharedColorPanel];
    [colorPanel setContinuous:YES];
    [colorPanel setMode:NSRGBModeColorPanel];
    [colorPanel setShowsAlpha:YES];

    [colorPanel makeKeyAndOrderFront:self];
}

- (void)changeColor:(NSNotification *)note
{
    textView = [controller focusedTextView:self];
    
    if (textView == nil)
        return;

    NSString *colorValue = [[colorPanel color] CSSColor];
    NSRange currentRange = [textView selectedRange];
    NSRange newRange = NSMakeRange(currentRange.location, [colorValue length]);
    
    if (currentRange.length == 0)
    {
        [textView insertText:[[colorPanel color] CSSColor]];
    }
    else if (currentRange.length == newRange.length)
    {
        [textView replaceCharactersInRange:newRange withString:[[colorPanel color] CSSColor]];
    }
    else
    {
        [textView replaceCharactersInRange:currentRange withString:[[colorPanel color] CSSColor]];
    }
    
    [textView setSelectedRange:newRange];
}

- (void)panelDidClose:(NSNotification *)note
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSColorPanelColorDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowWillCloseNotification object:nil];
}

@end
