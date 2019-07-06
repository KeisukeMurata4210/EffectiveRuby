# bundlerのインストール。gemの一つだから。
gem install bundler

# Gemfileを作成する
bundle init

# Gemfileに書き込んだgemをインストール
bundle install


# bundlerで管理されたgemを使う方法
# 1つずつrequireする
require('bundler/setup')
require('id3tag')
require('json')

# まとめてrequireする
require('bundler/setup')
Bundler.require

# 環境ごとにまとめて分ける方法
# @Gemfile
group(:production) do
  gem('id3tag', '0.8.0')
  gem('json',   '1.8.3')
end
# @ソースコード
require('bundler/setup')
Bundler.require(:production)

# gemを作るとき（mp3jsonというgemを作る）
bundle gem mp3json
# => 実行したディレクトレリ配下に同名のディレクトリが作られる
# その中に「Gemfile」「mp3json.gemspec」

# gemspecメソッド mp3json.gemspecに書き込まれた依存情報が、Gemfileにも書き込まれているふりをする

# Gemfile.lockはgem作成では作らない

=begin
＜この項目で気づいたこと・学んだこと＞
・Gemfileでgroup(:環境)ブロックの中にgemを書けば、コードでrequire('bundler/setup); Bundler.require(:環境)と書けばそれらをまとめてrequireできる
・gemを作るときはGemfile.lockを作らない
=end
