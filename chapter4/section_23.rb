begin
  task.perform
rescue => e
  logger.error("task failed: #{e}")
  # 例外を飲み込み、タスクを中止する。
end
# ほとんど全てのエラーを飲み込んでしまう。AgumentError, LocalJumpErrorのようなコードミスも含めて。

begin
  task.perform
rescue AgumentError, LocalJumpError,
       NoMethodError, ZeroDivisionError
  raise # rescue内でraiseを呼び出すと、呼び出し元に戻る。そうしないとrescue内の処理を実行するだけ。
rescue => e
  logger.error("task failed: #{e}")
  # 例外を飲み込み、タスクを中止する。
end
# 先に範囲の広い例外をキャッチしてしまうかもしれない。そうなると貴重なヒントを失ってしまう。
# 意図が伝わりにくい。そのため後で消されるかもしれない。

# 自作の例外クラスを作るメリットがここではっきりする
begin
  task.perform
rescue NetworkConnectionError => e
  # 再試行のロジック
rescue InvalidRecordError => e
  # サポートスタッフにレコードを送る
end

# 例外全般を捕まえる時の注意点
begin
  task.perform
rescue NetworkConnectionError => e
  # 再試行のロジック
rescue InvalidRecordError => e
  # サポートスタッフにレコードを送る
rescue => e
  service.record(e)
  raise
ensure
  # ...
end
# 注意：rescue節の中で例外が発生すると、元の例外情報を捨てて新しい例外処理が始まってしまう。

# 元の例外を引数として受け取る専用メソッドを作って、raiseでその例外を送れば解消する
def send_to_support_staff (e)
  begin
    service.record(e)
  rescue
    raise(e)
  end
end
# 元の例外の方が大切、という前提での処理



=begin
＜この項目で気づいたこと・学んだこと＞
・修復の仕方がわかっている例外だけをrescueする。
・より限定されたものからrescueする。
・StandardErrorのような汎用例外をrescueするときは、ensureを使いたいときだと考えてみる。
・rescueで例外が発生すると、新しい例外が現在の例外を押しのけてしまう。専用メソッドで隔離して、そこでraiseで例外オブジェクトeを送る
=end
