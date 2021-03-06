# Rubocop::SafeMigrations

Rubocop cops to help to ensure that migrations are safier to run in production environments without causing downtime and issues on database

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rubocop-safe_migrations", require: false
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rubocop-safe_migrations

## Usage

After installed, you have to tell rubocop to require this new cops. For doing this, add this config to your .rubocop.yml file:

```yaml
require:
  - rubocop-safe_migrations
```

Be sure that you are not excluding migrate files for all cops either.

The cops that will be checked are:

### Updating data in migration

This cop will check if active record migrations have any method that runs updates, creations or deletions on your database.

This is more importante to be avoided if you have your deploy pipeline configured to run database migrations on deploy or build time, since having data being manipulating or updating on deploy can cause unexpected downtime to your application database.

By default, all active record methods that generate update, create or delete queries are checked by the cop, and if used on migrations an offense will be generated.

To turn some method available to be used on migration, just add it to AllowedMethods config on rubocop.yml, for example:

```yaml
Migration/UpdatingDataInMigration:
  AllowedMethods:
    - toggle
```

Using the configuration above, the cop will not add an offense when toggle method is used on migrations.

### Renaming table in migration

This cop will check if you have a migration that are renaming some table already created on your database.

This should be avoided because your database could had ran some trigger after creation that will not be runned after renamed. Besides that, it can led to an inconsistent scenario where you have indexes and foreign_keys with old table name, and if a DBA or a developer look those in database, it can be confuse and led to a misunderstand.

This cop has no options, the only thing that can be done is disabled it on rubocop.yml:

```yaml
Migration/RenamingTableInMigration:
  Enabled: false
```

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

### For Updating data in migration cop
- [ ] Adds check to active record update_counters method called on migration
- [ ] Adds check to active record create method called on migration
- [ ] Adds check to active record create_or_update method called on migration
- [ ] Adds check to active record decrement method called on migration
- [ ] Adds check to active record increment method called on migration
- [ ] Adds check to active record find_or_create method called on migration
- [ ] Adds check to string sql execution with updates, inserts or deletions
- [ ] Position offense message on the method being called, not in the end of line
- [ ] Adds option to be able to add custom methods to blacklist

### For renaming table in migration cop
- [ ] Adds a check to string sql execution renaming table
- [ ] [Maybe] Adds a possibility to renaming table if all indexes and foreign keys are renamed as well

### For new rules
- [ ] Creates a rule to check if a column is being added with a default value
- [ ] Creates a rule to create indexes safier

