# 向こうのサーバーでデッドロックエラーがよく起きるとする
begin
  service.update(record)
rescue VendorDeadLockError
  sleep(15)
  retry # retryはbegin以下を再度実行
end
# retryはループだから、条件なしで書くと無限ループのようになる。以下と同じ。
while true
  begin
    service.update(record)
  rescue VendorDeadLockError
    sleep(15) # 例外を捨てる。
  else
    break # 成功。ループを抜ける。
  end
end

# こうする。
retries = 0 # retryはbegin節をやり直すので、境界変数はbeginの外に定義する。
begin
  service.update(record)
rescue VendorDeadLockError
  raise if retries >= 3
  retries += 1
  sleep(15)
  retry
end
# 改善点
# ①最初の方に起きた例外を捨ててしまっている。そのため1回目に例外で失敗し、2回目に異なる例外で処理が失敗した場合、原因となった1回目の例外を見つけられない。
# ②ネットワーク接続エラーを再試行するときは、間隔を指数的に増やすのが一般的。ただし最初の数字は小さくすること。
# ただアクセスし続けると問題が悪化する、という考えもある。

# こうする。
retries = 0
begin
  service.update(record)
rescue VendorDeadLockError => e
  raise if retries >= 3
  retries += 1
  logger.warn("API failure: #{e}, retrying...") # ①再試行前の例外を記録する。
  sleep(5 ** retries) # ②間隔を指数的に増やす。
  retry
end



=begin
＜この項目で気づいたこと・学んだこと＞
・retryで再試行させるときは、回数制限を設ける、
・直前の例外をログに書いておく、
・間隔は増やしていく
=end
