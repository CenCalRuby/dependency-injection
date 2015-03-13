class Account
  attr_reader :balance

  def initialize(initial_balance, auditor)
    @balance = initial_balance
    @auditor = auditor
  end

  def deposit(amount)
    @balance += amount
    @auditor.audit("Deposited #{amount}")
  end

  def withdraw(amount)
    @balance -= amount
    @auditor.audit("Withdrew #{amount}")
  end
end
