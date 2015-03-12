require_relative 'lib/account'

if __FILE__ == $0
  account = Account.new(ARGV[0].to_f)
  puts account.balance
  account.deposit(50)
  puts account.balance
end
