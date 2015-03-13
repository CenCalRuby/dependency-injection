require_relative './auditor'

class Account
  attr_reader :balance

  def initialize(initial_balance, audit_file)
    @balance = initial_balance
    @audit_file = audit_file
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
    Auditor.new(@audit_file)
  end
end
