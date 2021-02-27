# Rubocop::SafeMigrations

Rubocop cops to help to ensure that migrations are safier to run in production environments without causing downtime and issues on database

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

### For Updating data in migration rule
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
- [ ] Adds check to string sql execution with updates, inserts or deletions
- [ ] Position offense message on the method being called, not in the end of line
- [ ] Adds option to be able to whitelist some methods

### For new rules
- [ ] Creates a rule to check if a column is being added with a default value
- [ ] Creates a rule to create indexes safier
