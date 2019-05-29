class Singleton
  private_class_method(:new, :dup, :clone) # privateなクラスメソッドにする => Singletonクラス内部でしか呼び出せなくなる。
  def self.instance
    @@single ||= new # newが一回しか呼び出されないようにしている。2回目以降は@singleの値を返すのみ。
  end
end

class Configuration < Singleton
end

class Database < Singleton
end
# Singletonクラスを継承させて使おうとしても、意図したようには動かない。
Configuration.instance # => #<Configuration:0x00007fbee5a78310>
Database.instance      # => #<Configuration:0x00007fbee5a78310>
# クラス変数@@singleは全てのサブクラスで共有される。インスタンスメソッド、クラスメソッドの両方からアクセスできてしまう。



class Singleton
  private_class_method(:new, :dup, :clone)
  def self.instance
    @single ||= new # クラスインスタンス変数。クラスというオブジェクトのインスタンス変数。クラスというオブジェクトの特異クラスに属する。
  end
end

class Configuration < Singleton
end

class Database < Singleton
end

Configuration.instance # => #<Configuration:0x00007f965d96fcf8>
Database.instance      # => #<Database:0x00007f965d0d7b68>
# クラスインスタンス変数はクラスメソッドからしかアクセスできない=>カプセル化もできる。




=begin
＜この項目で気づいたこと・学んだこと＞
・newを隠蔽してクラスメソッド内で呼び出す/すでに作られているときはそれを返す、のがシングルトンパターン。インスタンスを一つしか作らない。
・クラスインスタンス変数とは、クラスというオブジェクトのインスタンス変数。実質はインスタンス変数と変わらない。
=end
