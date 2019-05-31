class DownLoaderBase
  def self.inherited (subclass)
    handlers << subclass
  end

  def self.handlers
    @handlers ||= [] # クラスインスタンス変数！！
  end

  private_class_method(:handlers) # クラスメソッドをプライベートなものに変える
end

# モジュールをinclude/extendした時にモジュール側のinheritedフックも呼び出されるように、superをつけよう。
class DownLoaderBase
  def self.inherited (subclass)
    super
    handlers << subclass
  end

  def self.handlers
    @handlers ||= [] # クラスインスタンス変数！！
  end

  private_class_method(:handlers) # クラスメソッドをプライベートなものに変える
end
# これはフック全般に言えること



=begin
＜この項目で気づいたこと・学んだこと＞
・クラスフックの中にはsuper呼び出しを入れる。
=end
