# 例外を制御フローのために使いたいとき。
# 場合によっては推奨される
loop do
  answer = ui.prompt("command: ")
  raise(StopIteration) if answer == 'quit'
  # ...
end

# こんなとき
begin
  @characters.each do |character|
    @colors.each do |color|
      if player.valid?(character, color)
        raise(StopIteration)
      end
    end
  end
rescue StopIteration
  # ...
end

# catch throwでこう書ける
match = catch(:jump) do
  @characters.each do |character|
    @colors.each do |color|
      if player.valid?(character, color)
        throw(:jump, [character, color])
      end
    end
  end
end
# 必須なのはcatchとthrowで同じラベル（ここでは:jump）を使うこと。ないとNameError
# 第二引数に渡した値がcatchブロックの戻り値になる。省略した場合はnilが返る。
# throwを実行しない場合は最後の行の実行結果が返される。



=begin
＜この項目で気づいたこと・学んだこと＞
・制御フローで例外を使いたいときはcatch throwを使う。
・その前に、メソッドとreturnで書き換えられないか考えてみる。
=end
