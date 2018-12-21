#libmalloc-166.200.60之源码编译
为了便于我们更好的学习苹果的底层的内存的分配，所以将苹果的[官方libmalloc源码](https://opensource.apple.com/tarballs/libmalloc/)编译好以便我们能够更好的去动态调试。

<h3>说明：由于里面删除了好多的东西，并且注释了好多（也不知道有无影响），所以该方式仅供参考</h3>

---
集成思路见下：
准备工作：
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_28.png)

将绿色的3个压缩包解压到桌面libs文件夹里面（libs文件夹是自己创建的，这里随便啥名字都行，主要是为了接下来文件缺失，直接查找用的）

---
<h3>1.首先我们将下载好的压缩包解压，打开工程文件</h3>
<h3>2.删除不需要的target</h3>
如下：**除了libsystem_malloc的其他的都给删除掉**  
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_1.png)

<h3>3.删除如下的文件夹</h3>
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_2.png)

<h3>4.删除不需要的文件</h3>
在左下角搜索以下文件

```
replay、radix
```

<h3>5.开始编译</h3>
所遇到的问题如下

- 问题1:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_3.png)
   - 解决：在libs文件里面搜索：_simple.h（选择文件路径为libplatform-177.200.16里面的）
   - 拖入include根文件里面下,再配置文件路径
   ![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_4.png)

- 问题2:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_5.png)
  - 现在：在include文件下创建一个platform的文件夹
  - 再libs文件里面搜索：string.h，选择libplatform-177.200.16文件下的，拖入到刚刚创建的platform的文件夹内

- 问题3:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_6.png)
 - 解决的方法 类似问题2（注意 选择的的文件的路径）

- 问题4:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_7.png)
 - 解决（方法类似问题2） 创建mach-o文件夹，拖入所需的.h文件
 
- 问题5:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_8.png)
	- 在inclue文件夹下创建os文件夹、在os文件夹下创建internal文件夹，再将libs文件里面搜索到的internal_shared.h拖入到11·该文件夹下
- 问题6:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_9.png)
  - 解决：删除**“, bridgeos(3.0)”**
- 问题7:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_10.png)
  - 解决方法类似同上

- 问题8:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_11.png)
  - 解决方法类似同上（选择的文件路径为：os/internal下的）

- 问题9:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_12.png)
  - 解决方法类似同上（选择的文件路径为：os/internal下的）

- 问题10:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_13.png)
  - 解决方法类似同上

- 问题11:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_14.png)
  - 解决方法类似同上

- 问题12:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_15.png)
  - 解决方法类似同上

- 问题13:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_16.png)
  - 解决方法类似同上（创建 machine文件夹，拖入文件）
 
- 问题14:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_17.png)
发现缺少 **宏定义**   
见问题15

- 问题15:对于继续缺少的宏定义（这里我统一的加入到了missingDefines.h文件里）
  里面的内容：我是从cpu_capabilities.h文件里面找入的  
  文件路径：**xnu-4903.221.2/osfmk/arm/cpu_capabilities.h**
  在internal.h文件里面：顶部添加引入 #include "missingDefines.h"
  
-  问题16:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_18.png)
 -  解决：handle_msl_memory_event 、malloc_memory_event_handler 这2个函数 （将其注释掉）

-  问题17:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_19.png)
  -  解决：
  
  ```
  //注释掉下面的代码
  #if defined(__i386__) || defined(__x86_64__)
	if (_COMM_PAGE_VERSION_REQD > (*((uint16_t *)_COMM_PAGE_VERSION))) {
		MALLOC_REPORT_FATAL_ERROR((*((uint16_t *)_COMM_PAGE_VERSION)), "comm page version mismatch");
	}
#endif
  ```

-  问题18:
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_20.png)
  解决：删除nanov2_malloc.c、nanov2_malloc.h、nanov2_zone.h  将所有关于nanov2的缺失的.h文件都注释掉
-  问题19：
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_21.png)
 解决 ：
 - 1.
 
 ```
 //改为：
 void
_malloc_fork_child(void)
{
#if CONFIG_NANOZONE
	if (_malloc_initialize_pred) {
		{
			nano_forked_zone((nanozone_t *)inline_malloc_default_zone());
		}
	}
#endif
	return _malloc_reinit_lock_all(&__stack_logging_fork_child);
}
 ```
 
 - 2.
   ![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_22.png)
   
 - 3.
   ![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_23.png)
   该为：
   
   ```
   zone = nano_create_zone(helper_zone, malloc_debug_flags);
   ```
  - 4.
   ![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_24.png)

**到此：command+B 编译成功了**

总的所添加的文件结构：
 ![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_27.png)


----

我们来新建一个myTest的Target来测试一下：（配置如下）
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_25.png)
在main.m文件里面

```
#import <Foundation/Foundation.h>
#import <malloc/malloc.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
		char *m;
		m = (char *)(malloc(24)); //动态分配24个字节
		NSLog(@"所占大小%lu",malloc_size(m));//这里打印了32
    }
    return 0;
}
```
运行编译报错：
![](http://www.flyingdandelion.top/OCAsserts/libmalloc/libmalloc_26.png)
我们把这一行给注释掉

再次运行：在  

```
//打个断点
m = (char *)(malloc(24)); //动态分配24个字节
```
发现成功进入了malloc.c的文件里面（成功了）