//
//  WWObjectEssence.h
//  xiaomage
//
//  Created by wyzeww on 2022/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property(nonatomic,assign)int age;

@end


@interface Student : Person

@property(nonatomic,assign)int studentId;
@property(nonatomic,assign)int class;

@end

//Object对象本质
@interface WWObjectEssence : NSObject

@end




NS_ASSUME_NONNULL_END
