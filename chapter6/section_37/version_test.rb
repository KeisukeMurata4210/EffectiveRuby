require('minitest/autorun')
require('./version.rb')
describe(Version) do
  describe("when parsing") do
    before do
      @version = Version.new("10.8.9")
    end
    it("creates three integers") do
      @version.major.must_equal(10)
      @version.minor.must_equal(8)
      @version.patch.must_equal(9)
    end
  end

  describe("when comparing") do
    before do
      @v1 = Version.new("2.1.1")
      @v2 = Version.new("2.3.0")
    end
    it("orders correctly") do
      @v1.wont_equal(@v2)
      @v1.must_be(:<, @v2)
    end
  end
end