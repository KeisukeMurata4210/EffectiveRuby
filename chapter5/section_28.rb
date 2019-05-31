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
      def_delegator(target, method, target_method) # メソッド名_with_superという名前でターゲットオブジェクトのそのメソッドを呼び出せる。

      define_method(method) do |*args, &block|
        send(target_method, *args, &block)
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

=begin
＜この項目で気づいたこと・学んだこと＞

=end
