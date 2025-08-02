apt install unoconv
apt install fonts-wqy-microhei fonts-wqy-zenhei ttf-mscorefonts-installer
fc-cache -fv
apt install poppler-utils
apt install ffmpeg
apt install uvicorn
apt install net-tools

# pip install --break-system-packages -r requirements.txt --ignore-installed typing_extensions
pip install -r requirements.txt