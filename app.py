from flask import Flask, render_template, request
from google.cloud import speech_v1p1beta1 as speech
from google.cloud import texttospeech
import pyaudio
from pydub import AudioSegment
from pydub.playback import play
import io
import json

app = Flask(__name__)

text_to_speech = "/home/pi/lunch/iconic-aloe-403811-80800b7d7bd7.json"
speech_to_text = "/home/pi/lunch/iconic-aloe-403811-fef393854188.json"

client_stt = speech.SpeechClient.from_service_account_file(speech_to_text)
client_tts = texttospeech.TextToSpeechClient.from_service_account_file(text_to_speech)

file_name = "/home/pi/lunch/menu_faculty.json"
with open(file_name, 'r', encoding='utf-8') as file:
    json_data = json.load(file)

def transcribe_audio(data):
    audio = speech.RecognitionAudio(content=data)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=16000,
        language_code='ko-KR',
    )

    response = client_stt.recognize(config=config, audio=audio)
    for result in response.results:
        return result.alternatives[0].transcript.lower()

def generate_audio(text):
    synthesis_input = texttospeech.SynthesisInput(text=text)
    voice = texttospeech.VoiceSelectionParams(
        language_code='ko-KR',
        name='ko-KR-Wavenet-A',
    )
    audio_config = texttospeech.AudioConfig(
        audio_encoding=texttospeech.AudioEncoding.LINEAR16,
    )

    response = client_tts.synthesize_speech(
        input=synthesis_input,
        voice=voice,
        audio_config=audio_config
    )

    return response.audio_content

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/process', methods=['POST'])
def process():
    user_input = request.form['user_input']
    transcript = transcribe_audio(user_input)
    print("User Input:", user_input)
    print("Transcription:", transcript)

    if "부엉" in transcript:
        print("네")
        audio_response = generate_audio("네")
        sound = AudioSegment.from_file(io.BytesIO(audio_response), format="wav")
        play(sound)

        if "월요일" in transcript and ("교직원 식당" in transcript or "교직원" in transcript or "한누리관 9층" in transcript or "한누리관" in transcript):
            print("월요일 교직원 식당 메뉴입니다.")
            audio_response = generate_audio("월요일 교직원 식당 메뉴는 " + str(json_data[0]) + "입니다.")
            sound = AudioSegment.from_file(io.BytesIO(audio_response), format="wav")
            play(sound)



    elif "종료" in transcript:
        print("대화를 종료합니다.")
        audio_response = generate_audio("대화를 종료합니다. 이용해주셔서 감사합니다.")
        sound = AudioSegment.from_file(io.BytesIO(audio_response), format="wav")
        play(sound)

    else:
        print("무슨 말씀이신지 이해하지 못했습니다.")
        audio_response = generate_audio("무슨 말씀이신지 이해하지 못했습니다.")
        sound = AudioSegment.from_file(io.BytesIO(audio_response), format="wav")
        play(sound)

    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)
