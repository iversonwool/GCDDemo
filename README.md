# GCDDemo


1-》FourThreadMethod

1.pthread，NSThread 
    创建，启动， 创建完自动启动， 隐式创建， 常见的一些方法

2-》ThreadSafety
1.线程同步
    实质：为了防止多个线程抢夺同一块资源造成的数据安全问题
    实现：加互斥锁

3-》ThreadCommunication
    设置图片的两种方式
    线程之间的通信

    串行 并行 同步 异步的几种组合


# 延迟一定时间之后执行后续操作的方式
// 一定时间之后回到当前线程执行
1.[self performSelector:<#(nonnull SEL)#> withObject:<#(nullable id)#> afterDelay:<#(NSTimeInterval)#>]
    
2.dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(<#delayInSeconds#> * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
<#code to be executed after a specified delay#>
});

// dispatch_get_main_queue()也可以是全局队列

# 只执行一次的代码
1.static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
<#code to be executed once#>
});