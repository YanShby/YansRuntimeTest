//
//  main.m
//  YansRuntime
//
//  Created by Yans on 16/7/20.
//  Copyright © 2016年 Yans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/objc-runtime.h>
void singSong(id self, SEL _cmd) {
    NSLog(@"%@正在唱%@",object_getIvar(self, class_getInstanceVariable([self class], "_singer")),[self valueForKey:@"_name"]);
}
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, runtime!");
        ///创建一个继承NSObject的YansMusic类
        Class YansMusic = objc_allocateClassPair([NSObject class], "YansMusic", 0);
        ///增加NSString *name和NSString *singer两个成员变量
        class_addIvar(YansMusic, "_name", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        class_addIvar(YansMusic, "_singer", sizeof(NSString *), log2(sizeof(NSString *)), @encode(NSString *));
        ///注册为singASong的方法名
        SEL sing = sel_registerName("singASong:");
        ///为YansMusic类增加名为singASong的方法
        class_addMethod(YansMusic, sing, (IMP)singSong, "v@:@");
        ///注册YansMusic类
        objc_registerClassPair(YansMusic);
        ///创建一个实例
        id musician = [YansMusic new];
        ///为musician这个实例的成员name赋值
        Ivar nameIvar = class_getInstanceVariable(YansMusic, "_name");
        object_setIvar(musician, nameIvar, @"I Knew You Were Trouble");
        ///为musician这个实例的成员singer赋值
        Ivar singerName = class_getInstanceVariable(YansMusic, "_singer");
        object_setIvar(musician, singerName, @"Taylor Swift");
        ///执行sing(名为 singASong)的方法
        ((void (*)(id, SEL))objc_msgSend)(musician,sing);
        ///如果实例存在,不能直接销毁类,所以首先置为nil
        musician = nil;
        ///销毁YansMusic类
        objc_disposeClassPair(YansMusic); 
        
    }
    return 0;
}
