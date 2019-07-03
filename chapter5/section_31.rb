def glass_case_of_emotion
  x = "I'm in a " + __method__.to_s.tr('_', ' ') # Kernel.#__method__は現在のメソッド名を返す
  binding # このメソッド内の状態をキャプチャして返す
end

x = "I'm in scope"
eval("x") # => "I'm in scope"
eval("x", glass_case_of_emotion) # => "I'm in glass case of emotion" 
# だからここではx == "I'm in glass case of emotion"となる。そしてevalで文字列xがコードとして実行されるため、この実行結果になる。


class Widget
  def initialize (name)
    @name = name
  end
end
# instance_evalはレシーバのインスタンスの元でブロックを実行する。
w = Widget.new("Muffler Bearing")
w.instance_eval {@name} # => "Muffler Bearing"
w.instance_eval do
  def in_stock?; false; end # 「レシーバのインスタンスの元で」メソッドを定義すると、そのインスタンスのみのメソッド、つまり特異メソッドになる。
end
w.singleton_methods(false) # => [:in_stock?]  （singleton_methodsは特異メソッドを集めて返す）

# 同じ理屈で、クラスに対してinstance_evalを使ってメソッドを定義すると、クラスの特異メソッド、つまりクラスメソッドが定義される。
Widget.instance_eval do
  def table_name; "widgets"; end
end
Widget.table_name # => "widgets"
Widget.singleton_methods(false) # => [:table_name]

# 特異メソッドではなくインスタンスメソッドを定義したいときはclass_evalを使う。
Widget.class_eval do
  attr_accessor(:name) # class end の間に書けることはなんでも定義できる
  def sold?; false; end
end
w = Widget.new("Blinker Fluid")
w.public_methods(false) # => [:name, :name=, :sold?] （public_methodsはパブリックなメソッドを集めて返す）
# class_evalはクラスかモジュールをレシーバにしないと使えない。module_evalというメソッドも動作は同じ。


# instance_eval / class_evalはブロックにレシーバを渡す
class Widget
  attr_accessor(:name, :quantity)
  def initialize (&block) # ①newのブロックを受け取る。
    instance_eval(&block) if block # ②レシーバself（新しく作られたWidgetインスタンス）をブロックに渡してブロック実行
  end
end
w = Widget.new do |widget| # ③このブロックがnewで作成されたインスタンスをwidgetとして実行される。
  widget.name = "Elbow Grease" # ④インスタンスメソッドの様に内部インスタンス変数を操作できる。
  @quantity = 0
end
[w.name, w.quantity] # => ["Elbow Grease", 0]


# execバージョンは、ブロックだけを受け取る。
class Counter
  DEFAULT = 0
  attr_accessor(:counter)
  def initialize (start=DEFAULT)
    @counter = start
  end

  def inc
    @counter += 1
  end
end
# @counterを0に戻す処理を書き、他のクラスでも使えるようにするとする
module Reset
  def self.reset_var (object, name)
    object.instance_eval("@#{name} = DEFAULT")
  end
end
c = Counter.new(10)
Reset.reset_var(c, "counter") # => 0 
# 変数名として不正なものを入力してみる
Reset.reset_var(c, "x;")      # => SyntaxError: (eval):1: syntax error, unexpected '=', expecting end-of-input
# 存在しない変数を指定してみる。
Reset.reset_var(c, "x") # => 0
c # => #<Counter:0x00007fc1f803fea0 @counter=0, @x=0> ！インスタンスcの内部で「@x = DEFAULT」を実行したことになり、インスタンス変数@xが作られている。

# instance_exec
module Reset
  def self.reset_var (object, name)
    object.instance_exec("@#{name}".to_sym) do |var| # BasicObject#instance_exec 引数の値をブロックに渡す。ブロック内ではレシーバ（object）がself
      const = self.class.const_get(:DEFAULT) # Module#const_get 引数で表される定数の値を取得する
      instance_variable_set(var, const) # Object#instance_variable_set　変数varにconstをセットする。
      # selfが補われてself==objectなので、objectのインスタンス変数var==@#{name}の値を更新する
    end
  end
end
Reset.reset_var(c, "x;") # => NameError: `@x;' is not allowed as an instance variable name
Reset.reset_var(c, "y")
c # => => #<Counter:0x00007fc1f803fea0 @counter=0, @x=0, @y=0>  ！新しい変数が作られるのは同じ


=begin
＜この項目で気づいたこと・学んだこと＞
・instance_eval / instance_exec でメソッドを定義すると特異メソッドになる。
・だから、クラスをレシーバとしてこれらを使ってメソッドを定義するとクラスメソッドになる。
・class_eval / class_exec / module_eval / module_exec でメソッドを定義するとインスタンスメソッドになる。
・上の4つはクラスかモジュールしかレシーバにできない。
=end
