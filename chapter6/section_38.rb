require('uri')
class Monitor
  def initialize (server)
    @server = server
  end

  def alive?
    echo = Time.now.to_f.to_s
    response = get(echo)
    response.success? && response.body == echo
  end

  private
    def get(echo)
      url = URI::HTTP.build(host: @server, path: "/echo/#{eho}")
      HTTP.get(url.to_s)
    end
end
# このalive?メソッドをどうやってテストする？

require('minitest/autorun')
class MonitorTest < Minitest::Test
  def test_successful_monitor
    monitor = Monitor.new("example.com")
    response = MiniTest::Mock.new

    monitor.define_singleton_method(:get) do |echo| # privateメソッドより特異メソッドの方が先に呼び出されるのか
      response.expect(:success?, true)
      response.expect(:body, echo)
      response
    end

    assert(monitor.alive?, "should be alive")
    response.verify # モックオブジェクトのメソッドのうち、一つでも呼び出されていないものがあれば例外を発生させる
  end

  def test_failed_monitor
    monitor = Monitor.new("example.com")
    response = MiniTest::Mock.new

    monitor.define_singleton_method(:get) do |echo|
      response.expect(:success?, false)
      response
    end
    # &&は左辺が失敗した時点で判定を中断するから、success?がfalseを返すだけで良い。
    # もしbodyが呼び出されたらNoMethodErrorを出してくれる

    refute(monitor.alive?, "shouldn't be alive")
    response.verify
  end
end




=begin
＜この項目で気づいたこと・学んだこと＞
・面白い。モックを使うことを知っていれば、samuraiで外部サーバー連携のテストのためにやりとりしなくてもよかった。サーバーからのレスポンスをモックで作ってテストできたんだ。
・モックを使う箇所はgemはコアライブラリなど、プロジェクト外のコードにする。その部分はテストしない、ということになるから。
=end
