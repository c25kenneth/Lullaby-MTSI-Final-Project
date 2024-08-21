import cv2
import mediapipe as mp
import numpy as np
from deepface import DeepFace
import os
import time
from twilio.rest import Client
import vonage

client = vonage.Client(key="*************", secret="*************")
sms = vonage.Sms(client)

os.environ["IMAGEIO_FFMPEG_EXE"] = "/usr/bin/ffmpeg"

mp_face_detection = mp.solutions.face_detection
mp_face_mesh = mp.solutions.face_mesh
mp_drawing = mp.solutions.drawing_utils
mp_drawing_styles = mp.solutions.drawing_styles

EYE_AR_THRESH = 0.2

def eye_aspect_ratio(eye_landmarks):
    vertical_1 = np.linalg.norm(eye_landmarks[1] - eye_landmarks[5])
    vertical_2 = np.linalg.norm(eye_landmarks[2] - eye_landmarks[4])
    horizontal = np.linalg.norm(eye_landmarks[0] - eye_landmarks[3])
    ear = (vertical_1 + vertical_2) / (2.0 * horizontal)
    return ear

cap = cv2.VideoCapture(0)

last_checked_time = time.time()
face_not_detected = False
first_message_printed = False

with mp_face_detection.FaceDetection(
    model_selection=1, min_detection_confidence=0.5) as face_detection, \
     mp_face_mesh.FaceMesh(
    max_num_faces=1,
    refine_landmarks=True,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5) as face_mesh:
    
    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        face_detection_results = face_detection.process(rgb_frame)
        face_mesh_results = face_mesh.process(rgb_frame)

        current_time = time.time()

        if face_mesh_results.multi_face_landmarks:
            face_not_detected = False
            first_message_printed = False
            
            for face_landmarks in face_mesh_results.multi_face_landmarks:
                left_eye_landmarks = np.array([
                    [face_landmarks.landmark[i].x, face_landmarks.landmark[i].y]
                    for i in [33, 160, 158, 133, 153, 144]
                ])
                right_eye_landmarks = np.array([
                    [face_landmarks.landmark[i].x, face_landmarks.landmark[i].y]
                    for i in [362, 385, 387, 263, 373, 380]
                ])

                left_ear = eye_aspect_ratio(left_eye_landmarks)
                right_ear = eye_aspect_ratio(right_eye_landmarks)

                if left_ear < EYE_AR_THRESH and right_ear < EYE_AR_THRESH:
                    cv2.putText(frame, "Eyes Closed", (50, 50),
                                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                else:
                    cv2.putText(frame, "Eyes Open", (50, 50),
                                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

                try:
                    result = DeepFace.analyze(frame, actions=['emotion'], enforce_detection=False)
                    if result:
                        dominant_emotion = result[0]['dominant_emotion']
                        cv2.putText(frame, f"Emotion: {dominant_emotion}", (50, 100),
                                    cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 255), 2)
                        if (dominant_emotion == "" or dominant_emotion == "" or dominant_emotion == ""):
                            pass
                except Exception as e:
                    cv2.putText(frame, "Emotion Detection Error", (50, 100),
                                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                    print(f"Error in emotion detection: {e}")
        else:
            if not first_message_printed:
                print("No Face Detected")
                first_message_printed = True
                last_checked_time = current_time

            if current_time - last_checked_time >= 30:
                print("No Face Detected for 30 seconds")
                responseData = sms.send_message(
                    {
                        "from": "14017735489",
                        "to": "12068165865",
                        "text": "Your child's face isn't recognizable. Please check up on them ASAP!",
                    }
                )

                if responseData["messages"][0]["status"] == "0":
                    print("Message sent successfully.")
                else:
                    print(f"Message failed with error: {responseData['messages'][0]['error-text']}")
                last_checked_time = current_time
                
            cv2.putText(frame, "No Face Detected", (50, 50),
                        cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                
        cv2.imshow('Face and Emotion Detector', frame)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

cap.release()
cv2.destroyAllWindows()
