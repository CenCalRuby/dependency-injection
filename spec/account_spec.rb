require 'account'

describe Account do
  describe '.deposit' do
    it 'should add to the balance' do
      account = Account.new(100.00, 'audit_file.txt')

      account.deposit(20)

      expect(account.balance).to eq(120.00)
    end

    it 'should audit a deposit' do
      account = Account.new(100.00, 'audit_file.txt')
      auditor = spy('Auditor')
      allow(Auditor).to receive(:new).with('audit_file.txt').
        and_return(auditor)

      account.deposit(20)

      expect(auditor).to have_received(:audit).with('Deposited 20')
    end
  end

  describe '.withdraw' do
    it 'should subtract to the balance' do
      account = Account.new(100.00, 'audit_file.txt')

      account.withdraw(20)

      expect(account.balance).to eq(80.00)
    end

    it 'should audit a withdrawal' do
      account = Account.new(100.00, 'audit_file.txt')
      auditor = spy('Auditor')
      allow(Auditor).to receive(:new).with('audit_file.txt').
        and_return(auditor)

      account.withdraw(20)

      expect(auditor).to have_received(:audit).with('Withdrew 20')
    end
  end
end
