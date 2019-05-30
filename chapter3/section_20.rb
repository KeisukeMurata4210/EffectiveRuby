def frequency (array)
  array.reduce({}) do |hash, element|
    hash[element] ||= 0 # キーが必ず存在するようにする。nilは嫌
    hash[element] += 1
    hash
  end
end

def frequency (array)
  array.reduce(Hash.new(0)) do |hash, element| # 初期値を0にしちゃえばいいじゃん。
    hash[element] += 1
    hash
  end
end



# Hashとデフォルト値
h = Hash.new(42)
h[:missing_key] # => 42
h.keys # => []
h[:missing_key] += 1 # == h[:missing_key] = h[:missing_key] + 1 存在しないキーmissing_keyにアクセスして42を取り出し、それに1加えて同じキー名として格納
h.keys # => [:missing_key]

h = Hash.new([]) # 初期値として空の配列をセット
h[:missing_key] # => []
h[:missing_key] << "Hey, there!" # これは要素を追加したのではなく、初期値[]を書き換えた。
h.keys # => []
h[:missing_key] # => ["Hey, there!"] ここではmissing_keyをキーにした値を取り出しているのではなく、キーが空で初期値が返されている
h[:ss]          # => ["Hey, there!"]

h = Hash.new([])
h[:weekdays] = h[:weekdays] << "Monday" # 初期値[]に"Monday"を追加。戻り値として返されるのは初期値を指すポインタ
h[:months] = h[:months] << "January"    # だからこの処理で、初期値だけでなくh[:weekdays]の値も書き換わる
h.keys # => [:weekdays, :months]
h[:weekdays] # => ["Monday", "January"]
h.default    # => ["Monday", "January"]

h = Hash.new { [] } # 初期値を指定するのではなく、初期値が必要な時にブロックを実行する。
h[:weekdays] = h[:weekdays] << "Monday" # この時h[:weekdays]が返すのは初期値でなく、ブロックで新しく作成された空の配列
h[:months] = h[:months] << "January"
h[:weekdays] # => ["Monday"]
# 代入とは変数にポインタを紐づけてアクセスできるようにすること！ すごく腑に落ちたぞ！

h = Hash.new {|hash, key| hash[key] = []} # Hash自体とアクセスされたキーを引数にとることができる。
h[:weekdays] << "Monday"
h[:weekdays]  # => ["Monday"]
h[:holidays]  # => []
h.keys # => [:weekdays, :holidays]
# このコードの欠点は、存在しないキーにアクセスするたびにそのキーが追加され、空の配列が値として格納されること。
if hash[key]
  # ...
end
# この条件式が常に成功してしまう。
# has_key?を使う癖をつける！

# fetchを使うと、キーが見つからなかった場合の戻り値を第二引数に指定できる。
# 第二引数を省略した時にキーが見つからなかったら例外を発生させる。
h = {}
h[:weekdays] = h.fetch(:weekdays, []) << "Monday" # => ["Monday"]
h[:weekdays] # => ["Monday"]
h.fetch(:missing_key) # => KeyError: key not found: :missing_key
h[:missing_key] # => nil
# デフォルト値がnilになることを前提としたコードにハッシュを渡すときは、デフォルト値を変えるのではなくfetchを使う。



=begin
＜この項目で気づいたこと・学んだこと＞
・nilが返ることを前提としたコードを書いてはいけない！ has_key?メソッドを使うこと。
・Hash::newの引数やブロックによるデフォルト値 + has_key?メソッドでのチェック、で書くのが理想。
・ただし他のコードでデフォルト値nilを前提にしていたら、fetchを使う。
=end
