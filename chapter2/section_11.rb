class Binding
  def initialize (style, options = {})
    @style = style
    @options = options
  end
end
# 何がまずいか。Bindingはコアライブラリにあるクラスで、それを書き換えてしまったことになる。
# 名前空間を作って区別する
module Notebooks  # 名前空間はディレクトリ構成と対応させる。今回は Notebooks/Binding.rb ということ
  class Binding
    # ...
  end
end
style = Notebooks::Binding.new

# すでに名前空間ができている場合などの短縮形は
class Notebooks::Binding
  # ...
end
# ただし名前空間ができてなければNameErrorが発生する。



module SuperDumbCrypto
  KEY = "password123"

  class Encrypt
    def initialize (key=KEY) # これはフルクラスパスなしで呼び出せる
      # ...
    end
  end
end

module SuperDumbCrypto
  KEY = "password123"
end
class Encrypt
  def initialize (key=KEY) # これはNameErrorが発生する。レキシカルスコープ内・継承階層経由のどちらもKEYが見つからないから
    # ...
  end
end

# これなら動く
module SuperDumbCrypto
  KEY = "password123"
end
class SuperDumbCrypto::Encrypt # SuperDumbCrypto内にクラスを定義
  def initialize (key=SuperDumbCrypto::KEY) # 継承階層を辿っていき、ObjectクラスからSuperDumbCrypto → KEYを見つけ出す。
    # ...
  end
end



module Cluster
  class Array
    def initialize (n)
      # 間違ったArray。SystemStackErrorが起こる。このArrayはCluster::Arrayを意味するから
      @disks = Array.new(n) {|i| "disk#{i}"}
      # こうすればOK。Object::Arrayは::Arrayに省略できる。
      @disks = ::Array.new(n) {|i| "disk#{i}"}
    end
  end
end

=begin
＜この項目で気づいたこと・学んだこと＞
・モジュールで名前空間を作ろう。
・名前空間はディレクトリ構成と同じにする。
・トップレベルの定数はObjectクラスに格納されている。だから明示的にトップクラスの定数やクラスを使うときは::Arrayなどと書く。
=end
