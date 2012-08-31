//
//  NSColor+NSColorHexadecimalValue.m
//  Color Picker
//
//  Created by Joe Dakroub on 8/8/12.
//  Copyright (c) 2012 Joe Dakroub. All rights reserved.
//

#import "NSColor+NSColorHexadecimalValue.h"

@implementation NSColor (NSColorHexadecimalValue)


-(NSString *)CSSColor
{
    CGFloat redFloatValue, greenFloatValue, blueFloatValue, alphaFloatValue;
    int redIntValue, greenIntValue, blueIntValue;
    NSString *redHexValue, *greenHexValue, *blueHexValue;
    
    //Convert the NSColor to the RGB color space before we can access its components
    NSColor *convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    if (convertedColor)
    {
        // Get the red, green, blue, and alpha components of the color
        [convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:&alphaFloatValue];
        
        // Convert the components to numbers (unsigned decimal integer) between 0 and 255
        redIntValue = redFloatValue * 255.99999f;
        greenIntValue = greenFloatValue * 255.99999f;
        blueIntValue = blueFloatValue * 255.99999f;
        
        // Return RGBA color value
        if (alphaFloatValue != 1)
        {
            return [NSString stringWithFormat:@"rgba(%i, %i, %i, %.02f)", redIntValue, greenIntValue, blueIntValue, alphaFloatValue];
        }
        // Return HEX value
        else
        {
            redHexValue = [NSString stringWithFormat:@"%02x", redIntValue];
            greenHexValue = [NSString stringWithFormat:@"%02x", greenIntValue];
            blueHexValue = [NSString stringWithFormat:@"%02x", blueIntValue];
            
            return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];            
        }
    }
    
    return nil;
}

@end
