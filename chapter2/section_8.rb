# インスタンス作成時に呼び出されるinitializeは、デフォルトではBasicObject#initializeという空メソッド
# ごく普通のプライベートメソッドのため、オーバーライドされると親クラスのものは実行されなくなる
class Parent
  attr_accessor(:name)
  def initialize
    @name = "Howard"
  end
end

class Child < Parent
  attr_accessor(:grade)
  def initialize
    @grade = 8
  end
end
# これだとインスタンス変数nameが初期化されない

class Child < Parent
  attr_accessor(:name, :grade)
  def initialize(name, grade)
    super (name)
    @grade = grade
  end
end
# これでよし。あとはsuperのくせ（特異クラスも探索対象になる）に気をつければ良い。

# initialize_copy：clone,dupメソッドを実行したとき、オブジェクトをコピーした後に呼び出される。
# このメソッドでも内部でsuperを呼び出し、親クラスが初期化されるようにする。


=begin
＜この項目で気づいたこと・学んだこと＞
・initializeもnewメソッド内部で呼び出されるだけで、通常のメソッドと同じ。
・superで親クラスの初期化を行う。
・initialize_copyを使う場合も同じ。
=end
