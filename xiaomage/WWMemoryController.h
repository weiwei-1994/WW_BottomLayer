//
//  WWMemoryController.h
//  xiaomage
//
//  Created by wyzeww on 2022/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WWCopyObject : NSObject<NSCopying>

@property(nonatomic,copy)NSString * param1;
@property(nonatomic,strong)NSNumber * param2;
@property(nonatomic,assign)int param3;

@end

@interface WWMemoryController : UIViewController

@end

NS_ASSUME_NONNULL_END
