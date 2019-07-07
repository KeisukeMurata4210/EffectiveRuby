class Resource
  def self.open (&block)
    resource = new
    block.call(resource) if block
  ensure
    resource.close if resource
  end
end
# ensure節が終わったあとでもリソースを保持したいときはどうするか。
# デストラクタ：コンストラクタ（≒initialize）の逆で、オブジェクトが破棄されるときに実行されるメソッド（人間から見て破棄されたタイミング）
# ファイナライザ：「ガベージコレクタ」がオブジェクトを破棄したときに実行されるメソッド（ガベージコレクタから見て破棄されたタイミング）

# Rubyのファイナライザ：オブジェクトが破棄された後に呼び出されるProcオブジェクト

class Resource
  # マニュアルの（危険な）インターフェース
  def initialize
    @resource = allocate_resource # 守っているリソースを作って返す
    finalizer = self.class.finalizer(@resource)
    ObjectSpace.define_finalizer(self, finalizer) # ObjectSpace.#define_finalizer 第一引数のオブジェクトが解放されるときに実行されるファイナライザ procを登録する
  end

  def close
    ObjectSpace.undefine_finalizer(self) # ObjectSpace.#undefine_finalizer 引数のオブジェクトに対するファイナライザを全て解除し、オブジェクトを返す
    @resource.close
  end

  # リソースを開放するために使えるProcを返す
  def self.finalizer (resource)
    lambda {|id| resource.close}
  end
end

# ガベージコレクタ：実行中のプログラムからキーに到達できなくなるとオブジェクトを破棄する。この破棄までに時間がかかることがある。
def initialize
  @resource = allocate_resource
  # 絶対だめ！
  finalizer = lambda {|id| @resource.close} # self変数も使用可能になる。そうすると、ガベージコレクタはオブジェクトをいつも到達可能とマークしてしまう。
  ObjectSpace.define_finalizer(self, finalizer)
end
# だから「self.class.finalizer(@resource)」こう書く。self変数はクラスを参照するため、現在のResourceオブジェクトを参照しない。

# define_finalizerの第二引数として渡されるProcオブジェクトが、ファイナライズしようとしているオブジェクトを参照できるコンテキストの中で作成されると
# そのオブジェクトを解放できなくなる。

# ファイナライザのProcオブジェクトとして使われるlambdaは引数を一つ受け取ることになっている。
# この引数は破棄されるオブジェクトではなく、最近破棄されたオブジェクトのID

# ファイナライザのProcが生成する例外は無視される。

# ObjectSpace.#define_finalizer は何回でも呼び出せる。ObjectSpace.#undefine_finalizerを呼び出すと登録されたファイナライザは全てまとめて削除される

# ガベージコレクタはできる限り低い頻度で実行されるように最適されている。またファイナライザは優先度の低い仕事
# だからensure節でリソースを閉じる方法の方がはるかによい


=begin
＜この項目で気づいたこと・学んだこと＞
・こういうテクニックが実装に必要になる時をイメージできない
=end
