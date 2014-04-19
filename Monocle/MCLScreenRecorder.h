#import <AVFoundation/AVFoundation.h>

#import "MCLCaptureAnimatedGifOutput.h"

@interface MCLScreenRecorder : NSObject

@property (strong) AVCaptureSession *captureSession;
@property (strong) AVCaptureScreenInput *captureInput;
@property (strong) MCLCaptureAnimatedGifOutput *captureOutput;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;

@end
