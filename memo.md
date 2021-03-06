# 多线程 Demo

[Demo](https://github.com/pennyworthit/iOS-ThreadDemo.git)

## NSThread

### 创建一个任务

创建任务

```objc
NSThread *purchaseA = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:customerA];
```

- 通过 `selector` 参数指定任务（一个方法）
- 通过 `object` 参数来指定任务的参数，对应地，任务方法需要修改其方法签名来接受参数
- `target` 在线程执行期间会被线程持有，即引用计数加一，当线程退出后，`target` 才会被释放

执行任务

```objc
[purchaseA start];
```

- 需要调用 `start` 方法，否则任务不会自动执行

## NSOperation

`NSOperation` 比 `NSThread` 更具可操作性
 
 - 可取消任务 `[anOperation cancel]`
 - 可设置优先级 `anOperation.queuePriority`
 - 可设置任务依赖 `[anOperation addDependency: xxx]`
 - 可通过 KVO 进行监听，可获知任务执行状态

系统提供两种 `NSOperation` 类型

- `NSInvocationOperation` 通过函数或方法来创建任务
- `NSBlockOperation` 通过 Block 来创建任务

### NSOperationQueue

更多地，`NSOperation` 将会与 `NSOperationQueue` 结合使用

同样，`NSOperationQueue` 也可以通过 KVO 进行监听

通过 `[self.operationQueue addOperations:operations waitUntilFinished:NO];` 可以一次添加多个任务，`waitUntilFinished` 用于指定是否阻塞当前线程，一般都是 `NO`

## 线程同步

### `NSLock` 线程同步

```objc
// 创建一把锁
self.lock = [[NSLock alloc] init];

// 加锁
[self.lock tryLock];

// 解锁
[self.lock unlock];
```

- 多个任务，若这多个任务需要修改到同一个数据，必须使用同一个 `NSLock` 进行加锁解锁，否则，数据状态不会统一
- 加锁与解锁，必须在同一个线程中进行，否则将出错或导致不可预知的行为
- 加锁的时候，使用 `tryLock` 方法，实际使用中，`lock` 方法并不是那么可靠

#### 线程与 RunLoop

线程需要挂靠在一个 RunLoop 下才能完整地完成任务

在 iOS 项目下，由于 iOS App 本身存在一个 RunLoop, 因此，如果 Demo 中的例子移植到 iOS 项目下跑，能够完整地完成

在命令行工具项目下，由于并不存在 RunLoop, 因此，程序将会从 `main.c` 中一股脑子向下执行，并且执行 `return 0;`. 而由于多线程的执行是异步的，任务其实也是可以进行，但是并不能确定任务执行的完整度，即任务在执行的半路中，程序已经退出了，因此，任务并没有完整地完成

于是，若要在命令行工具中，任务也能完成地完成，可以简单地在 `main.c` 的最后，`return 0;` 之上，添加一个死循环模拟 RunLoop, 当任务执行完成后，需要手动终止程序，否则 CPU 占用率会很高

```objc
// ...
while (YES) {};
return 0;
```

### `NSCondition` 线程同步

`NSCondition` 既是一个锁，也是一个检查点(checkpoint)

 - 即 `NSCondition` 内部含有一个类似 `NSLock` 的东西，用来保护数据的同步


使用 `NSCondition` 的正确方法

1. 为 condition 加锁
2. 测试一个条件，判断是否能执行任务
    - `false`, 不能执行任务，调用 `wait` 等方法阻塞当前线程，并循环检查条件
    - `true`, 可以执行任务
3. 有需要的话，更新任务执行的条件，并调用 `signal` 或 `boardcast` 方法发送信号
4. 为 condition 解锁

```objc
// 创建一个 condition
self.condiction = [[NSCondition alloc] init];

// 为 condition 加锁
[self.condiction lock];

// 为 condition 解锁
[self.condiction unlock];

// 阻塞当前线程，等待信号发出后继续执行
[self.condiction wait];

// 向 condition 发送信号，唤醒一个等待的线程来执行任务
[self.condiction signal];

// 向 condition 发送信号，唤醒所有等待的线程来执行任务
[self.condiction broadcast];
```


### `@synchronized` 线程同步

原理与 `NSLock` 相同，可以说是一个语法糖

注意事项

- `@synchronized` 会自动为 `@synchronized` 的 block 隐式添加异常处理，若在同步操作的过程中，发生异常，锁会被释放
- 对于使用 `@synchronized` 的对象，Runtime 会为其申请递归锁，并利用其内存地址，存储在一个哈希表中
- `@synchronized` 的 block 中，若对象被释放或者设置成了 `nil`, 好像也没什么事
- 向 `@synchronized` 中锁定一个 `nil` 值，可能会导致线程不安全的行为

[More than you want to know about @synchronized](http://rykap.com/objective-c/2015/05/09/synchronized/)

> 目前看来，`@synchronized` 在使用过程中，有较多暗坑，所以这里先不做理解了

