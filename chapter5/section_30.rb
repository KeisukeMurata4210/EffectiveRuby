# method_missingの代替策はほぼ必ずある

# Forwardableモジュールを使わずに移譲するとき、method_missingが次善の策に思える。
class HashProxy
  def initialize
    @hash = {}
  end

  private
    def method_missing (name, *args, &block)
      if @hash.respond_to?(name)
        @hash.send(name, *args, &block)
      else
        super
      end
    end
end
# 実質インターフェースが無くなってしまう。
h = HashProxy.new
h.respond_to?(:size) # => false
h.size # => 0 実際は反応する
h.public_methods(false) # => []
# これは階層構造を全て探して見つからなかった場合に初めてmethod_missingが呼び出される。
# イントロスペクションメソッドはObjectのものが呼び出されるため、method_missingが呼び出されない。

# define_methodで置き換える
class HashProxy
  Hash.public_instance_methods(false).each do |name|
    define_method(name) do |*args, &block|
      @hash.send(name, *args, &block)
    end
  end

  def initialize
    @hash = {}
  end
end
# よくなった
h = HashProxy.new
h.respond_to?(:size) # => true
h.public_methods(false).sort.take(5) # => [:<, :<=, :==, :>, :>=]


# デコレータクラスを書く時にもmethod_missingが使えるが。。。
require('logger')
class AuditDecorator
  def initialize (object)
    @object = object
    @logger = Logger.new($stdout) # 標準出力に
  end

  private
    def method_missing (name, *args, &block)
      @logger.info("calling '#{name}' on #{@object.inspect}") 
      @object.send(name, *args, &block)
    end
end
# 移譲の場合と同じく、イントロスペクションを使えない。
# classのようなメソッドを通過させることもできない。

# define_methodを使う
require('logger')
class AuditDecorator
  def initialize (object)
    @object = object
    @logger = Logger.new($stdout)

    mod = Module.new do
      object.public_methods.each do |name| # @objectとしてしまうと、モジュール固有の変数@objectを探してしまう。だからobject
        define_method(name) do |*args, &block|
          @logger.info("calling '#{name}' on #{@object.inspect}")
          @object.send(name, *args, &block)
        end
      end
    end

    extend(mod) # 無名モジュールを作成してextendするという処理をinitialize内で行うことで、objectのメソッドが全て「現在の」AuditDecoratorインスタンスのメソッドになる
  end
end
# 転送されている。全て無名モジュールに転送され、そこでログ出力を伴って"I'm a String!"に転送されている。
fake = AuditDecorator.new("I'm a String!")
# I, [2019-07-02T15:07:38.955253 #3457]  INFO -- : calling 'inspect' on "I'm a String!"
# => "I'm a String!"
fake.downcase
# I, [2019-07-02T15:07:45.348711 #3457]  INFO -- : calling 'downcase' on "I'm a String!"
# => "i'm a string!"
fake.class
# I, [2019-07-02T15:08:02.270377 #3457]  INFO -- : calling 'class' on "I'm a String!"
# => String

require('logger')
class AuditDecorator
  def initialize (object)
    @object = object
    @logger = Logger.new($stdout)

    @object.public_methods.each do |name|
      define_singleton_method(name) do |*args, &block|
        @logger.info("calling '#{name}' on #{@object.inspect}")
        @object.send(name, *args, &block)
      end
    end
    # define_methodはクラスとモジュールしか反応しない。define_singleton_methodはオブジェクトに反応する。つまりこの行は、自分自身（AuditDecoratorインスタンス）に直接メソッドを定義しているのと同じ。
    # 上の無名モジュールを使うやり方は、インスタンスの特異メソッドを定義している事になる。インスタンス自信をレシーバとして呼び出すから、結局インスタンスメソッドを定義したのと同じ。
  end
end

# これで@hashが応答するメソッドであれば、response_to?で確認した時にtrueを返せる
def respond_to_missing? (name, include_private)
  @hash.respond_to?(name, include_private) || super
end


=begin
＜この項目で気づいたこと・学んだこと＞
・method_missingではなくdefine_methodを使う
・どうしても使うときはresponse_to_missingとの併用を考える。
=end
