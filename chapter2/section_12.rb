# ①Object#==
"foo" == "foo" # => true
1 == 1.0 # => true 数値型は暗黙的にキャストする。


# ②Object#equal?
"foo".equal?("foo") # => false つのオブジェクトが同じメモリを指しているかどうかを判定する
# このメソッドに依存するクラスがあるのでオーバーライドしてはいけない。


# ③Object#eql? Object#equal?と同じ。 String#eql?はオーバーライドされ、==と同じ挙動をする
class Color
  def initialize (name)
    @name = name
  end
end
a = Color.new("pink")
b = Color.new("pink")
{a => "like", b => "love"} # => {#<Color:0x00007fd92f233ce0 @name="pink">=>"like", #<Color:0x00007fd92f2c9ec0 @name="pink">=>"love"}
# Hashクラスのキーが同じと判定されるのは、①キーの値のハッシュ値が同じ、かつ、②eql?メソッドで比較してtrueになるとき
# 内部ではObject#eql?が呼び出されるため、aとbのメモリを比較する。そのためaとbを違うキーであると判定する。

class Color
  attr_reader(:name)
  def initialize (name)
    @name = name
  end

  def hash
    name.hash # 今はそういうものだと割り切ろう 
  end

  def eql? (other)
    name.eql?(other.name) # String#eql?は==と同じ動作をするため、値が同じであればtrueを返す。
  end
end
a = Color.new("pink")
b = Color.new("pink")
{a => "like", b => "love"} 
# => {#<Color:0x00007fd92f248988 @name="pink">=>"love"}
# Object#==があるのにあえてObject#eql?が必要な理由は、==には暗黙的なキャストがある。そのため違うキーを同一視されてしまうと困るから。


# ④===
# case when文では、===で比較している。whenで渡されたものを左辺にしている。
/er/ === "Tyler" # => true  オーバーライドされたRegexp#===を呼び出している。
"Tyler" === /er/ # => false Object#===を呼び出している。Object#==の戻り値を返す。



[1,2,3].is_a?(Array) # => true
[1,2,3] === Array    # => false Object#===
Array === [1,2,3]    # => true  Array::=== ドキュメントには出てこないがクラスメソッドとして===を持っていて、右辺が自分と同じ型ならtrueを返す。


=begin
＜この項目で気づいたこと・学んだこと＞
・equal?はオーバーライドしてはいけない。オブジェクトが同じメモリを指す厳格な比較をする。それに依存するクラスがある。
・同じオブジェクトかを判定するならequal?、同じ値を比較するなら==で十分。
・ハッシュのキーを判定するときなど、内部的にはeql?が使われている。必要に応じてオーバーライドする。
・===は各組み込みクラスでオーバーライドされること前提に作られている。自分でオーバーライドすることはないだろう。
=end
