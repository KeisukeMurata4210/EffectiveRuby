# ensure節は、例外は実行される理由の一つでしかない。
def tricky
  # ...
  return 'horses'
ensure
  return 'ponies' # ensure節のreturn は、発生した例外を握りつぶして正常なフローに戻してしまう。
end
# これは裸のrescueを書くのに近い
def hammer
  # ...
  return 'hit'
rescue
  # 例外を捨てる。ただしStandardErrorとそのサブクラス以外は捨てられず、呼び出し元に戻る。
  return 'smash'
end
# ensure~returnは、文字通り全ての例外を捨ててしまう。

# ensureを使わず、rescueとの組み合わせで意図をはっきりさせる
def explicit
  # ...
  return 'horses'
rescue SpecificError => e
  # この例外を処理して正常なフローに戻す。
ensure
  # クリーンアップのみ
end

# rescue内のreturnは正常か例外かで戻り値を書き換えるが、ensure内のreturnは正常例外関係なく戻り値を書き換えてしまう。

# さらに、反復処理を変更するnext breakをensure節に入れると、分かりにくく例外を捨てる
items.each do |item|
  begin
    raise TooStrongError if item == 'lilac'
  ensure
    next # 例外を捨てて、反復処理を続行
  end
end



=begin
＜この項目で気づいたこと・学んだこと＞
・制御フローの変更はensureではなく、rescueで行う。その方が意図が伝わる。
・とにかく、処理できる例外のみをrescueでキャッチし、それ以外は呼び出し元に返す。
=end
