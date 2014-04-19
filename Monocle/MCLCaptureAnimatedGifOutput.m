#import "MCLCaptureAnimatedGifOutput.h"

@implementation MCLCaptureAnimatedGifOutput
{
    dispatch_queue_t queue;
    NSDictionary *imageProperties;
    NSDictionary *imageDestinationProperties;
}

- (id)initWithDestinationURL:(NSURL *)destinationURL
{
    if (self = [super init]) {
        queue = dispatch_queue_create("MCLCaptureAnimatedGifOutputQueue", DISPATCH_QUEUE_SERIAL);
        imageDestinationProperties = @{NSImageInterlaced: @NO, NSImageCompressionFactor: @1};

        self.frames = [NSMutableArray new];
        self.frameTimestamps = [NSMutableArray new];
        self.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
        self.destinationURL = destinationURL;

        [self setSampleBufferDelegate:self queue:queue];
    }

    return self;
}

- (void)compileFramesIntoImageDestinationAsync
{
    dispatch_async(queue, ^{
        [self compileFramesIntoImageDestination];
    });
}

- (void)compileFramesIntoImageDestination
{
    CGImageDestinationRef destination;

    @synchronized(self.frames) {
        destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)(self.destinationURL), kUTTypeGIF, [self.frames count], NULL);
        imageProperties = @{(NSString *)kCGImagePropertyGIFDictionary: @{(NSString *)kCGImagePropertyGIFDelayTime: [self averageFrameDelay]}};

        for (NSValue *encodedImage in self.frames) {
            CGImageRef image;
            [encodedImage getValue:&image];
            CGImageDestinationAddImage(destination, image, (__bridge CFDictionaryRef)(imageProperties));
            CGImageRelease(image);
        }
    }

    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)(imageDestinationProperties));
    CGImageDestinationFinalize(destination);

    CFRelease(destination);

    NSLog(@"Finish Generating GIF image");
}

- (void)addSampleBufferAsNextFrame:(CMSampleBufferRef)sampleBuffer
{
    CGImageRef image = [self imageFromSampleBuffer:sampleBuffer];
    NSValue *encodedImage = [NSValue valueWithBytes:&image objCType:@encode(CGImageRef)];
    CGImageRelease(image);

    @synchronized(self.frames) {
        NSLog(@"Adding image as frame %lu", [self.frames count] + 1);
        [self.frames addObject:encodedImage];
    }

    @synchronized(self.frameTimestamps) {
        double timestamp = CMTimeGetSeconds(CMSampleBufferGetPresentationTimeStamp(sampleBuffer));
        [self.frameTimestamps addObject:[NSNumber numberWithDouble:timestamp]];
    }
}

- (NSNumber *)averageFrameDelay
{
    NSNumber *start;
    NSNumber *average;

    @synchronized(self.frameTimestamps) {
        if ([self.frameTimestamps count] == 0) {
            return @(0);
        }

        start = self.frameTimestamps[0];
        average = [self.frameTimestamps valueForKeyPath:@"@avg.doubleValue"];
    }

    return [NSNumber numberWithDouble:average.doubleValue - start.doubleValue];
}

- (CGImageRef)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);

    CVPixelBufferLockBaseAddress(imageBuffer, 0);

    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);

    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);

    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return CGImageRetain(quartzImage);
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"Dropped frame!");
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CFRetain(sampleBuffer);

    dispatch_async(queue, ^{
        [self addSampleBufferAsNextFrame:sampleBuffer];
        CFRelease(sampleBuffer);
    });
}

@end
