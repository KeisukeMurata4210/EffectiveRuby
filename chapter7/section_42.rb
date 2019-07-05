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






=begin
＜この項目で気づいたこと・学んだこと＞

=end
