module Defaults
  # NETWORKS = ["192.168.1", "192.168.2"]        <= 要素の追加や削除ができてしまう
  # NETWORKS = ["192.168.1", "192.168.2"].freeze <= 要素自体の変更は防げない
  NETWORKS = [
    "192.168.1",
    "192.168.2"
  ].map!(&:freeze).freeze # <= オブジェクト自体はフリーズできても、それを参照する定数NETWORKSに値が代入されるときは警告のみで、例外は発生しない
end

Defaults.freeze # <= こうすることで定数NETWORKSへの代入も防げる

def purge_unreachable (networks=Defaults::NETWORKS) # 代入=は右辺のポインタを渡すから、代入されたものを変更すると呼び出し元も変更される
  networks.delete_if do |net| # 定数なのにdeleteされるよ。定数というよりグローバル変数
    !ping(net + ".1")
  end
end

def host_addresses (host, networks=Defaults::NETWORKS)
  networks.map {|net| net << "#{host}"} # String#<<はレシーバ自信を変更する
end

=begin
＜この項目で気づいたこと・学んだこと＞
・定数として使うときは全てフリーズする
　①オブジェクト
　②そのオブジェクトが配列やハッシュの場合、ここの要素
　③定数を定義したクラスやモジュール
=end
