# SimpleContracts
# A simple contract library that provides contracts# without attempting to create a type system or a custom contract dsl.
#
# The public interface to the functionality are the precondtion and
# postcondition functions. When added to your code, these two
# functions become available. Eventually we will have the 
# invariant condition included once I understand how it works.

# checks precondition statements
# @param block [Proc]
# @return void
# @note It throws an contract violation exception if the block
# evaluates to false. It also throws a boolean violation if the 
# block doesn't return a final boolean value
def precondition(&block)
  SimpleContracts::simple_contract_assert("precondition", &block)
end

# checks postcondition statements
# @param block [Proc]
# @return void
# @note It throws an contract violation exception if the block
# evaluates to false. It also throws a boolean violation if the 
# block doesn't return a final boolean value
def postcondition(&block)
  SimpleContracts::simple_contract_assert("postcondtion", &block)
end

# SimpleContracts
# This class encapsulates the logic for the simple contract system.
# It wraps logic and helping functions so that we won't polute classes
# with functions meant to support simple contracts
class SimpleContracts
  
  #implements the conditions assertions
  # @param type [String]
  # @param block [Proc]
  # @return nil on success Exception on failure
  # @note this is the workhorse for the module. Pre and post condtions
  # are essentially the same as for my understanding at this point.
  # As I understand Design-By-Contract more, I will further refine
  # the implementation.
  def self.simple_contract_assert (type, &block) 
    return if production_environment 
    
    result = block.call

    unless is_bool? result
      raise "Contract requires #{type} block to return a Boolean"  
    end

    unless result  
      raise "Contract violation on #{type}"
    end
  end

  # checks if a value is a boolean
  # @param input [Object]
  # @return [Boolean]
  def self.is_bool?(input)
    [true, false].include? input
  end

  # returns true if working on production environment
  # @return [Boolean]
  # @note this is the support for short circuiting the tests in
  # production systems. This may be a super naive implementation.
  # I will seek something better if I can confirm performance problems.
  def self.production_environment
    (!ENV["RAILS_ENV"].nil? && ENV["RAILS_ENV"] == "production") || 
    (!ENV["SIMPLE_CONTRACT_ENV"].nil? && ENV["SIMPLE_CONTRACT_ENV"] == "production") 
  end
end
