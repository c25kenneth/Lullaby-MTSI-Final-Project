import 'package:baby_steps/FlutterFireFuncs.dart';
import 'package:baby_steps/LoadingScreen.dart';
import 'package:baby_steps/components/HeaderFb1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PostComments extends StatefulWidget {
  final String userName;
  final String postID;
  final String title;
  final String question;
  const PostComments(
      {super.key,
      required this.userName,
      required this.postID,
      required this.title,
      required this.question});

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.postID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .doc(widget.postID)
                    .collection("comments")
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    // Sort comments, placing AI comments first
                    List<QueryDocumentSnapshot> sortedDocs =
                        snapshot2.data!.docs;
                    sortedDocs.sort((a, b) {
                      bool isAIa = a.get('isAI');
                      bool isAIb = b.get('isAI');
                      return isAIb
                          .toString()
                          .compareTo(isAIa.toString()); // AI comments first
                    });

                    return Scaffold(
                      floatingActionButton: FloatingActionButton(
                        backgroundColor: Colors.blue[200],
                        child: Icon(
                          Icons.comment,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              final TextEditingController _contentController =
                                  TextEditingController();
                              final double keyboardHeight =
                                  MediaQuery.of(context).viewInsets.bottom;

                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        keyboardHeight), // Adjust bottom padding to account for keyboard
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            Text(
                                              'Add your comment',
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // Handle post creation logic here
                                                String content =
                                                    _contentController.text;

                                                if (content.isNotEmpty) {
                                                  await addComment(
                                                      content,
                                                      widget.userName,
                                                      widget.postID,
                                                      false,
                                                      DateTime.now());
                                                  Navigator.pop(
                                                      context); // Close the bottom sheet after posting
                                                }
                                              },
                                              child: Text('Post'),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16.0),
                                        Divider(),
                                        TextField(
                                          maxLength: 100,
                                          controller: _contentController,
                                          decoration: InputDecoration(
                                            hintText: 'Add your answer...',
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(fontSize: 16.0),
                                          maxLines: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      appBar: AppBar(),
                      body: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Asked by " + snapshot.data!.get('askedBy'),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            SizedBox(height: 14),
                            HeaderFb1(text: widget.title),
                            Text(
                              widget.question,
                              style: TextStyle(fontSize: 18),
                            ),
                            Divider(),
                            SizedBox(height: 25),
                            (sortedDocs.isNotEmpty)
                                ? Expanded(
                                    child: ListView.builder(
                                        itemCount: sortedDocs.length,
                                        itemBuilder: (context, index) {
                                          var doc = sortedDocs[index];
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isExpanded = !isExpanded;
                                              });
                                            },
                                            child: ListTile(
                                              contentPadding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      0), // Remove extra padding if needed
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      doc.get('isAI') == false
                                                          ? Icon(
                                                              Icons
                                                                  .person_outline,
                                                              size: 20)
                                                          : Icon(Icons
                                                              .smart_toy_outlined),
                                                      SizedBox(width: 9),
                                                      Expanded(
                                                        child: Text(
                                                          "From " +
                                                              doc.get(
                                                                  'commenter'),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 12),
                                                  Text(
                                                    doc.get("comment"),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    maxLines:
                                                        isExpanded ? null : 3,
                                                    overflow: isExpanded
                                                        ? TextOverflow.visible
                                                        : TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              leading: Container(
                                                width:
                                                    40, // Set width to prevent overflow
                                                child: Center(
                                                  child: Text(
                                                    doc
                                                        .get('totalLikes')
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: (doc.get(
                                                                  'totalLikes') >=
                                                              0)
                                                          ? Colors.blue[300]
                                                          : Colors.red[300],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      updateLike(
                                                          1,
                                                          widget.postID,
                                                          doc.id);
                                                    },
                                                    icon: Icon(Icons
                                                        .arrow_upward_outlined),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      updateLike(
                                                          -1,
                                                          widget.postID,
                                                          doc.id);
                                                    },
                                                    icon: Icon(Icons
                                                        .arrow_downward_outlined),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                : Center(
                                    child: Column(
                                      children: [
                                        Container(
                                            margin: EdgeInsets.only(top: 50),
                                            width: width * 0.65,
                                            height: height * 0.20,
                                            child: SvgPicture.asset(
                                                "assets/images/undraw_not_found_re_bh2e_lightblue.svg")),
                                        SizedBox(height: 15),
                                        Text(
                                          "No answers so far!",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
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
