class Tuner
  def initialize (presets)
    @presets = presets
    clean
  end

  private
    def clean
      # 有効な周波数は、末尾が奇数
      @presets.delete_if {|f| f[-1].to_i.even?}
    end
end
presets = %w(90.1 106.2 88.5) # => ["90.1", "106.2", "88.5"]
tuner = Tuner.new(presets) # => #<Tuner:0x00007fcd299bad68 @presets=["90.1", "88.5"]>
presets  # => ["90.1", "88.5"]
# Rubyは引数が参照渡しのため、ネストした先で引数を書き換えると呼び出し元も変わってしまった！となることがある。

# delete_ifでなくArray#rejectを使う手もある
class Tuner
  def initialize (presets)
    @presets = clean(presets)
    clean
  end

  private
    def clean (presets)
      # 有効な周波数は、末尾が奇数
      presets.reject {|f| f[-1].to_i.even?} # Array#reject は、戻り値がtrueの要素を除いた新しい配列を返す
    end
end
# しかし、初期化した後で書き換えが必要な時に同じ問題が発生してしまう。



# cloneとdup cloneは全てコピーするが、dupは①フリーズ状態②特異メソッドはコピーしない。
# 書き換えることが前提なら、dupを使う。
class Tuner
  def initialize (presets)
    @presets = presets.dup
    clean # コピーを書き換える。
  end

  private
    def clean
      # 有効な周波数は、末尾が奇数
      @presets.delete_if {|f| f[-1].to_i.even?}
    end
end



# シャローコピー：コピー元とコピー先が同じメモリを参照している
# ディープコピー：コピー元とコピー先の参照先が違う。メモリそのものからコピーを作る。
# コレクションオブジェクトに対してclone / dupを呼び出すと、コンテナ自体はディープコピーだが要素はシャローコピーになる。
a = ["Polar"]
b = a.dup << "Bear" # => ["Polar", "Bear"]   この時、aの"Polar"とbの"Polar"は同じメモリを参照している。
b.each {|x| x.sub!('lar', 'oh')} # => ["Pooh", "Bear"]
a # => ["Pooh"]  だからaも書き換わってしまう

a = ["Monkey", "Brains"]
b = Marshal.load(Marshal.dump(a)) # これで要素のディープコピーが作れる
b.each(&:upcase!)
b # => ["MONKEY", "BRAINS"]
a # => ["Monkey", "Brains"]
# Marshalを使うと、コレクションが大きい場合メモリと時間を大食いする。
# Fileクラス、IOクラスはMarshalに対応していない。dumpメソッドでTypeErrorが出る。


=begin
＜この項目で気づいたこと・学んだこと＞
・コレクションを引数として渡すときはclone / dupでコピーを作る
・要素はシャローコピーしか作れないが、ほぼそれで事足りる
・ディープコピーを作るときはMarshalを使う。
=end
