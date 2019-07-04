def pass (&block); block; end
# ただ単に、引数として受け取ったブロックを返すだけ。引数のブロックはProcクラスのインスタンスに変換されるから、戻り値はProcになる。
greeter = pass {|name| "Hello #{name}"} # => #<Proc:0x00007fb8928e1410@(irb):8> ほら。
greeter.call("World") # => "Hello World"

# 強いProc：引数の数が違えばArgumentErrorが出る。
# 弱いProc：引数は気にしない。多ければ無視する、少なければnilを当てる。
# ブロックは「弱い」Proc、Lambdaは「強い」Proc



=begin
＜この項目で気づいたこと・学んだこと＞

=end
