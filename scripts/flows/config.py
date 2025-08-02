# config.py
import os

API_KEY = "de3ec0be8bd34234b7aef1175beb5c48.gzFFjXai6f3g87Ai"
LLM_URL = "https://open.bigmodel.cn/api/paas/v4/chat/completions"

OUTPUT_DIR = "output"
PPT_IMG_DIR = os.path.join(OUTPUT_DIR, "ppt_pages")
HUMAN_VIDEO_DIR = os.path.join(OUTPUT_DIR, "human_videos")
FINAL_VIDEO_DIR = os.path.join(OUTPUT_DIR, "final_videos")

for d in [OUTPUT_DIR, PPT_IMG_DIR, HUMAN_VIDEO_DIR, FINAL_VIDEO_DIR]:
    os.makedirs(d, exist_ok=True)