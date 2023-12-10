from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
import time

from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from bs4 import BeautifulSoup
import requests
import datetime
import urllib
import schedule
import os

# Create ChromeOptions object
chrome_options = Options()

driver_path = ChromeDriverManager().install()
driver = webdriver.Chrome(options=chrome_options)

driver.get("https://www.smu.ac.kr/kor/life/restaurantView3.do")
driver.find_element(By.CSS_SELECTOR, "#ko > div.board-name-thumb.board-wrap > ul > li:nth-child(1) > dl > dt > a").click() # 이번주 들어가는 것만
time.sleep(0.5)

# 새로 열린 페이지로 전환 
driver.switch_to.window(driver.window_handles[-1])

# 현재 url 가져오기
final_url = driver.current_url
driver.quit()
print(final_url)
#------------------------------------------------------------------------------현재 url// 이전에는 웹페이지 접속경로임

response = requests.get(final_url)
soup = BeautifulSoup(response.text, "html.parser")

image_tag = soup.select_one(".fr-view img")
image_src = image_tag.get("src")
img_url = "https://www.smu.ac.kr" + image_src

now = datetime.datetime.now()

directory = "교직원식당"
if not os.path.exists(directory):
    os.makedirs(directory)

# image_path = f"Lunch_/교직원식당/" + now.strftime("%m%d") + ".png"
image_path = f"{directory}/faculty.png"
urllib.request.urlretrieve(img_url, image_path) 

import cv2
import os
import numpy as np

# 이미지 로드
image_path = f"교직원식당/faculty.png"
image = cv2.imread(image_path)

# output_dir_cropped = f"Lunch_/교직원식당/cropped_images_faculty{now.strftime('%m%d')}"
output_dir_cropped = f"교직원식당/cropped_images_faculty"
os.makedirs(output_dir_cropped, exist_ok=True)

# 그레이스케일로 변환
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# 가우시안 블러 적용
blurred = cv2.GaussianBlur(gray, (5, 5), 0)

# 케니 엣지 검출
edges = cv2.Canny(blurred, 50, 150)

