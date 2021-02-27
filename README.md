# Rubocop::SafeMigrations

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/rubocop/safe_migrations`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-safe_migrations', require: false
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rubocop-safe_migrations

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rubocop-safe_migrations. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rubocop-safe_migrations/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Rubocop::SafeMigrations project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rubocop-safe_migrations/blob/master/CODE_OF_CONDUCT.md).

## TODO

- [ ] Adds check to active record save method called on migration
- [ ] Adds check to active record destroy method called on migration
- [ ] Adds check to active record destroy_all method called on migration
- [ ] Adds check to active record update_attribute method called on migration
- [ ] Adds check to active record update_attributes method called on migration
- [ ] Adds check to active record update_column method called on migration
- [ ] Adds check to active record update_counters method called on migration
- [ ] Adds check to active record toggle method called on migration
- [ ] Adds check to active record create_or_update method called on migration
- [ ] Adds check to active record decrement method called on migration
- [ ] Adds check to active record increment method called on migration
- [ ] Adds check to active record find_or_create method called on migration
- [ ] Position offense message on the method being called, not in the end of line
- [ ] Adds option to be able to whitelist some methods
