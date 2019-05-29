class Widget
  def overlapping? (other)
    x1, y1 = @screen_x, @screen_y
    x2, y2 = other.instance_eval {[@screen_x, @screen_y]} # Object#instance_eval 渡されたブロックをレシーバのインスタンスの元で実行する。
    # ...
  end
end
# otherのインスタンス変数にどうアクセスするか？（上のコードだとアクセスできない）

class Widget
  def overlapping? (other)
    x1, y1 = screen_coordinates
    x2, y2 = other.screen_coordinates
  end

  protected
    def screen_coordinates
      [@screen_x, @screen_y]
    end
end
# private レシーバを使えない。
# protected 呼び出し元とレシーバが継承を介して同じインスタンスメソッドを共有している場合に呼び出せる。

# Matzさん
# 「privateは自分からしか見えないメソッドであるのに対して、protectedは一般の人からは見られたくないが、仲間からは見えるメソッドです。
#  protectedは例えば2項演算子の実装にもう一方のオブジェクトの状態を知る必要があるか調べる必要があるが、そのメソッドをpublicにして、
#  広く公開するのは避けたいというような時に使います。」

=begin
＜この項目で気づいたこと・学んだこと＞
・継承階層を共有している仲間同士で内部の情報を伝え合いたい時にprotectedを使う。
・例えば2項演算子で相手方の情報を知る時など。
=end
