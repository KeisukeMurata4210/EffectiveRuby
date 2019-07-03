# モンキーパッチは危険。正常なコードを書いても、誰かが標準のはずの動作を変えているためにエラーになる事が起こりうる。
# そうなったら修正はとてつもなく大変。
module OnlySpace
  ONLY_SPACE_UNICODE_RE = %r/\A[[:space:]]*\z/
end




=begin
＜この項目で気づいたこと・学んだこと＞

=end
