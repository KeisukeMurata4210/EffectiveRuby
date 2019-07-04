module A
  def who_am_i?
    "A#who_am_i?"
  end
end

module B
  def who_am_i?
    "B#who_am_i?"
  end
end

class C
  include(A)
  include(B)

  def who_am_i?
    "C#who_am_i?"
  end
end

C.ancestors # => [C, B, A, Object, Kernel, BasicObject]
# 先入れ後出しだから、上でインクルードしたAが後になる
C.new.who_am_i? # => "C#who_am_i?"

# prependを使う
class C
  prepend(A)
  prepend(B)

  def who_am_i?
    "C#who_am_i?"
  end
end
C.ancestors # => [B, A, C, Object, Kernel, BasicObject]
C.new.who_am_i? # => "B#who_am_i?"
# prependを使うと、レシーバの前にメソッドを挿入する。




=begin
＜この項目で気づいたこと・学んだこと＞
・includeはスーパークラスの前だが、prependはレシーバの前にメソッドを挿入する。
・最後にprependしたものが一番最初に呼ばれる
・それ以外の使い方はincludeと同じ。prependedフックもある。
=end
