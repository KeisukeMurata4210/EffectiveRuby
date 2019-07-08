errors.any? {|e| %w(F1 F2 F3).include?(e.code) }
# errors配列がn個の要素を持つなら、4n個以下のオブジェクトが作られる。
# 要素3つと配列1つ
# Rubyでオブジェクトが生成されるたびにガベージコレクションが実行される可能性がある。
# パフォーマンスの足を引っ張るボトルネックになる可能性がある。

# 定数に昇格させれば解決する
FATAL_CODES = %w(F1 F2 F3).map(&:freeze).freeze
def fatal? (errors)
  errors.any? {|e| FATAL_CODES.include?(e.code) }
end
# Ruby2.1より前なら定数に昇格させるやり方でOK

errors.any? {|e| e.code == "FATAL" } # 比較のためだけに使われ、すぐゴミになる文字列が繰り返し作られる
errors.any? {|e| e.code == "FATAL".freeze }
# Ruby2.1以降では、フリーズされた文字列リテラルは定数と同じになる。
# だから初めて呼び出されたときに単一の文字列を確保するだけになる。
# ただし文字列リテラルをフリーズしたときだけ。任意の文字列オブジェクトをフリーズしてもこの効果は得られない


=begin
＜この項目で気づいたこと・学んだこと＞
・オブジェクトが書き換えられないのなら、ループ内のオブジェクトリテラルを定数に昇格させる
・Ruby2.1以降のフリーズされた文字列リテラルは定数と同じになる。だからフリーズするだけでも上と同じメモリ効率化を期待できる。
=end