module LogMethod
  def log_method (method)
    # メソッドのために新しい一意な名前を選択する
    orig = "#{method}_without_logging".to_sym
    # 名前が一意になっていることを確認する
    if instance_methods.include?(orig)
      raise(NameError, "#{orig} isn't a unique name") # この処理がないと、もともとのメソッドを壊してしまう。
    end
    # オリジナルのメソッドのために新しい名前を作る
    alias_method(orig, method) # alias_method(new_name, original_name) ！メソッドの中で定義すればメソッド実行時のみ置き換える
    # オリジナルのメソッドを交換する
    define_method(method) do |*args, &block|
      $stdout.puts("calling method '#{method}'")
      result = send(orig, *args, &block)
      $stdout.puts("'#{method}' returned #{result.inspect}")
      result
    end
  end
end
Array.extend(LogMethod)
Array.log_method(:first) # log_methodを呼び出すと、引数のメソッドを置き換える
[1,2,3].first
# calling method 'first'
# 'first' returned 1
# => 1
%w(a b c).first_without_logging
# => "a"

# 問題点は演算子に対応していないこと。例えば「:*_without_logging」というメソッドは作れない

# 元に戻すメソッドも考えておくとよい
module LogMethod
  def unlog_method (method)
    orig = "#{method}_without_logging".to_sym
    # log_methodが先に呼び出されていることを確認する
    if !instance_methods.include?(orig)
      raise(NameError, "was #{orig} already removed?")
    end
    # ロギング付きバージョン（define_methodで定義したもの）を削除する
    remove_method(method)
    # メソッドを元の名前に戻す（origの方が元のメソッドの方の動作を担っていたから）
    alias_method(method, orig)
    # log_methodが作った名前を削除する
    remove_method(orig)
  end
end


=begin
＜この項目で気づいたこと・学んだこと＞
・面白いな！！ メタプロのもっといろんな例を写経したい！！　使いこなしたらすごく楽しいはずだ！
・別名が一意になるようにする
・元に戻すメソッドも考えておく。
=end
