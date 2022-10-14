//
//  WWAliveThread.h
//  xiaomage
//
//  Created by wyzeww on 2022/9/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WWThread : NSThread

@end

@interface WWAliveThread : NSObject

/**
 创建保活线程
 */

-(instancetype)initAliveThread;

/**
 在保活线程中执行方法
 target：方法调用者
 selector：方法签名
 arg：参数
 */
-(void)excuteWithTarget:(id)target selector:(SEL)selector object:(nullable id)arg;

/**
 销毁报活线程：需手动调用kill方法否则会有内存问题！！！
 */
-(void)killTheThread;

@end

NS_ASSUME_NONNULL_END
