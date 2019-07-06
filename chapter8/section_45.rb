class Resource
  def self.open (&block)
    resource = new
    block.call(resource) if block
  ensure
    resource.close if resource
  end
end


=begin
＜この項目で気づいたこと・学んだこと＞

=end
