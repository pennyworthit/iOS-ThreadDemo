# ThreadingDemo

## BusinessSyncWithLock

使用 `NSLock` 进行线程同步

`customerA` 与 `customerB` 竞争抓取同一个数组 `production` 中的元素，`production` 中的元素一开始固定不变

## BusinessSyncWithCondition

使用 `NSCondition` 进行线程同步

`customerA`, `customerB`, `customerC` 竞争抓取同一个数组 `production` 中的元素，`production` 中的元素会动态发生变化，当元素个数小于一定数目时，自动生成

