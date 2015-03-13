require_relative 'lib/account'

if __FILE__ == $0
  auditor = Auditor.new(ARGV[1])
  account = Account.new(ARGV[0].to_f, auditor)
  puts account.balance
  account.deposit(50)
  puts account.balance
end
