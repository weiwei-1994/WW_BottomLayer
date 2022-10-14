//
//  WWGCDController.m
//  xiaomage
//
//  Created by wyzeww on 2022/9/27.
//

#import "WWGCDController.h"

#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import <pthread.h>

@interface WWGCDController ()
{
    OSSpinLock _lock;
    os_unfair_lock _unfairLock;
    pthread_mutex_t _mutex;
    pthread_mutex_t _conditionalLcok;
    pthread_cond_t _condition;
    
    NSConditionLock * _nsConditionLock;
    
    dispatch_queue_t _lockQueue;
    dispatch_semaphore_t _lockSemphore;
    
    pthread_rwlock_t _rwLock;
}
@property(nonatomic,assign)int count;
@property(nonatomic,strong)NSMutableArray * array;

@end

@implementation WWGCDController

-(void)dealloc{
    pthread_mutex_destroy(&_mutex);
    pthread_mutex_destroy(&_conditionalLcok);
    pthread_cond_destroy(&_condition);
    pthread_rwlock_destroy(&_rwLock);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //初始化自旋锁
    _lock = OS_SPINLOCK_INIT;
    //初始化unfair_lock
    _unfairLock = OS_UNFAIR_LOCK_INIT;
    
    /**
            初始化互斥锁
     */
    //初始化attr
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    //设置attr
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    //初始化互斥锁
    pthread_mutex_init(&_mutex, &attr);
    //销毁attr
    pthread_mutexattr_destroy(&attr);
    
    /**
        初始化条件锁
     */

    pthread_mutex_init(&_conditionalLcok, NULL);
    pthread_cond_init(&_condition, NULL);
    
    /**
            初始化条件锁
     */
    _nsConditionLock = [[NSConditionLock alloc]initWithCondition:1];
    
    /**
        初始化串行队列
     */
    _lockQueue = dispatch_queue_create("lockQueue", DISPATCH_QUEUE_SERIAL);
    
    /**
        初始化信号量
     */
    _lockSemphore = dispatch_semaphore_create(1);
    
    
    /**
        初始化读写锁
     */
    pthread_rwlock_init(&_rwLock, NULL);
    
//    [self GCDQueue];
//    [self threadDeadlock];
//    [self GCDGroup];
//    [self threadSafe];
//    [self conditionalLock];
//    [self conditionLock2];
//    [self readAndWrite];
    [self readAndWrite1];
    // Do any additional setup after loading the view.
}

#pragma mark -- GCD 同步/异步 串行/并发的概念
-(void)GCDQueue{
    dispatch_queue_t concurrencyQueue = dispatch_get_global_queue(0, 0);
    dispatch_queue_t serialQueue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    
    /*同步串行行队列：没有开辟多线程的能力，在当前线程顺序执行*/
//    dispatch_sync(serialQueue, ^{
//        [self aa];
//    });
//
//    dispatch_sync(serialQueue, ^{
//        [self bb];
//    });
    
    /*同步并发行队列：没有开辟多线程的能力，在当前线程顺序执行*/
//    dispatch_sync(concurrencyQueue, ^{
//        [self aa];
//    });
//
//    dispatch_sync(concurrencyQueue, ^{
//        [self bb];
//    });
    
    /*异步串行行队列：开辟了一个多线程，在该线程内顺序执行*/
//    dispatch_async(serialQueue, ^{
//        [self aa];
//    });
//
//    dispatch_async(serialQueue, ^{
//        [self bb];
//    });
    
    /*异步并发行队列：开辟了多个多线程执行任务*/
//    dispatch_async(concurrencyQueue, ^{
//        [self aa];
//    });
//
//    dispatch_async(concurrencyQueue, ^{
//        [self bb];
//    });
}

-(void)aa{
    for (int i = 0; i < 5; i++) {
        NSLog(@"aa-----%@",[NSThread currentThread]);
    }
}

-(void)bb{
    for (int i = 0; i < 5; i++) {
        NSLog(@"bb-----%@",[NSThread currentThread]);
    }
}


#pragma mark -- 关于线程死锁的问题
-(void)threadDeadlock{
    /**情况1：任务1，2，3都在主线程的主队列里面相互等待，会造成死锁**/
//    NSLog(@"任务1");
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"任务2");
//    });
//    NSLog(@"任务3");
    
    /**情况2：任务1，3在主线程的主队列执行，任务2在主线程另一个队列里执行，两个队列不存在相互等待不会造成死锁**/
//    dispatch_queue_t serialQueue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
//    NSLog(@"任务1");
//    dispatch_sync(serialQueue, ^{
//        NSLog(@"任务2");
//    });
//    NSLog(@"任务3");
    
    /**情况3：任务1，3在主线程的主队列执行，任务2，4在多线程同一个并发队列里执行，并发队列不会相互等待不会死锁**/
//    dispatch_queue_t concurrencyQueue = dispatch_get_global_queue(0, 0);
//    NSLog(@"任务1");
//    dispatch_async(concurrencyQueue, ^{
//        NSLog(@"任务2");
//        dispatch_sync(concurrencyQueue, ^{
//            NSLog(@"任务4");
//        });
//    });
//    NSLog(@"任务3");
    
    /**总结：（1）使用async不会造成死锁 （2）使用sync如果任务在同一个线程，同一个串行队列里就会死锁**/
}

#pragma mark -- GCD group
-(void)GCDGroup{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 100; i++) {
            
        }
        NSLog(@"任务1 --- %@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 100000; i++) {
            
        }
        NSLog(@"任务2 --- %@",[NSThread currentThread]);
    });
    
    /**
            情况1：notify后直接回归主线程
     */
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"任务3 --- %@",[NSThread currentThread]);
//    });
    
    /**
            情况2：notify后继续异步执行
     */
    
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"任务3 --- %@",[NSThread currentThread]);
//    });
//
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"任务4 --- %@",[NSThread currentThread]);
//    });
}


