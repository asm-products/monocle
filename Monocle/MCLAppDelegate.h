#import <Cocoa/Cocoa.h>

#import "MCLScreenRecorder.h"

@interface MCLAppDelegate : NSObject <NSApplicationDelegate>

@property (strong) MCLScreenRecorder *screenRecorder;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;

@end
