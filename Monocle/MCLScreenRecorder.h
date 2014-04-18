#import <AVFoundation/AVFoundation.h>

@interface MCLScreenRecorder : NSObject <AVCaptureFileOutputDelegate, AVCaptureFileOutputRecordingDelegate>

@property (strong) AVCaptureSession *captureSession;
@property (strong) AVCaptureScreenInput *captureScreenInput;

- (IBAction)startRecording:(id)sender;
- (IBAction)stopRecording:(id)sender;

@end
