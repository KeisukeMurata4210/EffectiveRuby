# 項目21のRaisingHashで、freeze,taint,untaintをより簡単にする
module SuperForwardable
  # モジュールフック
  def self.extended (klass) # extendされると、extend先のオブジェクトを引数にしたextendedメソッドが呼ばれる。
    require('forwardable')
    klass.extend(Forwardable) # Object#extend 特異クラスにモジュールを取り込む
  end

  # superを呼び出す委譲ターゲットを作る
  def def_delegators_with_super (target, *methods)
    methods.each do |method|
      target_method = "#{method}_with_super".to_sym
      def_delegator(target, method, target_method) # メソッド名_with_superという名前でターゲットオブジェクトのそのメソッドを呼び出せるようにする。

      define_method(method) do |*args, &block| # このブロックはインスタンスメソッドmethod(=freeze, taint, untaint)を定義するだけ。
        send(target_method, *args, &block) # self.sendとなり、selfは被extendオブジェクト（＝RisingHash）。
        # このRaisingHashクラスへのtarget_method呼び出しは、上のdef_delegatorによってtarget(=@hash)へのmethod呼び出しになる
        super(*args, &block)
      end
    end
  end
end
# RaisingHash
class RaisingHash
  extend(SuperForwardable)
  def_delegators(:@hash, :[], :[]=, :delete, :each,
                 :keys, :values, :length,
                 :empty?, :has_key?)
  def_delegator(:@hash, :delete, :erase!)# これはdef_delegators_with_superで呼び出すべきかな
  def_delegators_with_super(:@hash, :freeze, :taint, :untaint)
  def initialize
    @hash = Hash.new do |hash, key|
      raise(KeyError, "invalid key '#{key}'!")
    end
  end

  def initialize_copy (other)
    @hash = @hash.dup
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



# 継承時に親クラスで呼ばれるフックinheritedを使って継承を禁止する。
module PreventInheritance
  class InheritanceError < StandardError; end

  def inherited (child) # そう。extendすればクラスメソッドになるからこれでOK
    raise(InheritanceError, "#{child} cannot inherit from #{self}")
  end
end
Array.extend(PreventInheritance)
class BetterArray < Array; end # => PreventInheritance::InheritanceError: BetterArray cannot inherit from Array
# inheritedフックが実行されたときは、まだ子クラスは完全には定義されてない。



class InstanceMethodWatcher
  def self.method_added (m); end
  def self.method_removed (m); end
  def self.method_undefined (m); end

  # method_added(:hello)呼び出しを引き起こす
  def hello; end

  # method_removed(:hello)呼び出しを引き起こす
  remove_method(:hello)

  # method_added(:hello)呼び出しを引き起こす
  def hello; end

  # method_undefined(:hello)呼び出しを引き起こす
  undef_method(:hello)
end

class SingletonMethodWatcher
  def self.singleton_method_added (m); end     # 定義した時点でsingleton_method_addedが呼び出される。
  def self.singleton_method_removed (m); end   # 定義した時点でsingleton_method_addedが呼び出される。
  def self.singleton_method_undefined (m); end # 定義した時点でsingleton_method_addedが呼び出される。

  # singleton_method_added(:hello)呼び出しを再び引き起こす
  def self.hello; end

  # singleton_method_removed(:hello)呼び出しを再び引き起こす
  class << self; remove_method(:hello); end

  # singleton_method_added(:hello)呼び出しを再び引き起こす
  def self.hello; end

  # singleton_method_undefined(:hello)呼び出しを引き起こす
  class << self; undef_method(:hello); end
end
# クラスメソッド＝特異クラスのメソッドだから、<< self で追加している。




=begin
＜この項目で気づいたこと・学んだこと＞
・全てのフックはクラスメソッドとして実装する。
・フックメソッドが内部で呼び出しているメソッドはオーバーライドしない。
・singleton_method_addedを定義すると、自分自身の呼び出しが発生する。
=end
