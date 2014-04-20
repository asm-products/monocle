#include <Carbon/Carbon.h>
#import <MASShortcutView+UserDefaults.h>
#import <MASShortcut+UserDefaults.h>

#import "MCLAppDelegate.h"

NSString *const MCLStartSelectingScreenAreaKey = @"MCLStartSelectingScreenArea";

@implementation MCLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.screenRecorder = [MCLScreenRecorder new];
    self.screenAreaSelector = [MCLScreenAreaSelector new];

    MASShortcut *defaultShortcut = [MASShortcut shortcutWithKeyCode:kVK_ANSI_5 modifierFlags:NSCommandKeyMask|NSShiftKeyMask];
    [MASShortcut setGlobalShortcut:defaultShortcut forUserDefaultsKey:MCLStartSelectingScreenAreaKey];

    self.shortcutView.associatedUserDefaultsKey = MCLStartSelectingScreenAreaKey;

    [MASShortcut registerGlobalShortcutWithUserDefaultsKey:MCLStartSelectingScreenAreaKey handler:^{
        [self startSelectingScreenArea:nil];
    }];
}

- (IBAction)startRecording:(id)sender
{
    [self.screenRecorder startRecording];
}

- (IBAction)stopRecording:(id)sender
{
    [self.screenRecorder stopRecording];
}

- (IBAction)startSelectingScreenArea:(id)sender
{
    [self.screenAreaSelector startSelectingScreenArea];
}

- (IBAction)stopSelectingScreenArea:(id)sender
{
    [self.screenAreaSelector stopSelectingScreenArea];
}

@end
