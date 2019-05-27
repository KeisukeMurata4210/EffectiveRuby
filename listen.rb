require 'listen'

# 新しいファイルを作ったら、自動でコメントを記述する
listener = Listen.to('chapter1', 'chapter2', 'chapter3', 'chapter4', 'chapter5', 'chapter6', 'chapter7', 'chapter8') do |modified, added, removed|
  if added[0] && added[0].match(/^*\.rb$/)
    File.open(added[0], 'a') do |f|
      f.puts("\n\n\n")
      f.puts("=begin")
      f.puts("＜この項目で気づいたこと・学んだこと＞")
      f.puts("\n")
      f.puts("=end")
    end
  end
end
listener.start
sleep