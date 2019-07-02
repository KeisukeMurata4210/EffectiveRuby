# コアライブラリは標準でロードされる。標準ライブラリはもっと豊かだが、requireでロードする必要がある。

# ①配列を使う場合
class Role
  def initialize (name, permissions)
    @name, @permissions = name, permissions
  end

  def can? (permission)
    @permissions.include?(permission) # 配列を想定している。
  end
end
# 配列は数が多くなるほど処理が遅くなる。

# ②ハッシュを使う場合
class Role
  def initialize (name, permissions)
    @name = name
    @permissions = Hash[permissions.map {|p| [p, true]}] # 2次元配列をHash::[]の引数に渡すとハッシュが作れる
    # リストだけが必要でキー：値のペアはいらないとき、trueをよく使う。
  end

  def can? (permission)
    @permissions.include?(permission) # 配列を想定している。
  end
end
# 配列よりも速く探索できる。
# 重複した要素がある場合キーが重複する。そのため片方が失われる。
# Hashを作るために引数permissionsよりもっと大きな配列（２次元配列）を作っている。
#  => can?のコストをinitializeに肩代わりさせているので、can?を呼び出す回数が少なければ節約にならない。

# ③Setを使う場合
require('set')
class Role
  def initialize (name, permissions)
    @name, @permissions = name, Set.new(permissions)
  end

  def can? (permission)
    @permissions.include?(permission)
  end
end
# 処理の速さ、重複が失われること、can?の呼び出し回数が少なければ節約にならないこと、は②Hashの場合と同じ。
# 使いやすさという点でSetの方がいい


require('set')
require('csv')
class AnnualWeather
  Reading = Struct.new(:date, :high, :low) do  # Setも渡された要素を内部でHashに格納するからeql?とhashを定義
    def eql? (other) date.eql?(other.date); end # 日付をキーとするので一意性がある
    def hash; date.hash; end
  end

  def initialize (file_name)
    @readings = Set.new

    CSV.foreach(file_name, header: true) do |row|
      @readings << Reading.new(Date.parse(row[2]), # SetもArrayと同じく、<<で要素を追加する。Enumerableをインクルードしてるから。
                               row[10].to_f,
                               row[11].tof)
    end
  end
end
# Setでは順序の概念がなくなる。順序が必要ならSortedSetもある。



=begin
＜この項目で気づいたこと・学んだこと＞
・含まれているかどうかの高速チェックではSetを使う。
・Setに入れる要素はハッシュキーとしても使える必要があるので、eql?とhashを呼び出せることが必要。
・AnnualWeatherのコードめちゃくちゃ分かりやすいサンプル！！
=end
