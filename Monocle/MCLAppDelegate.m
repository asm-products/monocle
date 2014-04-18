#import "MCLAppDelegate.h"

@implementation MCLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.screenRecorder = [MCLScreenRecorder new];
}

- (IBAction)startRecording:(id)sender
{
    [self.screenRecorder startRecording:sender];
}

- (IBAction)stopRecording:(id)sender
{
    [self.screenRecorder stopRecording:sender];
}

@end
