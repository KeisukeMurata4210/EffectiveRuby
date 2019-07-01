require('csv')
class AnnualWeather
  def initialize (file_name)
    @readings = []

    CSV.foreach(file_name, headers: true) do |row| # ハッシュを使うと、どのキーがCSVのどの列に対応するか、都度ここに戻って確認する必要が出てしまう
      @readings << {
        :date => Date.parse(row[2]),
        :high => row[10].to_f,
        :low => row[11].to_f
      }
    end
  end

  def mean
    return 0.0 if @readings.size.zero?

    total = @readings.reduce(0.0) do |sum, reading|
      sum + (reading[:high] + reading[:low]) / 2.0 # <= この部分
    end

    total / @readings.size.to_f
  end
end



class AnnualWeather
  # 観測データを保持する新しいStructクラスを作る
  Reading = Struct.new(:date, :high, :low) 
  # Struct.new(メッセージ名のシンボル, ...)でStructクラスを定義した後、更にReading.new(対応する値, ...)でオブジェクトを作成する

  def initialize (file_name)
    @readings = []

    CSV.foreach(file_name, headers: true) do |row|
      @readings << Reading.new(Date.parse(row[2]), # 新しいクラスReadingのオブジェクトがどのメソッドに応答するかはっきりする
                               row[10].to_f,
                               row[11].to_f)
    end
  end

  def mean
    return 0.0 if @readings.size.zero?

    total = @readings.reduce(0.0) do |sum, reading|
      sum + (reading.high + reading.low) / 2.0  # タイプミスをした場合、ハッシュのキーはnilが返されるだけだが、Structを使うとNoMethodErrorが発生する
    end

    total / @readings.size.to_f
  end
end

# Structは自身にメソッドを定義できる。=> 各月ごとのmeanメソッドを作れる
Reading = Struct.new(:date, :high, :low) do
  def mean
    (high + low) / 2.0
  end
end
# インターフェース上の問題（ハッシュのキーが外部から見えてしまう）は解決したため、@readingsをattr_accessorで公開もできる


=begin
＜この項目で気づいたこと・学んだこと＞
・一定の規則で並んだデータは、HashじゃなくてStructを使う。
・一つ一つのデータについて、必要なデータや処理をStructのインスタンス変数とメソッドとして隠蔽する。かなりスッキリする。
・Structにメソッドの定義もできてかなりスッキリする！
=end