# 윤곽선 검출
contours, hierarchy = cv2.findContours(edges.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# 사각형 찾기
rectangles = []
for contour in contours:
    epsilon = 0.02 * cv2.arcLength(contour, True)
    approx = cv2.approxPolyDP(contour, epsilon, True)
    if len(approx) == 4 and cv2.contourArea(contour) > 1000:
        rectangles.append(approx)

# 사각형 잘라내기
for i, rect in enumerate(rectangles):
    x, y, w, h = cv2.boundingRect(rect)
    if w > 100 and h > 200:
        roi = image[y:y + h, x:x + w]
        
        # Save the cropped image
        relative_output_path = os.path.join(output_dir_cropped, f"faculty{i}.png")
        cv2.imwrite(relative_output_path, roi)

#출력용

from google.cloud import vision_v1
from google.oauth2 import service_account

# Google Cloud Vision API 키 설정 (서비스 계정 키 파일의 경로)
google_cloud_api_key_path = "iconic-aloe-403811-a9f644e4c697.json"

# 서비스 계정 키 파일 로드
credentials = service_account.Credentials.from_service_account_file(
    google_cloud_api_key_path,
    scopes=["https://www.googleapis.com/auth/cloud-platform"],
)

client = vision_v1.ImageAnnotatorClient(credentials=credentials)

# deque형식으로 출력하기 위해 메뉴 거꾸로 저장
menu = [5, 4, 3, 2, 1]

#데이터 전처리
def replace_plus(word):
    return word.replace('⁺', '+')

def print_word_list(word_list):
    for word in word_list:
        word = replace_plus(word)
        print(f"{word}", end=" ")
    print("\n" + "=" * 30)


for i in menu:
    # image_path = f"Lunch_/교직원식당/cropped_images_faculty{now.strftime('%m%d')}/faculty{i}.png"
    image_path = f"교직원식당/cropped_images_faculty/faculty{i}.png"
    
    # 이미지에서 텍스트 감지
    with open(image_path, "rb") as image_file:
        content = image_file.read()

    image = vision_v1.Image(content=content)
    response = client.text_detection(image=image)
    texts = response.text_annotations
    
    if texts:
        description = texts[0].description
        word_list = description.split(' ')
        print_word_list(word_list)

for i in menu:
    # image_path = f"Lunch_/교직원식당/cropped_images_faculty{now.strftime('%m%d')}/faculty{i}.png"
    image_path = f"교직원식당/cropped_images_faculty/faculty{i}.png"

    # 이미지에서 텍스트 감지
    with open(image_path, "rb") as image_file:
        content = image_file.read()

    image = vision_v1.Image(content=content)
    response = client.text_detection(image=image)
    texts = response.text_annotations

    if texts:
        description = texts[0].description
        word_list = description.split(' ')
        print_word_list(word_list)



import cv2
import os
import numpy as np

# 이미지 로드
image_path = f"교직원식당/faculty.png"
image = cv2.imread(image_path)

# output_dir_cropped = f"Lunch_/교직원식당/cropped_images_faculty{now.strftime('%m%d')}"
output_dir_cropped = f"교직원식당/cropped_images_faculty"
os.makedirs(output_dir_cropped, exist_ok=True)

# 흑백으로 변환
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# 가우시안 블러 적용
blurred = cv2.GaussianBlur(gray, (5, 5), 0)

# 케니 엣지 검출
edges = cv2.Canny(blurred, 50, 150)

# 윤곽선 검출
contours, hierarchy = cv2.findContours(edges.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# 사각형 찾기
rectangles = []
for contour in contours:
    epsilon = 0.02 * cv2.arcLength(contour, True)
    approx = cv2.approxPolyDP(contour, epsilon, True)
    if len(approx) == 4 and cv2.contourArea(contour) > 1000:
        rectangles.append(approx)

# 사각형 잘라내기
for i, rect in enumerate(rectangles):
    x, y, w, h = cv2.boundingRect(rect)
    if w > 100 and h > 200:
        roi = image[y:y + h, x:x + w]
        

        relative_output_path = os.path.join(output_dir_cropped, f"faculty{i}.png")
        cv2.imwrite(relative_output_path, roi)


#csv
import csv
from google.cloud import vision_v1

# Specify the CSV file path
csv_file_path = f"menu_faculty.csv"


with open(csv_file_path, 'w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)

    csv_writer.writerow(["Text"])

    def replace_plus(word):
        return word.replace('⁺', '+')

    def write_to_csv(text):
        csv_writer.writerow([text])

    for i in menu:
        image_path = f"교직원식당/cropped_images_faculty/faculty{i}.png"
        # image_path = f"Lunch_/교직원식당/cropped_images_faculty{now.strftime('%m%d')}/faculty{i}.png"

        # 이미지에서 텍스트 감지
        with open(image_path, "rb") as image_file:
            content = image_file.read()

        image = vision_v1.Image(content=content)
        response = client.text_detection(image=image)
        texts = response.text_annotations

        if texts:
            description = texts[0].description
            word_list = description.split(' ')
            processed_text = " ".join([replace_plus(word) for word in word_list])


            if processed_text:
                write_to_csv(processed_text)

print(f"CSV file created at {csv_file_path}")

import json
from google.cloud import vision_v1

#저장할 Json
json_file_path = f"menu_faculty.json"

with open(json_file_path, 'w', encoding='utf-8') as json_file:
    data = []

    def replace_plus(word):
        return word.replace('⁺', '+').replace("돈육폭", "돈육폭찹")

    def write_to_json(text):
        data.append(text)

    for i in menu:
        # image_path = f"Lunch_/교직원식당/cropped_images_faculty{now.strftime('%m%d')}/faculty{i}.png"
        image_path = f"교직원식당/cropped_images_faculty/faculty{i}.png"

        # 이미지에서 텍스트 감지
        with open(image_path, "rb") as image_file:
            content = image_file.read()

        image = vision_v1.Image(content=content)
        response = client.text_detection(image=image)
        texts = response.text_annotations

        if texts:
            description = texts[0].description
            word_list = description.split(' ')
            processed_text = " ".join([replace_plus(word) for word in word_list])

            if processed_text:
                write_to_json({"text": processed_text})
    json.dump(data, json_file, indent=2, ensure_ascii=False)

print(f"JSON file created at {json_file_path}")