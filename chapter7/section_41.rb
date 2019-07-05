# これを「.irbrc」に定義すると自動でインデントが入る
IRB.conf[:AUTO_INDENT] = true

# 「.irbrc」独自のirbコマンドも定義できる
module IRB::ExtendCommandBundle
  def time (&block)
    t1 = Time.now
    result = block.call if block
    diff = Time.now - t1
    puts("Time: " + diff.to_f.to_s)
    result
  end
end

# 直前の実行結果は「_」という変数に格納されている
[1,2,3].pop   # => 3
last_elem = _ # => 3

# セッション irbの中でirbを立てられる。self変数の中身が変わる
#irb(main):022:0> self.class
#=> Object
#irb(main):023:0> irb [1,2,3]
#irb1([1, 2, 3]):001:0> self.class
#=> Array
#irb#1([1, 2, 3]):002:0> length
#=> 3




=begin
＜この項目で気づいたこと・学んだこと＞
・ホームディレクトリに「.irbrc」を作成すれば、便利なことができる。
　インデント、独自コマンドの作成など
・IRB::ExtendCommandBundleモジュールか、それに独自モジュールをインクルードするかすればいい
・直前の実行結果は「_」に格納されている。
・irbの中でirbを立てられる。中に入りたいオブジェクトを引数にしてirbを再度実行すればいい
=end
