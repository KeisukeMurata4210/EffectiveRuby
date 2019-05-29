class Pizza
  def initialize (toppings)
    toppings.each do |topping| # 引数がeachに応答する型だと想定している。もしtoppingsがコレクションじゃなく単一オブジェクトだったら？ nilだったら？
      add_and_price_topping(topping)
    end
  end
end
Array("Betelgeuse")        # => ["Betelgeuse"]
Array(nil)                 # => []
Array(['Nadroj', 'Retep']) # => ["Nadroj", "Retep"]
# ここまでは凄く良いが
Array({pepperoni: 20, jalapenos: 2}) # => [[:pepperoni, 20], [:jalapenos, 2]]
# Hashインスタンスを渡すとネストした配列に変換されてしまう。
# そもそもハッシュの配列を使うときは、Structクラスを使おう。（項目10）



class Pizza
  def initialize (toppings)
    Array(toppings).each do |topping|
      add_and_price_topping(topping)
    end
  end
end
# Arrayメソッドを使うだけで、トッピングの配列、単一のトッピング、トッピングなしのどれにも対応できるようになった。


=begin
＜この項目で気づいたこと・学んだこと＞
・型を揃えることでエラーに強くする、という考え方が大切。to_iなどやArrayメソッド。
・配列を受け取るからダックタイプ、と短絡的に考えるのではなく、Arrayメソッドを使うことも考えよう。
=end
