class SetMe
  def initialize
    @value = 0
  end

  def value
    @value
  end

  def value= (x) # これが、セッターメソッドの呼び出しか変数への代入か紛らわしい時がある
    @value = x
  end
end



class Counter
  attr_accessor(:counter)
  def initialize
    counter = 0      # これはセッターの呼び出しにも思えるが、ローカル変数への代入
    self.counter = 0 # これはセッターの呼び出し。レシーバを明示的に追加する規則によって識別している
  end
end



class Name
  attr_accessor(:first, :last)
  def initialize (first, last)
    self.first = first
    self.last = last
  end

  def full
    self.first + " " + self.last # このselfはムダ。レシーバがない場合暗黙的にselfをレシーバにする
  end
end

=begin
＜この項目で気づいたこと・学んだこと＞
・インスタンスメソッドからセッターを呼び出すときはselfをつける。
・それ以外の場合ではselfは要らない。selfをつけすぎてコードを汚さないこと。
=end
