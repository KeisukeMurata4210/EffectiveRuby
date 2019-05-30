raise("coffee machine low on water")
# これと同じ意味
raise(RuntimeError, "coffee machine low on water")
# RuntimeErrorは「何かまずいことが起きた」というエラーに過ぎない。他のプログラマーにとって役に立たない。
# 例外クラスを作るべし。

# rescue節はクラスまたはスーパークラスがStandardErrorになっている全ての例外に割り込むので、StandardErrorを継承させる。
class CoffeeTooWeakError < StandardError; end
raise(CoffeeTooWeakError, "coffee to water ratio too low")



# もっと情報を提供するために
class TemperatureError < StandardError
  attr_reader(:temperature)

  def initialize (temperature)
    @temperature = temperature
    super("invalid temperature: #@temperature") # よくわからんがこれで式展開できるっぽい。
  end
end
raise(TemperatureError.new(180)) # クラスでもインスタンスでも動作する。内部で第一引数にexceptionメソッド（newの別名）を呼び出している。
# ただし、オブジェクトと例外メッセージをraiseの引数で渡すと、例外オブジェクトのメッセージが上書きされてしまう。



=begin
＜この項目で気づいたこと・学んだこと＞
・raiseに文字列のみを渡すのは避ける。RuntimeError例外になり、他のプログラマーにとって役に立たない。
・StandardErrorを継承する例外クラスを作って呼び出す。
・自作の例外クラスにinitializeを定義してメッセージを作るときは、superの引数としてメッセージを渡す。
・例外オブジェクトとメッセージを渡すと上書きされてしまうので注意。
=end
