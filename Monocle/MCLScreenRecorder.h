#import <AVFoundation/AVFoundation.h>

#import "MCLCaptureAnimatedGifOutput.h"

@interface MCLScreenRecorder : NSObject

@property (strong) AVCaptureSession *captureSession;
@property (strong) AVCaptureScreenInput *captureInput;
@property (strong) MCLCaptureAnimatedGifOutput *captureOutput;

- (void)startRecording;
- (void)stopRecording;

@end
