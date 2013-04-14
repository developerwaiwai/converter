//
//  AppDelegate.m
//  eventconverter
//
//  Created by waiwai on 13/04/13.
//  Copyright (c) 2013年 Android. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    
    NSURL* fileURL = [NSURL fileURLWithPath:@"/tmp/event.txt"];
    
    NSError* err = 0;
    NSString* fileContents = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:&err];
    
    NSArray* lines = [fileContents componentsSeparatedByString:@"\n"];
    NSMutableString* convertedFileContens = [NSMutableString stringWithCapacity:0];
    
    id line;
    for(line in lines)
    {
        NSArray* separated = [line componentsSeparatedByString:@" "];
        
        NSMutableString* converted = [NSMutableString stringWithCapacity:0];
        [converted appendString:@"./adb shell sendevent "];
        
        NSString* tmp = [separated objectAtIndex:0];
        if ([tmp isEqualToString:@""]) {
            break;
        }
        
        tmp = [tmp substringWithRange:NSMakeRange(0, 17)];
        [converted appendString:tmp];
        
        [converted appendString:[NSString stringWithFormat:@" %u", [self _calcText16bits:[separated objectAtIndex:1]]]];
        [converted appendString:[NSString stringWithFormat:@" %u", [self _calcText16bits:[separated objectAtIndex:2]]]];
        [converted appendString:[NSString stringWithFormat:@" %u\n", [self _calcText32bits:[separated objectAtIndex:3]]]];
        
        [convertedFileContens appendString:converted];
    }
    
    [convertedFileContens writeToFile:@"/tmp/event_c.txt" atomically:YES encoding:NSUTF8StringEncoding error:&err];
    
}

- (unsigned int)_convertCharToNum:(unichar)inChar baseNum:(unsigned int)inNum
{
    switch(inChar) {
        case '1':
            inNum += 1;
            break;
        case '2':
            inNum += 2;
            break;
        case '3':
            inNum += 3;
            break;
        case '4':
            inNum += 4;
            break;
        case '5':
            inNum += 5;
            break;
        case '6':
            inNum += 6;
            break;
        case '7':
            inNum += 7;
            break;
        case '8':
            inNum += 8;
            break;
        case '9':
            inNum += 9;
            break;
        case 'a':
            inNum += 10;
            break;
        case 'b':
            inNum += 11;
            break;
        case 'c':
            inNum += 12;
            break;
        case 'd':
            inNum += 13;
            break;
        case 'e':
            inNum += 14;
            break;
        case 'f':
            inNum += 15;
            break;
    }
    
    return inNum;
}

- (unsigned int)_calcText16bits:(NSString*)inString
{
    unsigned int num = 0;
    for(int i=0; i < 4; ++i)
    {
        num *= 16;
        
        unichar numString = [inString characterAtIndex:i];
        num = [self _convertCharToNum:numString baseNum:num];
    }
    return num;
}

- (int)_calcText32bits:(NSString*)inString
{
    int num = 0;
    for(int i=0; i < 8; ++i)
    {
        num *= 16;
        unichar numString = [inString characterAtIndex:i];
        num = [self _convertCharToNum:numString baseNum:num];
    }
    return num;
}

@end
