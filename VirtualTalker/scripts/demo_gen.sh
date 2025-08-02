#修改运行路径到SadTalker目录
cd ./VirtualTalker/SadTalker

source ./venv/bin/activate

export LD_LIBRARY_PATH=/usr/lib/wsl/lib:$LD_LIBRARY_PATH

python ./inference.py --driven_audio ../test_audio_10s.wav \
                    --source_image ../avatar.png \
                    --still \
                    --preprocess full \
                    --result_dir ./results  || echo "❌ 生成失败，Ran out of input可能由于gfpgan下载不完整，请尝试删除gfpgan中的不完整文件重新运行该脚本"