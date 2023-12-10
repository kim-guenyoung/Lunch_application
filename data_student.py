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
import os


chrome_options = Options()

driver_path = ChromeDriverManager().install()
driver = webdriver.Chrome(options=chrome_options)

driver.get("https://www.smu.ac.kr/kor/life/restaurantView4.do")
driver.find_element(By.CSS_SELECTOR, "#ko > div.board-name-thumb.board-wrap > ul > li:nth-child(1) > dl > dt > a").click() # 이번주 들어가는 것만
# driver.find_element(By.CSS_SELECTOR, "#ko > div.board-name-thumb.board-wrap > ul > li:nth-child(1) > dl > dt > a").click() # 이번주 들어가는 것만
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

directory = "학생식당"
if not os.path.exists(directory):
    os.makedirs(directory)

# image_path = f"Lunch_/학생식당/" + now.strftime("%m%d") + ".png"
image_path = f"학생식당/student.png"

urllib.request.urlretrieve(img_url, image_path) 

import cv2
import os
# from google.colab.patches import cv2_imshow
from datetime import datetime

image = cv2.imread(image_path)
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# cv2 이용 -> 흑백 변환
_, thresh = cv2.threshold(gray, 128, 255, cv2.THRESH_BINARY)

# 경계선 찾기
contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

# output_dir_cropped = f"Lunch_/학생식당/cropped_images_student{now.strftime('%m%d')}"
output_dir_cropped = f"학생식당/cropped_images_student"
os.makedirs(output_dir_cropped, exist_ok=True)

# 바운더리가 높이는 100 이상 폭은 100 ~800이면 roi해서 저장
for i, cnt in enumerate(contours):
    x, y, w, h = cv2.boundingRect(cnt)

    # Check the specified conditions
    if h >= 100 and 100 <= w < 800:
        roi = image[y : y + h, x :x + w]

        # Save the cropped image
        relative_output_path = os.path.join(output_dir_cropped, f"student{i}.png")
        cv2.imwrite(relative_output_path, roi)



from google.cloud import vision_v1
from google.oauth2 import service_account

# Google Cloud Vision API 키 설정 (서비스 계정 키 파일의 경로)
google_cloud_api_key_path = "iconic-aloe-403811-a9f644e4c697.json"

# 서비스 계정 키 파일 로드
credentials = service_account.Credentials.from_service_account_file(
    google_cloud_api_key_path,
    scopes=["https://www.googleapis.com/auth/cloud-platform"],
)

# Vision API 클라이언트 생성
client = vision_v1.ImageAnnotatorClient(credentials=credentials)

# Function to replace '⁺' with '+'
def replace_plus(word):
    return word.replace('⁺', '+')

# Function to replace variations of "오늘의 백반" with "오늘의백반"
def replace_today_menu(word):
    return word.replace('오늘의', '') \
               .replace("백반", "") \
               .replace('""', "") \
               .replace("등심/", "등심돈까스/") \
               .replace("※", "") \
               .replace("금요일은", "") \
               .replace("쉽니다", "") \
               .replace("돌손알밥", "돌솥알밥") \
               .replace("\n\n", "") \
               .replace("'\"", "") \
               .replace("=\n", "")



# Function to print a list of words
def print_word_list(word_list):
    for word in word_list:
        word = replace_plus(word)
        word = replace_today_menu(word)
        print(f"{word}", end=" ")
    print("\n" + "=" * 30)


# 이미지 파일 경로
breakfast = [28, 27, 26, 25, 24]
single = [22, 21, 20, 19]
today = [18, 17, 16, 15]


for i in breakfast:
    # image_path = image_path = f"Lunch_/학생식당/cropped_images_student{now.strftime('%m%d')}/student{i}.png"
    image_path = image_path = f"학생식당/cropped_images_student/student{i}.png"

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

        if '등심' in description and i == 24:
            texts = description.split('등심')

            # 각각의 텍스트 출력
            for t in texts:
                print(t.strip())


for i in single:
    # image_path = f"Lunch_/학생식당/cropped_images_student{now.strftime('%m%d')}/student{i}.png"
    image_path = f"학생식당/cropped_images_student/student{i}.png"

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


for i in today:
    # image_path = f"Lunch_/학생식당/cropped_images_student{now.strftime('%m%d')}/student{i}.png"
    image_path = f"학생식당/cropped_images_student/student{i}.png"

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

import csv
from google.cloud import vision_v1


csv_file_path = f"menu_student.csv"

