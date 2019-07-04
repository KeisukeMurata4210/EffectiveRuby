def pass (&block); block; end
# ただ単に、引数として受け取ったブロックを返すだけ。引数のブロックはProcクラスのインスタンスに変換されるから、戻り値はProcになる。
greeter = pass {|name| "Hello #{name}"} # => #<Proc:0x00007fb8928e1410@(irb):8> ほら。
greeter.call("World") # => "Hello World"

# 強いProc：引数の数が違えばArgumentErrorが出る。
# 弱いProc：引数は気にしない。多ければ無視する、少なければnilを当てる。
# ブロックは「弱い」Proc、Lambdaは「強い」Proc
def test; yield("a"); end
test {|x, y, z| [x, y, z]} # => ["a", nil, nil] 期待する引数3つ：残り2つはnilで補う。
test {"b"}                 # => "b"             期待する引数0個：渡された"a"は無視される。

# Lambda：強いProc
func = ->(x) {"Hello #{x}"} # 機体する引数1個
func.call("a", "b")  # => ArgumentError: wrong number of arguments (given 2, expected 1)

# lambda? 強いProcだとtrue,弱いProcだとfalse
def test (&block); block.lambda?; end
test {|x| x} # => false
test(& ->(x){x}) # => true


class Stream
  def initialize (io=$stdin, chunk=64*1024)
    @io, @chunk = io, chunk
  end

  def stream (&block)
    loop do
      start = Time.now
      data = @io.read(@chunk)
      return if data.nil?

      time = (Time.now - start).to_f
      block.call(data, time) # I/OオブジェクトからProcにデータをストリーミングする
    end
  end
end

def file_size (file)
  File.open(file) do |f|
    bytes = 0
    s = Stream.new(f)
    s.stream {|data| bytes += data.size} # loop内でこのブロックが何度も実行される
    bytes
  end
end

require('digest')
def digest (file)
  File.open(file) do |f|
    sha = Digest::SHA256.new
    s = Stream.new(f)
    s.stream(&sha.method(:update)) # Object#method はMethodオブジェクトを返す。&をつけるとそれを強いProcオブジェクトに変換できる。
    sha.hexdigest
  end
end
# 呼び出し時に引数を2つ渡すので例外が発生する。

func = ->(x, y=1){x+y}
func.arity   # => -2
~ func.arity # => 1
# Method#arity　可変長引数やオプション引数の場合「-(必要とされる引数の数 + 1)」を返す。funcだと必須は1つだから、「-2」

# 引数の個数の違いに対応させる
class Stream
  def initialize (io=$stdin, chunk=64*1024)
    @io, @chunk = io, chunk
  end

  def stream (&block)
    loop do
      start = Time.now
      data = @io.read(@chunk)
      return if data.nil?
  
      arg_count = block.arity
      arg_list  = [data]
  
      if arg_count == 2 || ~arg_count == 2 # 引数が2つの時に限り、2つ目の引数として時間情報を渡す
        arg_list << (Time.now - start).to_f
      end
  
      block.call(*arg_list)
    end
  end
end
require('digest')
def digest (file)
  File.open(file) do |f|
    sha = Digest::SHA256.new
    s = Stream.new(f)
    s.stream(&sha.method(:update)) # Object#method はMethodオブジェクトを返す。&をつけるとそれを強いProcオブジェクトに変換できる。
    sha.hexdigest
  end
end


=begin
＜この項目で気づいたこと・学んだこと＞
・ブロックは弱いProcで引数の数を無視する、lambdaは強いProcで引数に厳密。ArgumentErrorを発生する。
・Method#arityでメソッドの個数を調べられる。負の数ならオプション引数があるってこと。
=end
