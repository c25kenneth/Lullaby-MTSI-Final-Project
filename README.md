## 2024 M&TSI Team 10 Project - Lullaby 👶 🍼

Lullaby is a smart baby monitor that eases the worries of new parents. 

The mobile application was made with Flutter/Dart with Firebase Auth and Firestore. The app can track the baby's sleep and eating habits to determine the baby's reason for crying and overall health. Parents can also schedule meal/nap times for their babies direclty through the app. These reminders will automatically sync to the user's personal calendar to ensure easy scheduling. 
Parents also have access to the app's forum where they can ask questions and recieve helpful responses from both parents and our bulit-in chatbot Lully. 
The app also has a screen to provide baby resources to the parents, such as clothing stores and pediatric hospitals. For this, we used the Google Maps API to show the resources in an interactive manner. 

The physical Lullaby device was coded in Python. I used OpenCV and Mediapipe for facial detection and analysis. If a face isn't detected within 15 seconds, parents will recieve an SMS message via the Vonage API, reminding them to check up on their baby. 
Lullaby itself also acts as a voice assistant. Parents can give verbal commands to the physical Lullaby device which will then use speech-to-text to analyze the intent. This allows users to schedule meal/nap times on the app via their voices.

