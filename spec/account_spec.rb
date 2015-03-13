require 'account'

describe Account do
  describe '.deposit' do
    it 'should add to the balance' do
      auditor = instance_double('auditor', :audit)
      allow(auditor).to receive(:audit)
      account = Account.new(100.00, auditor)

      account.deposit(20)

      expect(account.balance).to eq(120.00)
    end

    it 'should audit a deposit' do
      auditor = instance_spy('auditor')
      account = Account.new(100.00, auditor)

      account.deposit(20)

      expect(auditor).to have_received(:audit).with('Deposited 20')
    end
  end

  describe '.withdraw' do
    it 'should subtract to the balance' do
      auditor = instance_double('auditor')
      allow(auditor).to receive(:audit)
      account = Account.new(100.00, auditor)

      account.withdraw(20)

      expect(account.balance).to eq(80.00)
    end

    it 'should audit a withdrawal' do
      auditor = instance_spy('auditor')
      account = Account.new(100.00, auditor)

      account.withdraw(20)

      expect(auditor).to have_received(:audit).with('Withdrew 20')
    end
  end
end
