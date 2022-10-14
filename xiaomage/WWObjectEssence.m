//
//  WWObjectEssence.m
//  xiaomage
//
//  Created by wyzeww on 2022/8/5.
//

#import "WWObjectEssence.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

@implementation WWObjectEssence

+(void)ObjectEssence{
    NSObject * object = [[NSObject alloc]init];
    //获取NSObject实例对象的大小
    NSLog(@"NSObject >>>> %zd",class_getInstanceSize([NSObject class]));
    //获取object指针指向的内存空间的大小
    NSLog(@"NSObject >>>> %zd",malloc_size((__bridge const void *)object));

    Person * person = [[Person alloc]init];
    person.age = 10;
    NSLog(@"Person >>>> %zd",class_getInstanceSize([Person class]));
    NSLog(@"Person >>>> %zd",malloc_size((__bridge const void *)person));
    
    Student * student = [[Student alloc]init];
    student.age = 20;
    student.studentId = 10000;
    student.class = 1;
    NSLog(@"Student >>>> %zd",class_getInstanceSize([Student class]));
    NSLog(@"Student >>>> %zd",malloc_size((__bridge const void *)student));
}

@end

@implementation Person

@end

@implementation Student

@end

