require 'minitest/autorun'
require './simple_contracts'

class SimpleContractTest < Minitest::Test

  #precondtion tests
  def test_pre_raises_exception_when_false
    assert_raises do
      precondition do
        false 
      end
    end
  end
  
  def test_pre_does_not_raise_when_true
      precondition do
        true 
      end
      assert true
  end

  def test_pre_raises_exception_when_block_is_not_bool
    assert_raises do
      precondition do
        "Hello"
      end
    end
  end 
 
  def test_assert_returns_immediately_when_RAILS_ENV_is_production 
      ENV['RAILS_ENV'] = "production"  
      precondition do
        false 
      end
      assert true
      ENV.delete 'RAILS_ENV'
  end

  def test_it_returns_immediately_with_generic_production_variable
      ENV['SIMPLE_CONTRACT_ENV'] = "production"  
 
      precondition do
        false 
      end

      assert true
  
      ENV.delete 'SIMPLE_CONTRACT_ENV' 
  end

  def test_post_condition_alias_works
      assert_raises do
        postcondition do
          false
        end
      end
  end

  def test_trying_it_within_a_function_success 
 
   sample_function(2) 
    assert true
  end


  def test_failing_precondition_raises_exception
    assert_raises do
      sample_function(0) 
    end
  end

  def sample_function(number)
    precondition do
      number > 0 && 
      number < 100
    end

    number + 1
  end
end
