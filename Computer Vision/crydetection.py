import os
import numpy as np
import time
import sounddevice as sd
import threading
from threading import Thread
import serial
from gpiozero import RGBLED, Motor
from colorzero import Color
import pygame
import speech_recognition as sr
from firebase_admin import credentials, firestore, auth, exceptions
import firebase_admin
import pyttsx3
import pytz

volume_level = 0
crying = False
recognizer = sr.Recognizer()

cred = credentials.Certificate('FIREBASE.json')
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

def audio_callback(indata, frames, time, status):
    global volume_level
    if status:
        print(status)
    volume_level = np.linalg.norm(indata) * 10

def sound_detection(device_index):
    sample_rate = 48000

    with sd.InputStream(callback=audio_callback, device=device_index, channels=1, samplerate=sample_rate):
        print("Starting sound detection...")
        while True:
            sd.sleep(1000)

def start_detect():
    global crying
    device_index = 1
    detection_thread = threading.Thread(target=sound_detection, args=(device_index,))
    detection_thread.daemon = True
    detection_thread.start()

def monitor_sound():
    global crying
    try:
        while True:
            time.sleep(1)
            if volume_level > 120:
                print("Loud sound detected!")
                crying = True

    except KeyboardInterrupt:
        print("Sound monitoring stopped.")

def play_lullaby(track_number):
    pygame.mixer.init()
    pygame.mixer.music.load('/home/pi/Music/' + str(track_number) + '.mp3')
    pygame.mixer.music.play()
    time.sleep(1)
    try:
        while pygame.mixer.music.get_busy():
            time.sleep(1)
    except KeyboardInterrupt:
        pygame.mixer.music.stop()
        pygame.mixer.quit()
        print("Lullaby stopped.")

led = RGBLED(red=5, green=6, blue=13)

def warm_light_on(duration=5):
    for i in range(100):
        c_red = i / 100 * 1
        c_green = 0
        c_blue = 0
        led.color = (c_red, c_green, c_blue)
        time.sleep(duration / 100)

motor = Motor(forward=17, backward=18)

def main_loop():
    global crying
    start_detect()
    monitor_thread = Thread(target=monitor_sound)
    monitor_thread.daemon = True
    monitor_thread.start()

    try:
        while True:
            if crying:
                print("Crying")
                crying = False
                lullaby = Thread(target=play_lullaby, args=(1,))
                light = Thread(target=warm_light_on, args=(5,))
                motor_fwd = Thread(target=motor.forward, args=(1,))

                lullaby.start()
                light.start()
                motor_fwd.start()

                light.join()
                time.sleep(20)

                lullaby.join()
                motor_fwd.join()

            time.sleep(1)

    except KeyboardInterrupt:
        pygame.mixer.quit()
        led.off()

if __name__ == "__main__":
    main_loop()
