import 'package:baby_steps/PostComments.dart';
import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String userName;
  final String postID;
  final String title;
  final String question;

  const PostCard({
    Key? key,
    required this.userName,
    required this.postID,
    required this.title,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostComments(userName: userName, postID: postID, title: title, question: question)));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '3h ago', // You can replace this with a dynamic value
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  question,
                  style: TextStyle(
                    color: Colors.black87,
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
