puts "true:#{true.class}"
puts "false:#{false.class}"

x = nil
if false == x
  puts "it's false"
end

class Bad
  def == (other)
    true
  end
end

puts "#{false == Bad.new} FalseClass#==を呼び出す"
puts "#{Bad.new == false} Object#==を呼び出す。オーバーライドしている可能性あり"

=begin
＜この項目で気づいたこと・学んだこと＞
・nilとfalse以外はtrueになる
・falseとnilを区別するためfalseを判定するときは、falseを左辺に書く。FalseClass#==を呼び出した方が、オーバーライドで挙動が変わるリスクが少ない
=end