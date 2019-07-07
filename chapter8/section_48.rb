# メモ化。こういうやつ
def current_user
  @current_user ||= User.find(logged_in_user_id)
end
# User.find(logged_in_user_id) は一回しか呼び出されない
# 優先順位は「=」>「||」だから
# これと同じ
@current_user || @current_user = User.find(logged_in_user_id)


def shipped? (order_id)
  file = fetch_confirmation_file 

  if file
    status = parse_confirmation_file(file)
    status[order_id] == :shipped
  end
end
# 品物を出荷したかどうかチェックするたびに、ファイルを取り出して中身を確認してしまう。

# こうする
def shipped? (order_id)
  @status ||= begin # beginブロックも最後の行の実行結果を返す。こんな便利な使い方もできる。
    file = fetch_confirmation_file
    file ? parse_confirmation_file(file) : {}
  end
  @status[order_id] == :shipped
end

# 注意点として、どのくらいの時間キャッシングすべきか
# nilをセットしてメモ化をリセットすることも検討する
def lookup (key)
  @cache ||= {} # 必ず@cacheが存在するようにする

  @cache[key] ||= begin
    # ...
  end
end

# また、メモ化したオブジェクトを更新したり書き換えたりした場合、それらの更新はメモ化部分が返すオブジェクトに反映される

=begin
＜この項目で気づいたこと・学んだこと＞
・まずプロファイリングして、メモ化が必要かどうか考える
・メモ化によって処理が省略されたり、更新が別の場所で見られるようになったりすることの副作用を考える。
・フリーズ化したオブジェクトを返させる方法もある。
=end
