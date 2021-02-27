RSpec.describe RuboCop::Cop::Migration::UpdatingDataInMigration do
  let(:config) { RuboCop::Config.new }
  subject(:cop) { described_class.new(config) }

  it 'registers an offense if calls update on an active record object' do
    expect_offense(<<~RUBY)
      ModelName.update(attribute_name: attribute_value)
      ^^^^^^^^^^^^^^^^^^^ Updating or populating data in migration is unsafe!
    RUBY
  end

  it 'registers an offense if calls update on an active record object' do
    expect_offense(<<~RUBY)
      ModelName.delete
      ^^^^^^^^^^^^^^^^^^^ Updating or populating data in migration is unsafe!
    RUBY
  end

  describe "update_all" do
    context "with hash updates" do
      context "without conditions and options" do
        it 'registers an offense if calls update_all directly on model' do
          expect_offense(<<~RUBY)
            ModelName.update_all(attribute: "value")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it 'registers an offense if calls update_all on an active record relation object' do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all("sql string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end
      end

      context "with conditions and without options" do
        it 'registers an offense if calls update_all directly on model' do
          expect_offense(<<~RUBY)
            ModelName.update_all({ attribute: "value" }, "sql conditions string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it 'registers an offense if calls update_all on an active record relation object' do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all({ attribute: "value" }, "sql conditions string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end
      end

      context "with conditions and options" do
        it 'registers an offense if calls update_all directly on model' do
          expect_offense(<<~RUBY)
            ModelName.update_all({ attribute: "value" }, "sql conditions string", order: "created_at", limit: 10)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it 'registers an offense if calls update_all on an active record relation object' do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all({ attribute: "value" }, "sql conditions string", order: "created_at", limit: 10)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end
      end
    end

    context "with string updates" do
      context "without conditions and options" do
        it 'registers an offense if calls update_all directly on model' do
          expect_offense(<<~RUBY)
            ModelName.update_all("sql string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it 'registers an offense if calls update_all on an active record relation object' do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all("sql string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end
      end

      context "with conditions and without options" do
        it 'registers an offense if calls update_all directly on model' do
          expect_offense(<<~RUBY)
            ModelName.update_all("sql string", "sql conditions string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it 'registers an offense if calls update_all on an active record relation object' do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all("sql string", "sql conditions string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end
      end

      context "with conditions and options" do
        it 'registers an offense if calls update_all directly on model' do
          expect_offense(<<~RUBY)
            ModelName.update_all("sql string", "sql conditions string", order: "created_at", limit: 10)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it 'registers an offense if calls update_all on an active record relation object' do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all("sql string", "sql conditions string", order: "created_at", limit: 10)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end
      end
    end
  end

  describe "delete_all" do
    context "without conditions" do
      it 'registers an offense if calls delete_all directly on model' do
        expect_offense(<<~RUBY)
          ModelName.delete_all
          ^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
      end

      it 'registers an offense if calls delete_all on an active record relation object' do
        expect_offense(<<~RUBY)
          ModelName.where(condition: true).delete_all
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
      end
    end

    # context "with conditions" do
    #   it 'registers an offense if calls delete_all directly on model' do
    #     expect_offense(<<~RUBY)
    #       ModelName.delete_all(attribute: "value")
    #       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
    #     RUBY
    #   end

    #   it 'registers an offense if calls delete_all on an active record relation object' do
    #     expect_offense(<<~RUBY)
    #       ModelName.where(condition: true).delete_all(attribute: "value")
    #       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
    #     RUBY
    #   end
    # end
  end

  it 'accepts if column is added without a default value' do
    expect_no_offenses(<<~RUBY)
      add_column :table_name, :column_name, :boolean
    RUBY
  end

  it 'accepts if column is added with a default nil value' do
    expect_no_offenses(<<~RUBY)
      add_column :table_name, :column_name, :boolean, default: nil
    RUBY
  end
end
