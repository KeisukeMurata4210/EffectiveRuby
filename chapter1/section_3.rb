def extract_error (message)
  if message ~= /^ERROR:\s+(.+)$/
    $1 #グローバル変数のように見えるが、「特殊グローバル変数」という、現在のスレッドとメソッド内にスコープが限られるもの
  else
    "no error"
  end
end

def edited_extract_error (message)
  if m = message.match(/^ERROR:\s+(.+)$/)
    m[1]#戻り値はMatchDataオブジェクトというローカル変数で、ローカル変数らしい名前をつけられる
  else
    "no error"
  end
end
# $: は $LOAD_PATH （requireメソッドでロードされるライブラリを探す時に参照するディレクトリを表す文字列配列）

while readline
  print if ~ /^ERROR:/
end
# 標準入出力のKernel#readline Kernel#gets はグローバル変数$_にも書き込む。
# Kernel#printは引数を省略すると、$_変数の内容を標準出力に書き出す。
# Regexp#~は、$_変数の内容を右辺にマッチさせようとする。
# => 一言で言って、わかりずらい

=begin
＜この項目で気づいたこと・学んだこと＞
・正規表現のチェックはString#matchを使う
・$: じゃなくて $LOAD_PATHを使う
・グローバル変数$_を読み書きするメソッドは使わない（Kernel#readline, Kernel#print, Regexp#~）
=end
