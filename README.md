# Dependency Injection

This repo has two branches and four tags that that walk through the process of
a change in the code that is made when no dependency injection is used. It also
shows the same change implemented with dependency injection implemented.

The change implemented is a simple change where an initializer is added to a
dependent class. This demonstrates how a simple change can permeate throughout
your codebase in places where you would not expect it to.

## Branch: non-di

### Tag: non-di-before

This is the implementation of the original code without dependency injection
implemented.

### Tag: non-di-after

This is the updated code that implements the change where the auditor now
requires an initializer.

## Branch: di

### Tag: di-before

This is the implementation of the original code with dependency injection
implemented.

### Tag: di-after

This is the updated code that implements the change where the auditor now
requires an initializer.

## Getting Started

1. Clone repo
2. run ```bundle install```
3. run ```rspec```

### Presentation

index.html