#pragma mark -- 线程安全问题
-(void)threadSafe{
    
    self.count = 45;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
    
    for (int i = 0; i < 3; i++) {
        dispatch_group_async(group, queue, ^{
            for (int i = 0; i < 5; i++) {
                [self threadOperation];
            }
            
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"result --- %d",self.count);
    });
}

-(void)threadOperation{
    /**
            方案1：自旋锁
     */
//    OSSpinLockLock(&_lock);
//    [self countOperation];
//    OSSpinLockUnlock(&_lock);
    
    /**
            方案2：unfair_lock
     */
//    os_unfair_lock_lock(&_unfairLock);
//    [self countOperation];
//    os_unfair_lock_unlock(&_unfairLock);
    
    /**
            方案3：互斥锁
     */
//    pthread_mutex_lock(&_mutex);
//    [self countOperation];
//    pthread_mutex_unlock(&_mutex);
    
    /**
            方案4：串行队列
     */
//    dispatch_sync(_lockQueue, ^{
//        [self countOperation];
//    });
    
    /**
        方案5：信号量
     */
    dispatch_semaphore_wait(_lockSemphore, DISPATCH_TIME_FOREVER);
    [self countOperation];
    dispatch_semaphore_signal(_lockSemphore);
}

-(void)countOperation{
    sleep(1);
    self.count -= 1;
    NSLog(@"currentThresd%@ ---- %d",[NSThread currentThread],self.count);
}


#pragma mark -- 条件锁
-(void)conditionalLock{
    self.array = [[NSMutableArray alloc]init];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0; i < 5; i++) {
        dispatch_group_async(group, queue, ^{
            [self removeItem];
        });
    }
   
    for (int i = 0; i < 5; i++) {
        dispatch_group_async(group, queue, ^{
            [self addItem];
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"result --- %ld",self.array.count);
    });
}

-(void)addItem{
    pthread_mutex_lock(&_conditionalLcok);
    sleep(1);
    [self.array addObject:@"item"];
    NSLog(@"add --- %ld --- %@",self.array.count,[NSThread currentThread]);
    //通知线程条件满足
    pthread_cond_signal(&_condition);
    pthread_mutex_unlock(&_conditionalLcok);
}

-(void)removeItem{
    pthread_mutex_lock(&_conditionalLcok);
    sleep(1);
    if(self.array.count <= 0){
        //线程会先把锁解开，然后等待条件满足
        pthread_cond_wait(&_condition, &_conditionalLcok);
    }
    [self.array removeLastObject];
    NSLog(@"remove --- %ld --- %@",self.array.count,[NSThread currentThread]);
    pthread_mutex_unlock(&_conditionalLcok);
}

#pragma mark -- 条件锁：多线程同步+依赖
-(void)conditionLock2{
    self.array = [[NSMutableArray alloc]init];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_async(group, queue, ^{
        [self conditionOperation3];
    });
    
    dispatch_group_async(group, queue, ^{
        [self conditionOperation2];
    });
    
    dispatch_group_async(group, queue, ^{
        [self conditionOperation1];
    });

    
    dispatch_group_notify(group, queue, ^{
       
        NSLog(@"end --- %@",self.array);
    });
}

-(void)conditionOperation1{
    //只有满足lock内条件值才能加锁
    [_nsConditionLock lockWhenCondition:1];
    
    sleep(1);
    [self.array addObject:@"1"];
    NSLog(@"thread1");
    
    [_nsConditionLock unlockWithCondition:2];
}

-(void)conditionOperation2{
    [_nsConditionLock lockWhenCondition:2];
    
    sleep(1);
    [self.array addObject:@"2"];
    NSLog(@"thread2");
    
    [_nsConditionLock unlockWithCondition:3];
}

-(void)conditionOperation3{
    [_nsConditionLock lockWhenCondition:3];
    
    sleep(1);
    [self.array addObject:@"3"];
    NSLog(@"thread3");
    
    [_nsConditionLock unlock];
}


#pragma mark -- 多读单写 方案一：pthread_rwlock
-(void)readAndWrite{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    for (int i = 0 ; i < 5; i++) {
        dispatch_async(queue, ^{
            [self readOperation];
        });
    }
    
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            [self writeOperation];
        });
    }
    
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            [self readOperation];
        });
    }
}

-(void)readOperation{
    /**
            方案一：pthread_rwlock
     */
    pthread_rwlock_rdlock(&_rwLock);
    sleep(1);
    NSLog(@"read --- %@",[NSThread currentThread]);
    pthread_rwlock_unlock(&_rwLock);
}

-(void)writeOperation{
    /**
            方案一：pthread_rwlock
     */
    pthread_rwlock_wrlock(&_rwLock);
    sleep(1);
    NSLog(@"write --- %@",[NSThread currentThread]);
    pthread_rwlock_unlock(&_rwLock);
}

#pragma mark -- 多读单写 方案二：dispatch_barrier_async
-(void)readAndWrite1{
    dispatch_queue_t queue = dispatch_queue_create("rwLock", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0 ; i < 5; i++) {
        dispatch_async(queue, ^{
            [self readOperation1];
        });
    }
    
    for (int i = 0; i < 5; i++) {
        dispatch_barrier_async(queue, ^{
            [self writeOperation1];
        });
    }

    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            [self readOperation1];
        });
    }
}

-(void)readOperation1{
    sleep(1);
    NSLog(@"read --- %@",[NSThread currentThread]);
}

-(void)writeOperation1{
    sleep(1);
    NSLog(@"write --- %@",[NSThread currentThread]);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
