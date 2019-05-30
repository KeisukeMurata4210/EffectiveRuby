file = File.open(file_name, 'w')
# ...
file.close
# 途中で例外が発生しても、ガベージコレクタのお陰で「最終的には」閉じられる
# タイムリーに解放するのが望ましい。

begin
  file = File.open(file_name, 'w')
  # ...
ensure
  file.close if file # beginと同じスコープで実行されるので、beginで定義した変数fileを使える。ただし、初期化前の可能性があるのでif文をつけている。
end
# ensureは正常でも例外でも実行されるので、メモリ解放に最適

# リソース管理できるデザインイディオムがある
File.open(file_name, 'w') do |file|
  # ...
end
# ファイルはブロックに渡され、ブロックを抜けるとファイルは閉じられる。内部でensureを実行している。

# File::openのイディオムを自作する。
class Lock
  def self.acquire
    lock = new # リソースを初期化
    lock.exclusive_lock!
    yield(lock) # リソースをブロックに与える
  ensure              # メソッド単位でrescue / ensureの例外処理ができる。
    # ロックを確実に解除する
    lock.unlock if lock
  end
end
# 呼び出し時
Lock.acquire do |lock|
  # ...
end

# ブロックがないときはFile::openと同じく解除はしなくする
class Lock
  def self.acquire
    lock = new
    lock.exclusive_lock!

    if block_given? # ブロックが付けられているかどうか判定するヘルパーメソッド
      yield(lock)
    else
      lock　# Lock::newのように動作する
    end
  ensure
    if block_given?
      # ロックを確実に解除する
      lock.unlock if lock
    end
  end
end
lock = Lock.acquire # 自動的なロック解除を行わない。



=begin
＜この項目で気づいたこと・学んだこと＞
・File::openはブロック付きで呼び出すと、ブロック終了時にリソース解放をしてくれる。
・File::openと同じくリソース管理を抽象化するには、クラスメソッドでyield / ensureパターンを使う。
・ensure内で使う変数は、初期化されているかどうか確かめる。
=end
