//
//  main.m
//  myTest
//
//  Created by smile on 2018/12/21.
//

#import <Foundation/Foundation.h>
#import <malloc/malloc.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
		char *m;
		m = (char *)(malloc(24)); //动态分配24个字节
		NSLog(@"所占大小%lu",malloc_size(m));
    }
    return 0;
}
