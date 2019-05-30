def sum (enum)
  enum.reduce(0) do |accumulator, element| # 初期値を省略すると、enumの要素が一つもない時にnilを返してしまう。
    accumulator + element
  end
end

def sum (enum)
  enum.reduce(0, :+) # シンボルをメッセージ名、各要素を引数としてアキュムレーターにメッセージを送る。
end



Hash[array.map {|x| [x, true]}] # これは差分的ではない。おそらく、決められたメモリ数を確保してから要素を格納するから使わない領域が出てしまう、ということだと思われる。
array.reduce({}) do |hash, element| # これで差分的に作れるそう。
  hash.update(element => true) # updateはmergeのエイリアスメソッド
end



# ユーザーの配列をフィルタリングして出力の配列には21歳以上のユーザーしか含まれないようにする + ユーザーの配列を名前の配列に変換する
users.select {|u| u.age >= 21}.map(&:name) # userは User = Struct.new(:age, :name) にしてからUserのインスタンスを作ってるんだろうな。
users.reduce([]) do |names, user|
  names << user.name if user.age >= 21
  names
end
# reduceはアキュムレーターさえ返していれば、アキュムレーターと要素に自由に操作を加えられる



# このコードが
hash = {}
array.each do |element|
  hash[element] = true
end
# こう変わる
array.reduce({}) do |hash, element|
  hash.update(element => true)
end





=begin
＜この項目で気づいたこと・学んだこと＞
・reduce(inject)は、アキュムレーターさえ返していれば自由に操作ができる。コレクションクラスの全要素に対して操作をするときはreduceを使えないか考えよう。
・初期値は必ずセットする。nilを返さないようにするため。
=end
