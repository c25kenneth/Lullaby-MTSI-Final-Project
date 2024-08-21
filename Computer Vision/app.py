import firebase_admin
from firebase_admin import credentials, firestore, auth, exceptions
import asyncio
from httpx_oauth.clients.google import GoogleOAuth2
from google.auth.transport import requests
from google.oauth2 import id_token
import datetime
import pytz

cred = credentials.Certificate('FIREBASECONFIG.json')
app = firebase_admin.initialize_app(cred)

db = firestore.client()

utc_minus_4 = pytz.FixedOffset(-240)

utc_now = datetime.datetime.now(pytz.utc)

local_time_utc_minus_4 = utc_now.astimezone(utc_minus_4)

def updateNapSchedule(title):
    db.collection("user").document("ZezY28fEbkTYnq59aX9i8TSCugi2").collection('babies').document('5zZCftYqkQqOW4DyMNa4').collection('nap').add({"title": title, "time": local_time_utc_minus_4, 'scheduleType': "Nap Time"})

def updateMealSchedule(title): 
    db.collection("user").document("ZezY28fEbkTYnq59aX9i8TSCugi2").collection('babies').document('5zZCftYqkQqOW4DyMNa4').collection('nap').add({"title": title, "time": local_time_utc_minus_4, 'scheduleType': "Meal Time"})

 
