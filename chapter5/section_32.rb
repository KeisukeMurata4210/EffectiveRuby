# モンキーパッチは危険。正常なコードを書いても、誰かが標準のはずの動作を変えているためにエラーになる事が起こりうる。
# そうなったら修正はとてつもなく大変。

# 文字列が空、あるいは空白文字だけになってるかどうかテストする。モンキーパッチの次善の策として。
module OnlySpace
  ONLY_SPACE_UNICODE_RE = %r/\A[[:space:]]*\z/

  def self.only_space? (str)
    if str.ascii_only? # String#ascii_only? 文字列がASCII文字のみで構成されている場合にtrueを返す
      !str.bytes.any? {|b| b != 32 && !b.between?(9, 13)}
    else
      ONLY_SPACE_UNICODE_RE === str
    end
  end
end
# 「オブジェクト指向的でない」「饒舌（くどい）」
OnlySpace.only_space?("\r\n") # => true


# インスタンスメソッドバージョンのonly_space?を定義する
module OnlySpace
  ONLY_SPACE_UNICODE_RE = %r/\A[[:space:]]*\z/

  def self.only_space? (str)
    if str.ascii_only? # String#ascii_only? 文字列がASCII文字のみで構成されている場合にtrueを返す
      !str.bytes.any? {|b| b != 32 && !b.between?(9, 13)}
    else
      ONLY_SPACE_UNICODE_RE === str
    end
  end

  def only_space?
    # モジュール関数に転送
    OnlySpace.only_space?(self) 
  end
end
str = "Yo Ho!"
str.extend(OnlySpace)
str.only_space?  # => false
# ！上の例では「\r\n」が空白かどうかをチェックしていた
# こちらのバージョンでは、自身をモジュール関数の引数として渡している

# モンキーパッチを使わず、モジュールで拡張した文字列以外は影響を受けない。
# しかし一貫性が崩れてしまう。

# そこで新しいStringクラスを作成する。
require('forwardable')
class StringExtra
  extend(Forwardable)
  def_delegators(:@string, 
                  *String.public_instance_methods(false)) # 「*」は引数を配列にまとめて渡すときの書き方
  # 確かにこうすれば、いちいち書かずに済む！

  def initialize (str="")
    @string = str
  end

  def only_space?
    # ...
  end
  # あとは、Stringを返してしまうメソッドのオーバーライド、freeze、taintなどのメソッド追加すれば完了
end

# それでもまだ、コアクラスを書き換えたいときはRefineMents
module OnlySpace
  refine(String) do # パッチを当てる
    def only_space?
      # ...
    end
  end
end

class Person
  using(OnlySpace) # これでアクティブ化する

  def initialize (name)
    @name = name
  end

  def valid?
    !@name.only_space? # Personを継承するクラスのインスタンスから、直接only_space?は呼び出せない。valid?なら呼び出せ、動作する。
  end

  def display (io=$stdout)
    io.puts(@name) # puts内に入った途端に非アクティブ化される。
  end
end
# 上のコードだとPerson内でしかアクティブにならない。これがモンキーパッチより安全な理由


=begin
＜この項目で気づいたこと・学んだこと＞
・コアクラスを書き換えたいときは、まずラップクラスの作成を考える。
・それで足りないときはRefinementsを使う。
・Refinementsを使うときは、①Rubyのバージョン、②レキシカルスコープごとにusingでモジュールをアクティブ化、に注意する。
=end
