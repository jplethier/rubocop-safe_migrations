RSpec.describe RuboCop::Cop::Migration::UpdatingDataInMigration do
  let(:config) { RuboCop::Config.new }
  subject(:cop) { described_class.new(config) }

  describe "update" do
    it "registers an offense if called directly on class passing id" do
      expect_offense(<<~RUBY)
        ModelName.update(id, attribute_name: attribute_value)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it 'registers an offense if called an active record object instance' do
      expect_offense(<<~RUBY)
        ModelName.update(attribute_name: attribute_value)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it 'registers an offense when called on an iteration' do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.update(attribute: "value")
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end
  end

  describe "update!" do
    it "registers an offense if called directly on class passing id" do
      expect_offense(<<~RUBY)
        ModelName.update!(id, attribute_name: attribute_value)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it 'registers an offense if called an active record object instance' do
      expect_offense(<<~RUBY)
        ModelName.update!(attribute_name: attribute_value)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it 'registers an offense when called on an iteration' do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.update!(attribute: "value")
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end
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
  end

  describe "destroy_all" do
    context "without conditions" do
      it 'registers an offense if called directly on model' do
        expect_offense(<<~RUBY)
          ModelName.destroy_all
          ^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
      end

      it 'registers an offense if called on an active record relation object' do
        expect_offense(<<~RUBY)
          ModelName.where(condition: true).destroy_all
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
      end
    end
  end

  describe "delete" do
    it "registers an offense if called directly on class passing id" do
      expect_offense(<<~RUBY)
          ModelName.delete(id)
          ^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
    end

    it 'registers an offense if called an active record object instance' do
      expect_offense(<<~RUBY)
        ModelName.delete
        ^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it 'registers an offense when called on an iteration' do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.delete
          ^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end
  end

  describe "destroy" do
    it "registers an offense if called directly on class passing id" do
      expect_offense(<<~RUBY)
          ModelName.destroy(id)
          ^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
    end

    it 'registers an offense if called an active record object instance' do
      expect_offense(<<~RUBY)
        ModelName.destroy
        ^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it 'registers an offense when called on an iteration' do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.destroy
          ^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end
  end

  describe "save" do
    it "registers an offense if called" do
      expect_offense(<<~RUBY)
          ModelName.save
          ^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
    end

    it 'registers an offense if called inside an iteration list' do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.save
          ^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end
  end

  describe "save!" do
    it "registers an offense if called" do
      expect_offense(<<~RUBY)
          ModelName.save!
          ^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
    end

    it 'registers an offense if called inside an iteration list' do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.save!
          ^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end
  end
end
