class Base
  def m1 (x, y)
  end
end

class Derived < Base
  def m1 (x)
    # superはメソッドではなくRuby言語のキーワード。()によって振る舞いを変える
    super (1, 2) # 1と2を渡して呼び出し
    super (x, y) # xとyを渡して呼び出し
    super x, y   # 上と同じ
    super        # !!xのみを渡して呼び出し（呼び出し元メソッドの引数を全て渡して呼び出し）
    super ()     # !!引数なしで呼び出し
  end
end



module CoolFeatures
  def feature_a
  end
end

class Vanilla
  include(CoolFeatures)
  def feature_a
    super
  end
end
# superは階層の上位に対して、通常のメソッド探索と同じ順序で同名のメソッドを探す。
# つまり特異クラスも探索経路に含まれるため、インクルードされたモジュールのメソッドもsuperで呼び出せる
# 逆に言えば、インクルードしたモジュールに同名メソッドが含まれていれば意図したメソッドを呼び出せない。設計ミス。



class SuperHappy
  def laugh
    super
  end
end
SuperHappy.new.laugh
# => NoMethodError: super: no superclass method `laugh' for #<SuperHappy:0x00007fd3f8a46f90>
# method_missingが誤ったsuperの呼び出しかどうかをチェックしてくれる。
# method_missingをオーバーライドすると、たとえその中でsuperを呼んだとしてもこの機能は失われる。



=begin
＜この項目で気づいたこと・学んだこと＞
・superはメソッドではない。()なしで呼ぶと呼び出し元メソッドの引数全てで、()で引数なしだと引数なしで呼び出す。
・探索の仕方は通常メソッドと同じため、インクルードしたモジュールのメソッド（特異メソッド）も呼び出せる。
・method_missingはオーバーライドしない！　便利な情報が失われてしまう。
=end
