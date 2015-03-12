class: center, middle

# Dependency Injection

## Frank West

---
# What is dependency injection

## Wikipedia defines it as:

Dependency injection is a software design pattern that implements inversion of
control for software libraries, where the caller delegates to an external
framework the control flow of discovering and importing a service or software
module.

:/

Hmmmm...

---
## Some more definitions

**Concrete Implementation** - In ruby this is simply a class name such as Dog or
Duck. In languages this is the implementation of an interface. In C# for example:

--

```cs
public interface IDuck { void Quack(); }
class Duck : IDuck { public void Quack() { Console.Write("Quack"); } }
class Dog : IDuck { public void Quack() { Console.Write("Bark"); } }

public class Program
{
  public static Main()
  {
    var ducks = new List<IDuck> { new Duck(), new Dog() };
    Speak(ducks);
  }

  private static void Speak(IEnumberable<IDuck> ducks)
  {
    foreach(var duck in ducks) duck.Quack;
  }
}

> Quack
> Bark
```
---

**Duck typing** - In its simplest form it is an object that has properties
and/or methods that allow a class to respond correctly within a given
context.

--

```ruby
class Duck; def quack; puts 'Quack'; end; end
class Dog; def quack; puts 'Bark'; end; end

speak([Duck.new, Dog.new])

def speak(ducks)
  ducks.each {|duck| duck.quack }
end

> Quack
> Bark
```
---
# A simpler definition for DI

Don't use concrete class implementations inside other classes, pass them in
instead.

If you find yourself using one class name (Class A) inside another class (Class
B), you have missed the opportunity to perform dependency injection and possibly
save some headaches down the road.

--

Without DI
```ruby
class B
  def call
    instance = A.new
    instance.do_something
  end
end
```
--
With DI
```ruby
class B
  def call(instance)
    instance.do_something
  end
end
```
---
# Why would we use it?

* Reduces the chance of a class having more than one reason to change, allowing
  us to follow Single Responsibility Principle (SRP) more closely

--

* Reduces the need to make the same change in multiple places

--

* Can make testing easier due to ability to mock out object being injected

--

* Because Uncle Bob says so

---

# Why would we not use it?

* Introduces more abstraction and indirection

--

* Can be difficult to tell which concrete implementation is being injected
  (at least in Ruby)

--

* May take a new developer to the project more time to reason about the code

--

## However

These problems can be mitigated with well named classes, methods and variables

---
# Now for some examples
---
```ruby
describe Auditor do
  describe '.audit' do
    it 'should write the audit to a file' do
      message = "Hello"
      auditor = Auditor.new
      opened_file = spy("Opened File")
      allow(File).to receive(:open).with('audit.txt', 'a').
        and_yield(opened_file)

      auditor.audit(message)

      expect(opened_file).to have_received(:puts).with(message)
    end
  end
end
```
---
```ruby
class Auditor
  def audit(value)
    File.open('audit.txt', 'a') do |w|
      w.puts(value)
    end
  end
end
```
---
```ruby
describe Account do
  describe '.deposit' do
    it 'should add to the balance' do
      account = Account.new(100.00)

      account.deposit(20)

      expect(account.balance).to eq(120.00)
    end

    it 'should audit a deposit' do
      account = Account.new(100.00)
      auditor = spy('Auditor')
      allow(Auditor).to receive(:new).and_return(auditor)

      account.deposit(20)

      expect(auditor).to have_received(:audit).with('Deposited 20')
    end
  end

  describe '.withdraw' do
    # Same tests as above for withdraw method
  end
end
```
---
```ruby
require 'auditor'

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
```
---
```ruby
require_relative 'lib/account'

if __FILE__ == $0
  account = Account.new(ARGV[0].to_f)
  puts account.balance
  account.deposit(50)
  puts account.balance
end
```
```bash
> ruby main.rb 100.00
100.0
150.0
>
```
---
# Change is constant and imminent

What happens when Auditor's requirements change and we need to pass in the
  audit file name instead.

--

```bash
> ruby main.rb 100.00 my_audit.txt
100.0
150.0
>
```

---
# What needs to change to accomplish this

```bash
Changes not staged for commit:

  modified:   accounting.rb
  modified:   lib/account.rb
  modified:   lib/auditor.rb
  modified:   spec/account_spec.rb
  modified:   spec/auditor_spec.rb
```

```ruby
require_relative './auditor'

class Account
  attr_reader :balance

  def initialize(initial_balance, audit_file)
    @balance = initial_balance
    @audit_file = audit_file
  end

  ...

  private

  def auditor
    Auditor.new(@audit_file)
  end
end
```
---
class: center, middle

# Now how would we implement this with DI

---
```ruby
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
    # Same tests as above for withdraw method
  end
end
```
---
```ruby
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
```
