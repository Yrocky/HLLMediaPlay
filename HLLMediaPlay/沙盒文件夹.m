沙盒文件夹

ios程序沙盒下文件夹目录的分类和相应的作用

    1、Documents 目录：
        您应该将所有de应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。

    2、AppName.app 目录：
        这是应用程序的程序包目录，包含应用程序的本身。由于应用程序必须经过签名，所以您在运行时不能对这个目录中的内容进行修改，否则可能会使应用程序无法启动。

    3、Library 目录：
        这个目录下有两个子目录：Caches 和 Preferences
    
    4、Preferences 目录：
        包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
    
    5、Caches 目录：
        用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。

    6、tmp 目录：
        这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。


下面列出获得相应文件夹的方法

    1.获取沙盒主目录路径  
        NSString *homeDir = NSHomeDirectory();  

    2.获取Documents目录路径  
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
        NSString *docDir = [paths objectAtIndex:0];  

    3.获取Caches目录路径  
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);  
        NSString *cachesDir = [paths objectAtIndex:0];  

    4.获取tmp目录路径  
        NSString *tmpDir =  NSTemporaryDirectory();


    5.在ios程序沙盒中Documents下创建文件夹

        NSFileManager *fileManager = [NSFileManager defaulrManager];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *createPath = [NSString stringWithFormat:@"%@/Image", pathDocuments];
        NSString *createDir = [NSString stringWithFormat:@"%@/MessageQueueImage", pathDocuments];
        
        // 判断文件夹是否存在，如果不存在，则创建 
        if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
            [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
            [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            NSLog(@"FileDir is exists.");
        }
