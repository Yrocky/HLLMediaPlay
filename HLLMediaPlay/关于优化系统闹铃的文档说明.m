关于优化系统闹铃的文档

1.系统的闹铃有一个不友好的地方是要修改闹铃的时候需要点击左上角的edit，然后选择删除或者点击编辑，这个是很不舒适的，
要知道，在不进行编辑准态的时候点击闹铃是没有任何的反应的，只能选择是否开关闹铃，

	关于这个功能的优化，我的方案是
		点击edit就进行删除操作，点击没有任何响应，
		在不是edit模式下，点击进入修改模式


2.系统闹铃的添加新闹铃功能比较反人类，我觉得只要是右上角或者左上角的按钮点击都是反人类的操作，因为不一定每个人都能够得到那些按钮
所以这个添加新的闹铃功能需要优化的更加人性化一下，但是这些功能要在不影响系统闹铃的UI下进行，毕竟是一个优化项目，不是自己做一个闹铃App，

	关于这个功能的优化，我的方案是
		使用下拉刷新控件，下拉到一定的位置就添加一个新的闹铃，并进入编辑界面，没有到达一定位置就取消。


JavaScript在OC中的使用


/*
                                              <--- 使用JSVirtualMachine/script(NSString)创建
用于JS和OC之间的交互 <-- JSValue <-- JSContext |
                                              <--- init初始化，那么在其内部会自动创建一个新的JSVirtualMachine对象然后调用前边的初始化方法
 */
/*
 JSVirtualMachine为JavaScript的运行提供了底层资源，
 JSContext就为其提供着运行环境，通过- (JSValue *)evaluateScript:(NSString *)script;
 方法就可以执行一段JavaScript脚本，并且如果其中有方法、变量等信息都会被存储在其中以便在需要的时候使用。
 
    1.而JSContext的创建都是基于JSVirtualMachine：- (id)initWithVirtualMachine:(JSVirtualMachine *)virtualMachine;
    2.如果是使用- (id)init;进行初始化，那么在其内部会自动创建一个新的JSVirtualMachine对象然后调用前边的初始化方法。
 
 JSValue则可以说是JavaScript和Object-C之间互换的桥梁，它提供了多种方法可以方便地把JavaScript数据类型转换成Objective-C，或者是转换过去。
 */

1.基本数据的转换

	/*
	使用toSomeOCType将JS类型的数据转换成OC中的数据
	*/
	JSContext * yArray  = [[JSContext alloc] init];
    [yArray evaluateScript:@"var array = [20,'Hello world!'];"];
    JSValue * yValue = yArray[@"array"];
    NSLog(@"js:%@\nOC:%@",yValue,[yValue toArray]);
     
    /*
    outPut：
    js:20,Hello world!
    OC:(
	    20,
	    "Hello world!"
	)
	*/


2.OC中的Block在JS中的使用

	/*
	JSContext提供了类方法来获取参数列表
	+ (JSContext *)currentContext;
	和
	当前调用该方法的对象
	+ (JSValue *)currentThis;
	对于"this"，输出的内容是GlobalObject，这也是JSContext对象方法- (JSValue *)globalObject;所返回的内容。
	因为我们知道在JavaScript里，所有全局变量和方法其实都是一个全局变量的属性，
	*/
	JSContext * context = [[JSContext alloc] init];

    context[@"block"] = ^(){
        
        NSLog(@"开始block");
        
        NSArray * args = [JSContext currentArguments];// 返回的是参数数组
        for (JSValue * arg in args) {
            NSLog(@"arg:%@",arg);
        }
        
        JSValue * this = [JSContext currentThis];// 返回的是当前content的类型？
        NSLog(@"this:%@",this);

        NSLog(@"结束block");
    };
    [context evaluateScript:@"block('ider',[1,34],{hello:'world',js:100});"];
    // 这里的context[@"block"]必须要写在前面

    /*
    output:
    开始block
    arg:ider
    arg:1,34
    arg:[object Object]
    this:[object GlobalObject]
    结束block
    */


3.callWithArguments:(NSArray *)arguments方法的使用
	/*
	Block可以传入JSContext作方法，但是JSValue没有toBlock方法来把JavaScript方法变成Block在Objetive-C中使用。
	毕竟Block的参数个数和类型已经返回类型都是固定的。
	虽然不能把方法提取出来，但是JSValue提供了
	- (JSValue *)callWithArguments:(NSArray *)arguments;
	方法可以反过来将参数传进去来调用方法。
	*/

	JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:@"function add(a, b) { return a + b; }"];
    JSValue *add = context[@"add"];
    NSLog(@"Func: %@", add);
    
    JSValue *sum = [add callWithArguments:@[@(7), @(21)]];
    NSLog(@"Sum: %d",[sum toInt32]);
    //OutPut:
    // Func: function add(a, b) { return a + b; }
    // Sum: 28

    //使用callWithArguments:方法可以将函数的参数以数组的形似传递过去

4.invokeMethod:(NSString *)method withArguments:(NSArray *)arguments方法的使用

	/*
	JSValue还提供
	- (JSValue *)invokeMethod:(NSString *)method withArguments:(NSArray *)arguments;
	让我们可以直接简单地调用对象上的方法。
	只是如果定义的方法是全局函数，那么很显然应该在JSContext的globalObject对象上调用该方法；
	如果是某JavaScript对象上的方法，就应该用相应的JSValue对象调用。
	*/

5.异常处理

	/*
	Objective-C的异常会在运行时被Xcode捕获，
	而在JSContext中执行的JavaScript如果出现异常，只会被JSContext捕获并存储在exception属性上，而不会向外抛出。
	时时刻刻检查JSContext对象的exception是否不为nil显然是不合适，
	更合理的方式是给JSContext对象设置exceptionHandler，
	它接受的是^(JSContext *context, JSValue *exceptionValue)形式的Block。
	其默认值就是将传入的exceptionValue赋给传入的context的exception属性
	*/



