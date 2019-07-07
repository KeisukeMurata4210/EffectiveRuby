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
# total ms/call：メソッドが呼び出しにかけている平均の時間
# cumulative seconds：メソッドが呼び出しにかけている時間の合計



=begin
＜この項目で気づいたこと・学んだこと＞
・パフォーマンスの低いコードを書き換えるときは、プロファイリングツールを使って証拠を集める
・ruby-profを使う。高速で、異なるレポートを作れる。
・Ruby 2.1以降なら、stackprof, memory_profilerを検討する
=end
