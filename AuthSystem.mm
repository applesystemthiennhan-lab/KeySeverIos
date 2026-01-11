#import "AuthSystem.h"

@implementation AuthSystem

+ (void)showSuccessWithExpiry:(NSString *)expiry ip:(NSString *)ip {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = @"Đăng nhập thành công";
        NSString *msg = [NSString stringWithFormat:@"Hạn sử dụng : %@\nIP: %@", expiry, ip];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.30 green:0.85 blue:0.39 alpha:1.0] range:NSMakeRange(0, title.length)];
        [alert setValue:attrTitle forKey:@"attributedTitle"];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Đóng" style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

+ (void)showError:(int)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = @"❌ KEY không hợp lệ";
        NSString *msg = (type == 1) ? @"Vui lòng kiểm tra lại Key.\n(Ứng dụng sẽ văng sau 5s)" : @"Key Hết Hạn! Hãy Liên Hệ Admin Để Gia Hạn!\n(Ứng dụng sẽ văng sau 5s)";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
        [attrTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0] range:NSMakeRange(0, title.length)];
        [alert setValue:attrTitle forKey:@"attributedTitle"];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ exit(0); });
        }];
    });
}

+ (void)verifyKey:(NSString *)key {
    NSString *apiUrl = [NSString stringWithFormat:@"http://getudidv3.2bd.net/check_key.php?key=%@", key];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiUrl]];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *res, NSError *err) {
        if (data) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([json[@"status"] isEqualToString:@"success"]) {
                [self showSuccessWithExpiry:json[@"expiry"] ip:json[@"ip"]];
            } else if ([json[@"status"] isEqualToString:@"expired"]) {
                [self showError:2];
            } else {
                [self showError:1];
            }
        }
    }] resume];
}
@end
