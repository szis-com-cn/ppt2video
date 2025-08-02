import asyncio
import edge_tts
import os

class JSON2AUDIO:
    """
    使用 edge-tts 将文本转换为语音 (MP3/WAV)
    """
    def __init__(self, voice="zh-CN-XiaoxiaoNeural", rate="+0%", volume="+0%"):
        self.voice = voice
        self.rate = rate
        self.volume = volume

    async def _synthesize_async(self, text: str, output_path: str):
        # 创建 TTS 合成器
        communicate = edge_tts.Communicate(
            text, 
            voice=self.voice, 
            rate=self.rate,
            volume=self.volume
        )
        await communicate.save(output_path)

    def text_to_speech(self, text: str, output_path: str):
        """
        将文本生成语音文件
        :param text: 口播稿
        :param output_path: 输出路径，例如 'slide_1.mp3'
        """
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        asyncio.run(self._synthesize_async(text, output_path))
        print(f"[OK] 已生成语音文件: {output_path}")
        return output_path
