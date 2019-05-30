class LikeArray < Array
end

x = LikeArray.new([1, 2, 3])
y = x.reverse
y.class # => Array reverseは新しいArrayインスタンスを返す
LikeArray.new([1, 2, 3]) == [1, 2, 3] # => true 比較演算子はサブクラス、スーパークラスを認めてしまう。
# コレクションクラスを継承すると、クラスにもともとあったメソッドが予想外の結果を返すことがある。
# そこで移譲の出番。　継承した上でいらない部品を取り除くのではなく、外部の部品からクラスを組み立てる。



require('forwardable')
class RaisingHash
  extend(Forwardable) # extendは「そのインスタンス」への追加になる。 extendすることでdef_delegatorsを呼び出せる。
  include(Enumerable)
  def_delegators(:@hash, :[], :[]=, :delete, :each,
                 :keys, :values, :length,
                 :empty?, :has_key?)
  # 第一引数のオブジェクトに、第二引数以降のインスタンスメソッド呼び出しを転送する。
  # 第一引数はメソッド名でも、そのメソッドがターゲットになるオブジェクトを返却すれば動作する。
end
# 継承を使うと呼び出されたくないメソッドはundef_methodで隠すか、privateにするしかない。

# def_delegatorsを使うと、同名のメソッドが自身に定義されたことになる。それに別名をつけたいときは
def_delegator(:@hash, :delete, :erase!) # 単数形！ 第三引数のメソッド呼び出しを、第一引数のオブジェクトへの第二引数メソッドの呼び出しに転送する。

# def_delegatorsで呼び出すオブジェクトを初期化処理で定義する　＋　ハッシュに対して無効なキーが呼び出されたときは例外を発生させたい
def initialize
  @hash = Hash.new do |hash, key| # raising_hash[:missing_key] => 移譲されて@hash[:missing_key]を呼び出し、このブロックが実行される。
    raise(KeyError, "invalid key '#{key}'!")
  end
end
# Hashとしてのデータはインスタンス変数@hashに持たせているのか。

# 新しいHashを返すメソッドinvertを、RaisingHashインスタンスを返すように修正する。
def invert
  other = self.class.new
  other.replace!(@hash.invert)
  other # この時点で@hashの上書きが完了していて、改めて新しいRaisingHashインスタンスを返す
end
protected
def replace! (hash)
  hash.default_proc = @hash.default_proc # default_proc Hash::newのブロックを返す =が付くのはセッター
  @hash = hash # invertして、ブロックをコピーした上で@hashを上書きする。
end

# clone / dupされた時に、@hashもコピーされる必要がある。
def initialize_copy (other)
  @hash = @hash.dup # オブジェクトをコピーすると、同じインスタンス変数を持つ新しいオブジェクトを作る。だから左辺の@hashはコピー元と同じもの。
end



# 完成！
require('forwardable')
class RaisingHash
  extend(Forwardable)
  include(Enumerable)
  def_delegators(:@hash, :[], :[]=, :delete, :each,
                 :keys, :values, :length,
                 :empty?, :has_key?)
  def_delegator(:@hash, :delete, :erase!)
  def initialize
    @hash = Hash.new do |hash, key|
      raise(KeyError, "invalid key '#{key}'!")
    end
  end

  def initialize_copy (other)
    @hash = @hash.dup
  end

  # それぞれ、@hashにも同じ処理をする。
  def freeze
    @hash.freeze
    super
  end

  def taint
    @hash.taint
    super
  end

  def untaint
    @hash.untaint
    super
  end

  def invert
    other = self.class.new
    other.replace!(@hash.invert)
    other
  end
  protected
  def replace! (hash) # @hashのデフォルト値のブロックをコピーする処理
    hash.default_proc = @hash.default_proc
    @hash = hash
  end
end



=begin
＜この項目で気づいたこと・学んだこと＞
・コレクションクラスを複製するときは、継承じゃなくて委譲を使う。
・clone / dup のためinitialize_copyでインスタンス変数をコピーする
・freeze, taint, untaintをオーバーライドし、ターゲットのインスタンスにも同じことを行う
=end
