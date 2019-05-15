# 2 Files to extend Rails Core to help with type-casting to_boolean.


# First file and to be placed within Rails:
# config/initializers/core_ext.rb
#
class String
  def to_boolean
    # Rails 5
    ActiveModel::Type::Boolean.new.cast(self)
    # Rails 4.2
    #ActiveRecord::Type::Boolean.new.cast(self)
  end
end

class NilClass
  def to_boolean
    false
  end
end

class TrueClass
  def to_boolean
    true
  end

  def to_i
    1
  end
end

class FalseClass
  def to_boolean
    false
  end

  def to_i
    0
  end
end

class Integer
  def to_boolean
    to_s.to_boolean
  end
end



# Second file and to be placed within Rails:
# spec/models/to_boolean_spec.rb
#
require 'rails_helper'

RSpec.describe 'to_boolean' do
  # pending "add some examples to (or delete) #{__FILE__}"

  # This rspec file tests /config/initializers/core_ext.rb
  #
  # core_ext.rb
  #   * Allows ".to_boolean" to be used to make dealing with the different
  #     ways a boolean value could be represented in a slimmed down way.


  it 'nil.to_boolean should == false' do
    expect(nil.to_boolean).to eq(false)
  end
  it 'nil.to_boolean should != true' do
    expect(nil.to_boolean).to_not eq(true)
  end

  it 'true.to_boolean should == true' do
    expect(true.to_boolean).to eq(true)
  end
  it 'true.to_boolean should != false' do
    expect(true.to_boolean).to_not eq(false)
  end

  it 'false.to_boolean should == false' do
    expect(false.to_boolean).to eq(false)
  end
  it 'false.to_boolean should != true' do
    expect(false.to_boolean).to_not eq(true)
  end

  it '0.to_boolean should == false' do
    expect(0.to_boolean).to eq(false)
  end
  it '0.to_boolean should != true' do
    expect(0.to_boolean).to_not eq(true)
  end

  it '1.to_boolean should == true' do
    expect(1.to_boolean).to eq(true)
  end
  it '1.to_boolean should != false' do
    expect(1.to_boolean).to_not eq(false)
  end

  it '99.to_boolean should == true' do
    expect(99.to_boolean).to eq(true)
  end
  it '99.to_boolean should != false' do
    expect(99.to_boolean).to_not eq(false)
  end

  it '"true".to_boolean should == true' do
    expect("true".to_boolean).to eq(true)
  end
  it '"true".to_boolean should != false' do
    expect("true".to_boolean).to_not eq(false)
  end

  it '"foo".to_boolean should == true' do
    expect("foo".to_boolean).to eq(true)
  end
  it '"foo".to_boolean should != false' do
    expect("foo".to_boolean).to_not eq(false)
  end

  it '"false".to_boolean should == false' do
    expect("false".to_boolean).to eq(false)
  end
  it '"false".to_boolean should != true' do
    expect("false".to_boolean).to_not eq(true)
  end

  it '"TRUE".to_boolean should == true' do
    expect("TRUE".to_boolean).to eq(true)
  end
  it '"TRUE".to_boolean should != false' do
    expect("TRUE".to_boolean).to_not eq(false)
  end

  it '"FALSE".to_boolean should == false' do
    expect("FALSE".to_boolean).to eq(false)
  end
  it '"FALSE".to_boolean should != true' do
    expect("FALSE".to_boolean).to_not eq(true)
  end

  it '0.to_boolean should == false' do
    expect(0.to_boolean).to eq(false)
  end
  it '0.to_boolean should != true' do
    expect(0.to_boolean).to_not eq(true)
  end

  it '1.to_boolean should == true' do
    expect(1.to_boolean).to eq(true)
  end
  it '1.to_boolean should != false' do
    expect(1.to_boolean).to_not eq(false)
  end

  it 'true.to_i should == 1' do
    expect(true.to_i).to eq(1)
  end

  it 'false.to_i should == 0' do
    expect(false.to_i).to eq(0)
  end

end # END RSpec.describe 'to_boolean' do
