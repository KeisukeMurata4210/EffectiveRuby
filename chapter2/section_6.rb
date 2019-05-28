class Person
  def name
    'name'
  end
end

class Customer < Person
end

customer = Customer.new
customer.class # => Customer
Customer.superclass # => Person
customer.respond_to?(:name) # => true
# 上に登ってメソッドを探す
# 見つからなかったらもう一度出発点に戻り、method_missingメソッドを探す



module ThingsWithNames
  def name
    'name'
  end
end

class Person
  include(ThingsWithNames)
end

Person.superclass # => Object
customer = Customer.new
customer.respond_to?(:name) # => true
# includeすると、被インクルードクラスに特異クラスを作り、定数とメソッドを共有する
# 特異クラスは無名で見えないので、階層構造には含まれない
# 後入れ先出し＝最後にミックスインしたモジュールから先にメソッドを探す
# モジュールで被インクルードクラスのメソッドをオーバーライドすることはできない。まずクラスをチェックしてからモジュールに向かう



customer = Customer.new
def customer.name
  "Leonard"
end
# これは「特異メソッド」を定義している。
# 特異クラスを作成→インスタンスメソッドとしてnameメソッドをインストール→customerオブジェクトのクラスとしてこの無名クラスを挿入
# クラスは多くのオブジェクトのために働いているが、特異クラスはそのオブジェクト一つのために働く



class Customer < Person
  def self.where_am_i?
  end
end
Customer.singleton_class.instance_methods(false) # => [:where_am_i?] 
# singleton_classは特異クラスを返す
# *instance_methodsはインスタンスメソッド名の配列を返し、falseにすると親クラス分は含まれない
Customer.superclass                 # => Person
Customer.singleton_class.superclass # => <Class:Person>
# クラスメソッドは、クラスの特異クラスのインスタンスメソッド、として格納される


=begin
＜この項目で気づいたこと・学んだこと＞
・ミックスインしたとき、特異メソッドを定義したときに特異クラスが作られる。
・特異クラスのインスタンスメソッドは通常のメソッドと同じ階層のメソッドとして共有される。
・特異クラスという仕組みのおかげで、Rubyのメソッド探索が階層を登るだけのシンプルなものになっている。
=end
