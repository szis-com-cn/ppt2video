#修改运行路径到SadTalker目录
cd ./VirtualTalker/SadTalker

source ./venv/bin/activate

python ./inference.py --driven_audio ../test_audio_10s.wav \
                    --source_image ../avatar.png \
                    --still \
                    --preprocess full 