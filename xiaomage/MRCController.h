//
//  MRCController.h
//  xiaomage
//
//  Created by wyzeww on 2022/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WWAA : NSObject

@end

@interface WWMRCSubordinateClass : NSObject

-(void)run;

@end

@interface WWMRCHolderClass : NSObject
{
    WWMRCSubordinateClass * _subordinateClass;
}

//在MRC下使用retain关键字，编译器会自动生成set/get方法，在set方法内会自动retain
@property(nonatomic,retain)WWAA * aa;

@end

@interface MRCController : UIViewController

@end

NS_ASSUME_NONNULL_END
