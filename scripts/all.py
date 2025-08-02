from flows import PPT2JSON, JSON2TXT, JSON2AUDIO
import os
from flows.config import *

ppt_file="example.pptx"
human_image="avatar.png"
final_output="output/final_training_video.mp4"

slides = PPT2JSON.extract_text_notes_and_images(ppt_file, PPT_IMG_DIR)

tts = JSON2AUDIO()

# 在循环前计算需要补零的位数
total_slides = len(slides)
zero_padding = len(str(total_slides))  # 根据总页数决定补零位数

for slide in slides:
    ppt_img = slide["image_path"]
    idx = slide["slide_number"]
    
    # 动态格式化编号（自动补零）
    formatted_idx = f"{idx:0{zero_padding}d}"
    
    script_file = os.path.join(OUTPUT_DIR, f"slide_{formatted_idx}_script.txt")
    audio_file = os.path.join(OUTPUT_DIR, f"slide_{formatted_idx}.mp3")

    # 1. 生成口播稿
    script = JSON2TXT.generate_script_with_llm(idx, len(slides), slide["slide_text"], slide["notes_text"])
    with open(script_file, "w", encoding="utf-8") as f:
        f.write(script)

    # 2. 生成音频
    tts.text_to_speech(script, audio_file)