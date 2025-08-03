import asyncio
import edge_tts
import os

class JSON2AUDIO:
    """
    使用 edge-tts 将文本转换为语音 (MP3/WAV)
    """

    @staticmethod
    async def _synthesize_async(text: str, output_path: str, voice="zh-CN-XiaoxiaoNeural", rate="+15%", volume="+0%"):
        # 创建 TTS 合成器
        communicate = edge_tts.Communicate(
            text, 
            voice=voice, 
            rate=rate,
            volume=volume
        )
        await communicate.save(output_path)

    @staticmethod
    def text_to_speech(text: str, output_path: str, voice="zh-CN-XiaoxiaoNeural", rate="+15%", volume="+0%"):
        """
        将文本生成语音文件
        :param text: 口播稿
        :param output_path: 输出路径，例如 'slide_1.mp3'
        """
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        asyncio.run(JSON2AUDIO._synthesize_async(text, output_path, voice, rate, volume))
        print(f"[OK] 已生成语音文件: {output_path}")
        return output_path
