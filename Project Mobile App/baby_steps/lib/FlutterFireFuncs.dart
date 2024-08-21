import 'package:baby_steps/HuggingFaceAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth _auth = FirebaseAuth.instance; 
FirebaseFirestore _db = FirebaseFirestore.instance; 

dynamic signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      
      UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential); 
      return cred;
    } catch (e) {
      print(e.toString());
      return "Error signing in with Google. Please try again.";
    }
  }

dynamic addBaby(String babyName, String parentName, String gender, String birthday) async {
  try {
    await _db.collection("user").doc(_auth.currentUser!.uid).collection("babies").add({"babyName": babyName, "parentName": parentName, "gender": gender, "birthday": birthday});

    return "Success"; 
  } catch (e) {
    return e;
  }
}

dynamic addPost(String title, String question, String parentName) async {
  try {
    // Start a transaction
    await _db.runTransaction((transaction) async {
      // Add a new post to the collection
      DocumentReference ref = await _db.collection('posts').add({
        "title": title,
        "question": question,
        "asked": DateTime.now(),
        "askedBy": parentName,
      });

      // Query for AI-generated content
      final data = await query(question);

      // Process the AI-generated content
      String aiGeneratedText = data[0]["generated_text"];

      // Remove the first sentence if there are multiple sentences
      String cleanedText = _removeFirstSentence(aiGeneratedText);

      // Add the cleaned AI-generated text as a comment
      await addComment(cleanedText, "Lully AI", ref.id, true, DateTime.now());

      return "success";
    });
  } catch (e) {
    return e;
  }
}

String _removeFirstSentence(String text) {
  // Split the text into sentences based on periods, exclamation marks, or question marks
  List<String> sentences = text.split(RegExp(r'(?<=[.!?])\s+'));

  // If there are multiple sentences, remove the first one and rejoin the rest
  if (sentences.length > 1) {
    return sentences.sublist(1).join(' ');
  }

  // If there's only one sentence, return the text as is
  return text;
}


dynamic addComment(String comment, String commenter, String postID, bool isAI, DateTime now) async {
  try {
    await _db.collection("posts").doc(postID).collection('comments').add({"comment": comment, "totalLikes": 1, "isAI": isAI, "commenter": commenter, "time": now});
    return "Success"; 
  } catch (e) {
    return e; 
  }
}

dynamic updateLike(int likeNum, String postID, String commentID) async {
  try {
    await _db.collection('posts').doc(postID).collection('comments').doc(commentID).update({'totalLikes': FieldValue.increment(likeNum)});
    return "success"; 
  } catch (e) {
    return e; 
  }
}

dynamic addToSchedule(DateTime scheduleDate, String title, String babyID, String scheduleType) async {
  try {
    await _db.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).collection('babies').doc(babyID).collection("nap").add({"time": scheduleDate, 'title': title, 'scheduleType': scheduleType});
    return "Success";
  } catch (e) {
    return e; 
  }
}

dynamic deleteFromSchedule(String postID, String babyID) async {
  try {
    await _db.collection('user').doc(FirebaseAuth.instance.currentUser!.uid).collection('babies').doc(babyID).collection('nap').doc(postID).delete(); 
    return "Success"; 
  } catch (e) {
    return e; 
  }
}