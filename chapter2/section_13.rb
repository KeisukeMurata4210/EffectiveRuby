class Version
  attr_reader(:major, :minor, :patch)
  def initialize (version)
    @major, @minor, @patch = 
      version.split('.').map(&:to_i)
  end
end
vs = %w(1.0.0 1.11.1 1.9.0).map {|v| Version.new(v)}
# => [#<Version:0x00007fd23aa72830 @major=1, @minor=0, @patch=0>, #<Version:0x00007fd23aa726c8 @major=1, @minor=11, @patch=1>, #<Version:0x00007fd23aa72510 @major=1, @minor=9, @patch=0>] 
vs.sort # Array#sortは内部でModule#<=>を呼び出し、結果にしたがって並び替える
# => ArgumentError: comparison of Version with Version failed

# デフォルトでは同じオブジェクトかどうかを調べ、同じなら0、Rubyのメソッド探索順で左辺が先なら-1、後なら1、階層上の関係がなければnil
# とはいえ数値の大小は扱ってくれる。いやこれ、数値型のクラスでオーバーライドされてるから？ ドキュメントには出てこないけど。
9 <=> "9" # => nil
9 <=> 10  # => -1
10 <=> 9  # => 1
10 <=> 10 # =< 0



# これで並び変えが成功する
class Version
  include(Comparable) # これで、同じ基準で< <= == > >= を使えるようになる。さらにbetween?(a, b)メソッドも使えるようになる。
  attr_reader(:major, :minor, :patch)
  def initialize (version)
    @major, @minor, @patch = 
      version.split('.').map(&:to_i)
  end

  def <=> (other)
    return nil unless other.is_a?(Version)
  
    [ major <=> other.major,
      minor <=> other.minor,
      patch <=> other.patch,
    ].detect {|n| !n.zero?} || 0 # Enumerable#detect(find) ブロックがtrueを返したら繰り返しを中断し、その要素を返す。全てfalseならnilを返す
  end
end
vs = %w(1.0.0 1.11.1 1.9.0).map {|v| Version.new(v)}
# => [#<Version:0x00007faf4e3a59d0 @major=1, @minor=0, @patch=0>, #<Version:0x00007faf4e3a57c8 @major=1, @minor=11, @patch=1>, #<Version:0x00007faf4e3a56b0 @major=1, @minor=9, @patch=0>]
vs.sort
# => [#<Version:0x00007faf4e3a59d0 @major=1, @minor=0, @patch=0>, #<Version:0x00007faf4e3a56b0 @major=1, @minor=9, @patch=0>, #<Version:0x00007faf4e3a57c8 @major=1, @minor=11, @patch=1>]

# Comparableをインクルードするときの注意。
# ==に暗黙のキャストをさせたいときは==をオーバーライドするか、<=>が0を返す条件を変える
#  == >= <= に一貫した答えを返したいときは<=>が0を返す条件を変える
#  一貫性がなくて良いなら==をオーバーライドする。



# VersionをHashのキーとして使うには、
#  eql?メソッドを==の別名にする。デフォルト実装ではequal?と同じことをするため、<=>をオーバーライドした環境では役に立たない
#  hashメソッドの定義
class Version
  # ...
  alias_mathod(:eql?, :==)

  def hash
    [major, minor, patch].hash # Array#hash
  end
end




=begin
＜この項目で気づいたこと・学んだこと＞
・比較のルールを変えたいときは、<=>をオーバーライドする。
・さらに他の演算子も変更したいならComparableをインクルードする。
・<=>が内部でどう使われているか把握してからオーバーライドする。
・（ほぼ無さそうだけど）ハッシュのキーとして使うには、eql?を==の別名にし、hashメソッドを実装する
=end
