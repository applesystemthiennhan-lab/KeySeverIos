#import <UIKit/UIKit.h>

@interface AuthSystem : NSObject
+ (void)showSuccessWithExpiry:(NSString *)expiry ip:(NSString *)ip;
+ (void)showError:(int)type;
+ (void)verifyKey:(NSString *)key;
@end
