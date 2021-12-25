//
//  XMGServiceListener.m
//  10086_Service
//
//  Created by ciwei luo on 2020/1/14.
//  Copyright © 2020 ciwei luo. All rights reserved.
//

#import "XMGServiceListener.h"
#import <AsyncSocket/GCDAsyncSocket.h>


@interface XMGServiceListener ()<GCDAsyncSocketDelegate>

@property (nonatomic,strong)GCDAsyncSocket *serverSocket;

@property (nonatomic,strong)NSMutableArray *clientSockets;

@end


@implementation XMGServiceListener

-(void)start{
    //开启10086服务
    //1.创建一个socket对象
    GCDAsyncSocket *serverSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
//    //2.绑定端口并监听
    NSError *error = nil;
    [serverSocket acceptOnPort:5288 error:&error];
    if (!error) {
        NSLog(@"10086服务开启成功");
    }else{
        NSLog(@"10086服务开启失败");
    }
    self.serverSocket = serverSocket;
    
}


#pragma mark 有客户端的socket连接到服务器
-(void)socket:(GCDAsyncSocket *)serverSocket didAcceptNewSocket:(GCDAsyncSocket *)clientSocket
{
    NSLog(@"serverSocket %@",serverSocket);
    NSLog(@"clientSocket %@ host:%@ port:%d",clientSocket,clientSocket.connectedHost,clientSocket.connectedPort);
    [self.clientSockets addObject:clientSocket];

    [clientSocket readDataWithTimeout:-1 tag:0];
}

#pragma mark 读取客户端请求的数据
-(void)socket:(GCDAsyncSocket *)clientSocket didReadData:(NSData *)data withTag:(long)tag{
    
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到客户端上传的数据:%@",str);
    for (GCDAsyncSocket *socket in self.clientSockets) {
        if (socket != clientSocket) {
            [socket writeData:data withTimeout:-1 tag:0];
        }
    }
    [clientSocket readDataWithTimeout:-1 tag:0];
}




-(NSMutableArray *)clientSockets{
    if (!_clientSockets) {
        _clientSockets=[NSMutableArray array];
    }
    return _clientSockets;
}

@end
