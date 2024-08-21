import 'package:baby_steps/FlutterFireFuncs.dart';
import 'package:baby_steps/LoadingScreen.dart';
import 'package:baby_steps/components/PostCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostFeed extends StatefulWidget {
  final String userName; 
  const PostFeed({super.key, required this.userName});

  @override
  State<PostFeed> createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy("asked", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("user")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("babies")
                    .snapshots(),
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text("Get help from other parents"),
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          showModalBottomSheet(
  context: context,
  isScrollControlled: true, // This allows the bottom sheet to resize based on content
  builder: (context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Create a post',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Handle post creation logic here
                          String title = _titleController.text;
                          String content = _contentController.text;

                          dynamic res = await addPost(
                            title,
                            content,
                            snapshot2.data!.docs[0].get('parentName'),
                          );
                          if (res.runtimeType == String) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Post'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Add a title...',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Divider(),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: 'Ask your question...',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 16.0),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  },
);


                        },
                        backgroundColor: Color.fromRGBO(255, 64, 111, 1),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      body: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return PostCard(
                                      userName: snapshot.data!.docs[index].get('askedBy'),
                                      postID: snapshot.data!.docs[index].id,
                                      title: snapshot.data!.docs[index]
                                          .get('title'),
                                      question: snapshot.data!.docs[index]
                                          .get('question'));
                                }),
                          )
                        ],
                      ),
                    );
                  } else {
                    return LoadingScreen();
                  }
                });
          } else {
            return LoadingScreen();
          }
        });
  }
}
