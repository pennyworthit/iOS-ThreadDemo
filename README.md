# ThreadingDemo

## BusinessSyncWithLock

使用 `NSLock` 进行线程同步

`customerA` 与 `customerB` 竞争抓取同一个数组 `production` 中的元素，`production` 中的元素一开始固定不变

## BusinessSyncWithCondition

使用 `NSCondition` 进行线程同步

`customerA`, `customerB`, `customerC` 竞争抓取同一个数组 `production` 中的元素，`production` 中的元素会动态发生变化，当元素个数小于一定数目时，自动生成

## BusinessOperation

使用 `NSOperation` 与 `NSOperationQueue`, 用 `NSLock` 进行线程同步

`customerA1`, `customerA2`, `customerA3`, `customerB`, `customerC` 一起对 `production` 中的元素进行获取

demo 逻辑

- `production` 中包含 100 个元素，从小到大排列，并通过出栈的方式将元素提供给 `customerXX`
- `customerA1`, `customerA2`, `customerA3` 分别获取 6, 8, 10 个元素后便停止，结束各自的任务，剩下的元素由 `customerB` 和 `customerC` 进行获取
- 优先级
  - `customerA1` -> `NSOperationQueuePriorityNormal`
  - `customerA2` -> `NSOperationQueuePriorityHigh`
  - `customerA3` -> `NSOperationQueuePriorityVeryHigh`
  - `customerB` -> `NSOperationQueuePriorityLow`
  - `customerC` -> `NSOperationQueuePriorityLow`
- 依赖
  - `customerB`, `customerC` 都依赖 `customerA2`，即等到 `customerA2` 任务结束后，`customerB` 和 `customerC` 才会开始任务
- 每个任务结束后都会打印各自获取到的元素
- 同时，使用监听 `NSOperationQueue` 的属性 `operation`, 当任务全部执行完后，即 `operations.count == 0` 时，将会输出提示

结果

- 多次运行后，可以看到 `customerA3`, `customerA2` 总是会取得比较大的元素
- `customerA1`, `customerA2`, `customerA3` 获得的元素个数符合预期
- `customerB`, `customerC` 获取了剩下的元素，所以包含的个数较多

