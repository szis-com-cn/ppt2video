import requests
import json
from .config import LLM_URL, API_KEY

class JSON2TXT:
    """将PPT内容转换为口播稿"""
    
    # 用于保存对话历史
    history = [
        {"role": "system", "content": "你是一个专业培训讲师。请根据以下PPT内容生成2-3分钟口播稿,要求语言自然流畅,((不需要正文以外的任何说明)),((不要分点)),(需要衔接上面的内容,加一个过渡句),第一页和最后一页不需要太多内容："}
        # {"role": "system", "content": "你是一个专业培训讲师。请根据以下PPT内容生成尽量简短的一句话口播稿,要求语言自然流畅,((不需要正文以外的任何说明)),((不要分点)),(需要衔接上面的内容,加一个过渡句),第一页和最后一页不需要太多内容："}
    ]
    
    @classmethod
    def generate_script_with_llm(cls, idx, all_idx, slide_text, notes_text=""):
        """给一页PPT生成口播稿，并保留历史对话"""
        prompt = f"""
        {idx}页/{all_idx}页 PPT正文：
        {slide_text}
        备注：
        {notes_text}
        """

        # 将当前用户提问加入历史
        cls.history.append({"role": "user", "content": prompt})

        headers = {
            "Authorization": f"Bearer {API_KEY}",
            "Content-Type": "application/json"
        }

        data = {
            "model": "glm-4",
            "messages": cls.history,
            "temperature": 0.7
        }

        # print(cls.history)

        response = requests.post(LLM_URL, headers=headers, data=json.dumps(data))
        resp_json = response.json()

        # 解析结果
        if "choices" in resp_json and len(resp_json["choices"]) > 0:
            reply = resp_json["choices"][0]["message"]["content"]

            # 保存 AI 回复到历史
            cls.history.append({"role": "assistant", "content": reply})

            return reply
        else:
            return f"[Error] {resp_json}"