with open(csv_file_path, 'w', newline='') as csv_file:
    csv_writer = csv.writer(csv_file)

    csv_writer.writerow(["Text"])

    def replace_plus(word):
        return word.replace('⁺', '+')

    def replace_today_menu(description):
        return description.replace('오늘의', '') \
        .replace("백반", "") \
        .replace('""', "") \
        .replace("등심/", "등심돈까스/") \
        .replace("※", "") \
        .replace("금요일은", "") \
        .replace("쉽니다", "") \
        .replace("\n\n", "") \
        .replace("'\"", "") \
        .replace("=\n", "") \
        .replace("/고구마돈까스", "등심돈까스/고구마돈까스")


    def write_to_csv(image_path, text):
        csv_writer.writerow([text])

    # Iterate through each image
    for i in breakfast + single + today:
        # image_path = f"Lunch_/학생식당/cropped_images_student{now.strftime('%m%d')}/student{i}.png"
        image_path = f"학생식당/cropped_images_student/student{i}.png"

        # 이미지에서 텍스트 감지
        with open(image_path, "rb") as image_file:
            content = image_file.read()

        image = vision_v1.Image(content=content)
        response = client.text_detection(image=image)
        texts = response.text_annotations

        # Process and replace text variation
        if texts:
            description = texts[0].description
            # "등심"을 기준으로 텍스트 나누기
            if '등심' in description and i == 24:
                texts = description.split('등심')

                # 각각의 텍스트 출력
                for t in texts:
                    processed_text = t.strip()
                    processed_text = " ".join([replace_plus(word) for word in processed_text.split(' ')])
                    processed_text = replace_today_menu(processed_text)


                    if processed_text:
                        replace_today_menu(processed_text)
                        csv_writer.writerow([processed_text])

            else:
                processed_text = description.strip()
                processed_text = " ".join([replace_plus(word) for word in processed_text.split(' ')])
                processed_text = replace_today_menu(processed_text)


                if processed_text:
                    replace_today_menu(processed_text)
                    csv_writer.writerow([processed_text])



print(f"CSV file created at {csv_file_path}")

import json
from google.cloud import vision_v1

# Specify the JSON file path
json_file_path = f"menu_student.json"

# Open the JSON file in write mode with utf-8 encoding
with open(json_file_path, 'w', encoding='utf-8') as json_file:
    data = []

    def replace_plus(word):
        return word.replace('⁺', '+')

    def replace_today_menu(word):
        return word.replace('오늘의', '') \
               .replace("백반", "") \
               .replace('""', "") \
               .replace("등심/", "등심돈까스/") \
               .replace("※", "") \
               .replace("금요일은", "") \
               .replace("쉽니다", "") \
               .replace("\n\n", "") \
               .replace("'\"", "") \
               .replace("=\n", "") \
               .replace("&", ", ") \
               .replace("배주김치", "배추김치")

    def write_to_json(text):
        data.append(text)

    # Variables to keep track of the processed texts
    processed_texts = []

    # Iterate through each image
    for i in breakfast + single + today:
        # image_path = f"Lunch_/학생식당/cropped_images_student{now.strftime('%m%d')}/student{i}.png"
        image_path = f"학생식당/cropped_images_student/student{i}.png"

        # 이미지에서 텍스트 감지
        with open(image_path, "rb") as image_file:
            content = image_file.read()

        image = vision_v1.Image(content=content)
        response = client.text_detection(image=image)
        texts = response.text_annotations
        
        # Process and replace text variation
        if texts:
            description = texts[0].description
            # "등심"을 기준으로 텍스트 나누기
            if '등심' in description and i == 24:
                texts = description.split('등심')

                # 각각의 텍스트 출력
                for t in texts:
                    processed_text = t.strip()
                    processed_text = " ".join([replace_plus(word) for word in processed_text.split(' ')])
                    processed_text = replace_today_menu(processed_text)
                    processed_text = processed_text.replace("/고구마돈까스", "등심돈까스/고구마돈까스")
                    processed_text = processed_text.replace("/치킨까스", "등심돈까스/치킨까스")
                    processed_text = processed_text.replace("/생선까스", "등심돈까스/생선까스")
                    processed_text = processed_text.replace("/치즈돈까스", "등심돈까스/치즈돈까스")

                    processed_text = processed_text.replace('등심돈까스등심돈까스', '등심돈까스')
                    # Write to CSV if processed text is present
                    if processed_text:
                        replace_today_menu(processed_text)
                        processed_texts.append(processed_text)

            else:
                # Process and save the entire description
                processed_text = description.strip()
                processed_text = " ".join([replace_plus(word) for word in processed_text.split(' ')])
                processed_text = replace_today_menu(processed_text)

                processed_text = processed_text.replace("/고구마돈까스", "등심돈까스/고구마돈까스")
                processed_text = processed_text.replace("/치킨까스", "등심돈까스/치킨까스")
                processed_text = processed_text.replace("/생선까스", "등심돈까스/생선까스")
                processed_text = processed_text.replace("/치즈돈까스", "등심돈까스/치즈돈까스")
                processed_text = processed_text.replace('등심돈까스등심돈까스', '등심돈까스')
                # Write to CSV if modified text is present
                if processed_text:
                    replace_today_menu(processed_text)
                    processed_texts.append(processed_text)

    # Move the 6th text to the 10th position
    if len(processed_texts) >= 10:
        processed_texts.insert(9, processed_texts.pop(5))

    # Write to JSON file
    for text in processed_texts:
        write_to_json({"text": text})

    json.dump(data, json_file, indent=2, ensure_ascii=False)

print(f"JSON file created at {json_file_path}")