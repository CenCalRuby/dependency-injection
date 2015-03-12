require_relative './auditor'

class Account
  attr_reader :balance

  def initialize(initial_balance)
    @balance = initial_balance
  end

  def deposit(amount)
    @balance += amount
    auditor.audit("Deposited #{amount}")
  end

  def withdraw(amount)
    @balance -= amount
    auditor.audit("Withdrew #{amount}")
  end

  private

  def auditor
    Auditor.new
  end
end
