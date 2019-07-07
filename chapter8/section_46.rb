ruby -rprofile Rubyファイル名
# -rでrequireしたのと同じ効果がある。
# -rprofileでprofileライブラリをrequireしてからファイルを実行する、
%   cumulative   self              self     total
time   seconds   seconds    calls  ms/call  ms/call  name
 0.00     0.00      0.00        1     0.00     0.00  TracePoint#enable
 0.00     0.00      0.00        2     0.00     0.00  IO#set_encoding
 0.00     0.00      0.00        2     0.00     0.00  IO#write
 0.00     0.00      0.00        1     0.00     0.00  IO#puts
 0.00     0.00      0.00        1     0.00     0.00  Kernel#puts
 0.00     0.00      0.00        1     0.00     0.00  TracePoint#disable
 0.00     0.01      0.00        1     0.00    10.00  #toplevel

# メソッドaがメソッドbを呼び出すとき、aを親、bを子と考える。
# total ms/call：



=begin
＜この項目で気づいたこと・学んだこと＞

=end
