"foo" == "foo" # => true
"foo".equal?("foo") # => false Object#equal?は、二つのオブジェクトが同じメモリを指しているかどうかを判定する
1 == 1.0 # => true Object#==は、数値型は暗黙的にキャストする。
# Object#equal?に依存するクラスがあるので、これをオーバーライドしてはいけない。

# Hashクラスでキーが同じと判定するのは、①キーの値のハッシュ値が同じ、かつ、②eql?メソッドで比較してtrueになるとき
class Color
  def initialize (name)
    @name = name
  end
end
a = Color.new("pink")
b = Color.new("pink")
{a => "like", b => "love"} 
# => {#<Color:0x00007fd92f233ce0 @name="pink">=>"like", #<Color:0x00007fd92f2c9ec0 @name="pink">=>"love"}



class Color
  attr_reader(:name)
  def initialize (name)
    @name = name
  end

  def hash
    name.hash
  end

  def eql? (other)
    name.eql?(other.name) # String#eql?は==と同じ動作をするため、値が同じであればtrueを返す。
  end
end
a = Color.new("pink")
b = Color.new("pink")
{a => "like", b => "love"} 
# => {#<Color:0x00007fd92f248988 @name="pink">=>"love"}
# あえてeql?メソッドがある理由は、暗黙的なキャストで同一視されるとキーの識別の場合では困るから



# case when文では、===で比較している。whenで渡されたものを左辺にしている。
/er/ === "Tyler" # => true  オーバーライドされたRegexp#===を呼び出している。
"Tyler" === /er/ # => false Object#===を呼び出している。Object#==の戻り値を返す。



[1,2,3].is_a?(Array) # => true
[1,2,3] === Array    # => false Object#===
Array === [1,2,3]    # => true  Array::===
# ドキュメントには出てこないが、クラスメソッドとしての===を持っていて、右辺が自分と同じ型ならtrueを返す。


=begin
＜この項目で気づいたこと・学んだこと＞
・equal?はオーバーライドしてはいけない。オブジェクトが同じメモリを指す厳格な比較をする。それに依存するクラスがある。
・同じオブジェクトかを判定するならequal?、同じ値を比較するなら==で十分。
・ハッシュのキーを判定するときなど、内部的にはeql?が使われている。必要に応じてオーバーライドする。
・===は各組み込みクラスでオーバーライドされること前提に作られている。自分でオーバーライドすることはないだろう。
=end
