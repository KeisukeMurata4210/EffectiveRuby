# Rubyはインタプリタ言語だから、全てのことが実行時におこる
# 例1
class Widget; end
w = Widget.new
#w.seed(:name) # これがWidgetのメソッドではなかった場合、タイプミスなのか、モンキーパッチやライブラリのロードで使えるものなのか、見分けがつかない
# 例2
#def update (location)
#  @status = location.description
#end
# locationとdescriptionの間には例1と同じ疑問がわく。
# さらに、locationとは何のオブジェクトか、nilだったら、それらを警告する方法はあるか、などの疑問がわく。

# 実行してみるしかない。ただしテストコードを書くことを通して。

# 不合格になるべき状況でも合格してしまうテストは簡単に書けてしまう。

# ハッピーパステスト：正常に動く条件の元で意図した通りに動くことを確かめるテスト


# ファズテスト：さまざまなデータを送り込んでクラッシュや例外を狙うテスト
require('fuzzbert')
require('uri')
fuzz('URI::HTTP::build') do
  data("random, server names") do
    FuzzBert::Generators.random
  end
  deploy do |data|
    URI::HTTP.build(host: data, path: '/')
  end
end
# https://github.com/krypt/FuzzBert
# fuzzbert "ファイル名"   半永久的に実行する
# fuzzbert --limit 回数 "ファイル名" 指定した回数実行する


# プロパティテスト：ランダムなデータを送り込むだけでなくコードが指定されたように振る舞うかどうかもテストする
class Version
  def initialize (version)
    @major, @minor, @patch =
      version.split('.').map(&:to_i)
  end

  def to_s
    [@major, @minor, @patch].join('.')
  end
end

require('mrproper')
properties("Version") do
  data([Integer, Integer, Integer])

  property("new(str).to_s == str") do |data|
    str = data.join('.')
    assert_equal(str, Version.new(str).to_s)
  end
end
# 

=begin
＜この項目で気づいたこと・学んだこと＞
・ハッピーテストと例外テストの両方を試すために、ファズテスト（fuzzbert）とプロパティテスト（mrproper）を使う。
・テストの手法や技術などを学びたい。
・テストコードを書きながらコーディングできるようになりたい。
=end
