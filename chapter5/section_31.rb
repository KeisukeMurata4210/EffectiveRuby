def glass_case_of_emotion
  x = "I'm in a " + __method__.to_s.tr('_', ' ')
  binding
end

x = "I'm in scope"
eval("x") # => "I'm in scope"
eval("x", glass_case_of_emotion) # => "I'm in glass case of emotion"


=begin
＜この項目で気づいたこと・学んだこと＞

=end
