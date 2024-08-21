import speech_recognition as sr
from firebase_admin import credentials, firestore, auth, exceptions
import firebase_admin
import pyttsx3
from dateutil import parser
from datetime import datetime, timedelta, timezone
import pytz

recognizer = sr.Recognizer()

cred = credentials.Certificate('FIREBASECONFIG.json')
app = firebase_admin.initialize_app(cred)

db = firestore.client()

tts_engine = pyttsx3.init()

def text_to_speech(text):
    tts_engine.say(text)
    tts_engine.runAndWait()

def updateNapSchedule(title, when):
    db.collection("user").document("ZezY28fEbkTYnq59aX9i8TSCugi2").collection('babies').document('5zZCftYqkQqOW4DyMNa4').collection('nap').add({"title": title, "time": when, 'scheduleType': "Nap Time"})

def updateMealSchedule(title, when): 
    db.collection("user").document("ZezY28fEbkTYnq59aX9i8TSCugi2").collection('babies').document('5zZCftYqkQqOW4DyMNa4').collection('nap').add({"title": title, "time": when, 'scheduleType': "Meal Time"})

utc_minus_4 = pytz.FixedOffset(-240)

def speech_to_text():
    while True:
        with sr.Microphone() as source:
            print("Adjusting for ambient noise, please wait...")
            recognizer.adjust_for_ambient_noise(source, duration=1)
            print("Listening...")
            audio = recognizer.listen(source)
            
            try:
                text = recognizer.recognize_google(audio).lower()
                
                print("You said: " + text)
                
                if "schedule" in text:
                    event_type = None
                    if "nap" in text:
                        event_type = "nap"
                    elif "meal" in text:
                        event_type = "meal"

                    if event_type:
                        day_keywords = ["today", "tomorrow"]
                        time_keywords = ["at", "for"]
                        day = "today"
                        time_string = None

                        for keyword in day_keywords:
                            if keyword in text:
                                day = keyword
                                break

                        for keyword in time_keywords:
                            if keyword in text:
                                try:
                                    time_string = text.split(keyword)[-1].strip()
                                    print(f"Extracted time string: {time_string}")
                                    time = parser.parse(time_string)
                                    break
                                except (ValueError, IndexError) as e:
                                    print(f"Could not parse the time from the text: {e}")
                                    break
                        
                        if time_string:
                            utc_now = datetime.now(pytz.utc).astimezone(utc_minus_4)
                            
                            if day == "today":
                                scheduled_date = utc_now
                            elif day == "tomorrow":
                                scheduled_date = utc_now + timedelta(days=1)

                            scheduled_time = datetime(
                                year=scheduled_date.year,
                                month=scheduled_date.month,
                                day=scheduled_date.day,
                                hour=time.hour,
                                minute=time.minute,
                                tzinfo=utc_minus_4
                            )

                            if "am" not in time_string and "pm" not in time_string:
                                if scheduled_time < utc_now:
                                    scheduled_time += timedelta(hours=12)
                                    if scheduled_time < utc_now:
                                        scheduled_time += timedelta(hours=12)

                            if scheduled_time < utc_now:
                                scheduled_time += timedelta(days=1)

                            formatted_time = scheduled_time.strftime("%m/%d/%Y at %I:%M %p")

                            print(f"Scheduled {event_type} for {day} at {formatted_time}")
                            print(scheduled_time)
                            
                            if event_type == "meal":
                                updateMealSchedule("New Meal", scheduled_time)
                            elif event_type == "nap":
                                updateNapSchedule("New Nap", scheduled_time)

                            text_to_speech(f"{event_type} has been scheduled for {formatted_time}.")
                        else:
                            print("Could not determine the time from the text.")
                
                if text in ["exit", "stop"]:
                    print("Exiting...")
                    break

            except sr.UnknownValueError:
                print("Sorry, I could not understand the audio")
            except sr.RequestError:
                print("Sorry, my speech service is down")

speech_to_text()
