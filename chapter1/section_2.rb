puts 13.to_s
puts nil.to_s

def fix_title(title)
  title.to_s.capitalize
end

puts fix_title("aaa")
puts fix_title(nil)

puts nil.to_a # => []
puts nil.to_i # => 0
puts nil.to_f # => 0.0

middle = nil
name = ["first", middle, "last"].compact.join(" ") # Array#compact は、レシーバーをコピーしたものから全てのnilを取り除いたものを返す
puts name

=begin
＜この項目で気づいたこと・学んだこと＞
・nilかもしれないという前提で、型変換メソッドを呼んでおく
=end