/**
 * 聊天组件
 * @author xiaoqiang <465633678@qq.com>
 * @created 2019/08/05 22:48:37
 */
import 'package:flutter/material.dart';
import 'package:intimate_couple/utils/chat.dart';
class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}
class MessageItem {
  final String name;
  final String content;
  final bool isMe;
  MessageItem({
    this.name,
    this.content,
    this.isMe
  });
}
class _ChatState extends State<Chat> {
  TextEditingController _textEditingController =TextEditingController();
  ChatSocket _chatSocket = ChatSocket();
  List<MessageItem> messages = [
    MessageItem(
      content: '哈哈哈',
      isMe: true,
      name: '小说'
    ),
    MessageItem(
      content: '哈哈哈',
      isMe: false,
      name: '哈哈'
    )
  ];
  onSubmit() {
    final String text = _textEditingController.text;
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '和小黑聊天'
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  if (messages[index].isMe) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(15, 11, 15, 10),
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey
                            ),
                            child: Text(
                              messages[index].content,
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                              child: Text(messages[index].name),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: CircleAvatar(
                            child: Text(messages[index].name),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.fromLTRB(15, 11, 15, 10),
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueGrey
                          ),
                          child: Text(
                            messages[index].content,
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            ),
            Container(
              color: Colors.black12,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: _textEditingController,
                        style: TextStyle(),
                        decoration: InputDecoration(
                          fillColor: Colors.white
                        ),
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      color: Colors.brown,
                      textColor: Colors.white,
                      onPressed: () {
                        onSubmit();
                      },
                      child: Text('发送'),
                    ),
                  )
                ],
              )
            )
          ],
        )
      ),
    );
    
  }
}