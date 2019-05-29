# コアライブラリは標準でロードされる。標準ライブラリはもっと豊かだが、requireでロードする必要がある。

class Role
  def initialize (name, permissions)
    @name, @permissions = name, permissions
  end

  def can? (permission)
    @permissions.include?(permission) # 配列を想定している。
  end
end
# 配列は数が多くなるほど処理が遅くなる。含まれているかどうかをチェックするだけならもっといい方法がある。
# 探索時間はHashの方が短い。



class Role
  def initialize (name, permissions)
    @name = name
    @permissions = Hash[permissions.map {|p| [p, true]}] # リストだけが必要でキー：値のペアはいらないとき、trueをよく使う。配列の配列を渡すとよしなになる。
  end

  def can? (permission)
    @permissions.include?(permission) # 配列を想定している。
  end
end
# 配列を使うときのトレードオフ2つ
# ①重複する要素は失われる。今回のpermissionsの場合は問題なし。
# ②Hashを作るために引数permissionsよりもっと大きな配列を作っている。
#  => can?のコストをinitializeに肩代わりさせているので、can?を呼び出す回数が少なければ節約にならない。



require('set')
class Role
  def initialize (name, permissions)
    @name, @permissions = name, Set.new(permissions)
  end

  def can? (permission)
    @permissions.include?(permission)
  end
end
# Hashを使う場合と要件は同じで、can?を呼び出す回数がinitializeより多いこと。
# 要素が含まれているかどうかを調べるにはSetが一番いい。パフォーマンスと使いやすさから。
# Setも渡された要素をHashに格納する。permission => true, のような形で変換する、ということ。

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
