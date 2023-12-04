from google.cloud import speech_v1p1beta1 as speech
from google.cloud import texttospeech
import pyaudio
from pydub import AudioSegment
from pydub.playback import play
import io

text_to_speech = "/home/pi/lunch/iconic-aloe-403811-80800b7d7bd7.json"
speech_to_text = "/home/pi/lunch/iconic-aloe-403811-fef393854188.json"

# Google Cloud Speech-to-Text 및 Text-to-Speech API 인증 설정
client_stt = speech.SpeechClient.from_service_account_file(speech_to_text)
client_tts = texttospeech.TextToSpeechClient.from_service_account_file(text_to_speech)

# 음성 파일에서 텍스트 추출(STT)
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

# 텍스트를 음성 파일로 변환(TTS)
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

def main():
    CHUNK = 1024
    FORMAT = pyaudio.paInt16
    CHANNELS = 1
    RATE = 16000
    RECORD_SECONDS = 5

    p = pyaudio.PyAudio()

    stream = p.open(format=FORMAT,
                    channels=CHANNELS,
                    rate=RATE,
                    input=True,
                    frames_per_buffer=CHUNK)

    print("* 녹음을 시작합니다. 몇 초간 말하세요.")

    frames = []

    for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
        data = stream.read(CHUNK)
        frames.append(data)

    print("* 녹음이 완료되었습니다.")

    stream.stop_stream()
    stream.close()
    p.terminate()

    audio_data = b''.join(frames)


    transcript = transcribe_audio(audio_data)
    print("인식된 텍스트:", transcript)

    if "부엉" in transcript:
        print("네")

        audio_response = generate_audio("네")

        sound = AudioSegment.from_file(io.BytesIO(audio_response), format="wav")
        play(sound)

    else:
        print("무슨 말씀이신지 이해하지 못했습니다.")
        audio_response = generate_audio("무슨 말씀이신지 이해하지 못했습니다.")
        sound = AudioSegment.from_file(io.BytesIO(audio_response), format="wav")
        play(sound)

if __name__ == "__main__":
    main()
