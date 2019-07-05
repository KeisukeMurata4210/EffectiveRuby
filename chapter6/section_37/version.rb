class Version
  include(Comparable) # これで、同じ基準で< <= == > >= を使えるようになる。さらにbetween?(a, b)メソッドも使えるようになる。
  attr_reader(:major, :minor, :patch)
  def initialize (version)
    @major, @minor, @patch = 
      version.split('.').map(&:to_i)
  end

  def <=> (other)
    return nil unless other.is_a?(Version)
  
    [ major <=> other.major,
      minor <=> other.minor,
      patch <=> other.patch,
    ].detect {|n| !n.zero?} || 0 # Enumerable#detect(find) ブロックがtrueを返したら繰り返しを中断し、その要素を返す。全てfalseならnilを返す
  end
end