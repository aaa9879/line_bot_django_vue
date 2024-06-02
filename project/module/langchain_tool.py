from langchain.tools import BaseTool
from langchain.agents import load_tools, initialize_agent,AgentType
class category_classification(BaseTool):
    name = "account_classification_tool"
    description = (
        """
        為帳目分類，請從給予的類別判斷使用者輸入屬於哪個類別，
        類別請從使用者給予的類別當中的值進行挑選，一定要從中選出一個不能自己產生，只需要輸出類別就可以
        ex:抓出"餐費"輸出"餐費"，不要隨意產生一段文字
        """
    )

    def _run(self,
            類別: str = None,
             ):

        return(類別)

def get_category_classification_tool(llm):
    tools = [category_classification()]

    return initialize_agent(
        tools,
        llm,
        agent=AgentType.STRUCTURED_CHAT_ZERO_SHOT_REACT_DESCRIPTION,
        handle_parsing_errors=True,
        verbose=True)
