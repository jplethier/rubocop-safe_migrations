RSpec.describe RuboCop::Cop::Migration::UpdatingDataInMigration do
  let(:config) { RuboCop::Config.new("Migration/UpdatingDataInMigration" => cop_config) }
  let(:cop_config) do
    {
      "Enabled" => true,
      "AllowedMethods" => []
    }
  end
  subject(:cop) { described_class.new(config) }

  shared_examples "out of AllowedMethods" do |node|
    let(:cop_config) do
      { "AllowedMethods" => [] }
    end

    it "register an offense" do
      expect_offense(node)
    end
  end

  shared_examples "added to AllowedMethods" do |method_name, node|
    let(:cop_config) do
      {
        "AllowedMethods" => [method_name]
      }
    end

    it "does not register an offense when called" do
      expect_no_offenses(node)
    end
  end

  describe "update" do
    context "when called dierctly on class" do
      it_behaves_like "out of AllowedMethods",
                      <<~RUBY
                        ModelName.update(id, attribute_name: attribute_value)
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
                      RUBY
    end

    context "when called on active record object instance" do
      it_behaves_like "out of AllowedMethods",
                      <<~RUBY
                        ModelName.update(attribute_name: attribute_value)
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
                      RUBY
    end

    context "when called on iteration" do
      it_behaves_like "out of AllowedMethods",
                      <<~RUBY
                        ModelName.all.each do |model_object|
                          model_object.update(attribute: "value")
                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
                        end
                      RUBY
    end

    it_behaves_like "added to AllowedMethods", "update",
                    <<~RUBY
                      ModelName.all.each do |model_object|
                        model_object.update(attribute: "value")
                      end
                    RUBY
  end

  describe "update!" do
    it "registers an offense if called directly on class passing id" do
      expect_offense(<<~RUBY)
        ModelName.update!(id, attribute_name: attribute_value)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it "registers an offense if called an active record object instance" do
      expect_offense(<<~RUBY)
        ModelName.update!(attribute_name: attribute_value)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it "registers an offense when called on an iteration" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.update!(attribute: "value")
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "update!",
                    <<~RUBY
                      ModelName.all.each do |model_object|
                        model_object.update!(attribute: "value")
                      end
                    RUBY
  end

  describe "update_all" do
    context "with hash updates" do
      context "without conditions and options" do
        it "registers an offense if calls update_all directly on model" do
          expect_offense(<<~RUBY)
            ModelName.update_all(attribute: "value")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it "registers an offense if calls update_all on an active record relation object" do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all("sql string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it_behaves_like "added to AllowedMethods", "update_all",
                        <<~RUBY
                          ModelName.where(condition: "value").update_all("sql string")
                        RUBY
      end

      context "with conditions and without options" do
        it "registers an offense if calls update_all directly on model" do
          expect_offense(<<~RUBY)
            ModelName.update_all({ attribute: "value" }, "sql conditions string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it "registers an offense if calls update_all on an active record relation object" do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all({ attribute: "value" }, "sql conditions string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it_behaves_like "added to AllowedMethods", "update_all",
                        <<~RUBY
                          ModelName.where(condition: "value").update_all({ attribute: "value" }, "sql conditions string")
                        RUBY
      end

      context "with conditions and options" do
        it "registers an offense if calls update_all directly on model" do
          expect_offense(<<~RUBY)
            ModelName.update_all({ attribute: "value" }, "sql conditions string", order: "created_at", limit: 10)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it "registers an offense if calls update_all on an active record relation object" do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all({ attribute: "value" }, "sql conditions string", order: "created_at", limit: 10)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it_behaves_like "added to AllowedMethods", "update_all",
                         <<~RUBY
                           ModelName.where(condition: "value").update_all({ attribute: "value" }, "sql conditions string", order: "created_at", limit: 10)
                         RUBY
      end
    end

    context "with string updates" do
      context "without conditions and options" do
        it "registers an offense if calls update_all directly on model" do
          expect_offense(<<~RUBY)
            ModelName.update_all("sql string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it "registers an offense if calls update_all on an active record relation object" do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all("sql string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it_behaves_like "added to AllowedMethods", "update_all",
                        <<~RUBY
                          ModelName.where(condition: "value").update_all("sql string")
                        RUBY
      end

      context "with conditions and without options" do
        it "registers an offense if calls update_all directly on model" do
          expect_offense(<<~RUBY)
            ModelName.update_all("sql string", "sql conditions string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it "registers an offense if calls update_all on an active record relation object" do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all("sql string", "sql conditions string")
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it_behaves_like "added to AllowedMethods", "update_all",
                        <<~RUBY
                          ModelName.where(condition: "value").update_all("sql string", "sql conditions string")
                        RUBY
      end

      context "with conditions and options" do
        it "registers an offense if calls update_all directly on model" do
          expect_offense(<<~RUBY)
            ModelName.update_all("sql string", "sql conditions string", order: "created_at", limit: 10)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it "registers an offense if calls update_all on an active record relation object" do
          expect_offense(<<~RUBY)
            ModelName.where(condition: "value").update_all("sql string", "sql conditions string", order: "created_at", limit: 10)
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
          RUBY
        end

        it_behaves_like "added to AllowedMethods", "update_all",
                        <<~RUBY
                          ModelName.where(condition: "value").update_all("sql string", "sql conditions string", order: "created_at", limit: 10)
                        RUBY
      end
    end
  end

  describe "update_attribute" do
    it "registers an offense if called an active record object instance" do
      expect_offense(<<~RUBY)
        model_object.update_attribute(:attribute_name, "value")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it "registers an offense when called on an iteration" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.update_attribute(:attribute_name, "value")
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "update_attribute",
                    <<~RUBY
                      model_object.update_attribute(:attribute_name, "value")
                    RUBY
  end

  describe "update_column" do
    it "registers an offense if called an active record object instance" do
      expect_offense(<<~RUBY)
        model_object.update_column(:attribute_name, "value")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it "registers an offense when called on an iteration" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.update_column(:attribute_name, "value")
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "update_column",
                    <<~RUBY
                      model_object.update_column(:attribute_name, "value")
                    RUBY
  end

  describe "update_columns" do
    it "registers an offense if called an active record object instance" do
      expect_offense(<<~RUBY)
        model_object.update_columns(attribute_name: "value")
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it "registers an offense when called on an iteration" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.update_columns(attribute_name: "value")
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "update_columns",
                    <<~RUBY
                      model_object.update_columns(:attribute_name, "value")
                    RUBY
  end

  describe "toggle" do
    it "registers an offense if called an active record object instance" do
      expect_offense(<<~RUBY)
        model_object.toggle(:attribute_name)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it "registers an offense when called on an iteration" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.toggle(:attribute_name)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "toggle",
                    <<~RUBY
                      model_object.toggle(:attribute_name, "value")
                    RUBY
  end

  describe "toggle!" do
    it "registers an offense if called an active record object instance" do
      expect_offense(<<~RUBY)
        model_object.toggle!(:attribute_name)
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it "registers an offense when called on an iteration" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.toggle!(:attribute_name)
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "toggle!",
                    <<~RUBY
                      model_object.toggle!(:attribute_name, "value")
                    RUBY
  end

  describe "delete_all" do
    context "without conditions" do
      it "registers an offense if calls delete_all directly on model" do
        expect_offense(<<~RUBY)
          ModelName.delete_all
          ^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
      end

      it "registers an offense if calls delete_all on an active record relation object" do
        expect_offense(<<~RUBY)
          ModelName.where(condition: true).delete_all
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
      end

      it_behaves_like "added to AllowedMethods", "delete_all",
                      <<~RUBY
                        ModelName.where(condition: true).delete_all
                      RUBY
    end
  end

  describe "destroy_all" do
    context "without conditions" do
      it "registers an offense if called directly on model" do
        expect_offense(<<~RUBY)
          ModelName.destroy_all
          ^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
      end

      it "registers an offense if called on an active record relation object" do
        expect_offense(<<~RUBY)
          ModelName.where(condition: true).destroy_all
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
      end

      it_behaves_like "added to AllowedMethods", "destroy_all",
                      <<~RUBY
                        ModelName.where(condition: true).destroy_all
                      RUBY
    end
  end

  describe "delete" do
    it "registers an offense if called directly on class passing id" do
      expect_offense(<<~RUBY)
          ModelName.delete(id)
          ^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
    end

    it "registers an offense if called an active record object instance" do
      expect_offense(<<~RUBY)
        ModelName.delete
        ^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it "registers an offense when called on an iteration" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.delete
          ^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "delete",
                    <<~RUBY
                      ModelName.delete(id)
                    RUBY
  end

  describe "destroy" do
    it "registers an offense if called directly on class passing id" do
      expect_offense(<<~RUBY)
          ModelName.destroy(id)
          ^^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
    end

    it "registers an offense if called an active record object instance" do
      expect_offense(<<~RUBY)
        ModelName.destroy
        ^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
      RUBY
    end

    it "registers an offense when called on an iteration" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.destroy
          ^^^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "destroy",
                    <<~RUBY
                      ModelName.destroy(id)
                    RUBY
  end

  describe "save" do
    it "registers an offense if called" do
      expect_offense(<<~RUBY)
          ModelName.save
          ^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
    end

    it "registers an offense if called inside an iteration list" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.save
          ^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "save",
                    <<~RUBY
                      ModelName.save
                    RUBY
  end

  describe "save!" do
    it "registers an offense if called" do
      expect_offense(<<~RUBY)
          ModelName.save!
          ^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        RUBY
    end

    it "registers an offense if called inside an iteration list" do
      expect_offense(<<~RUBY)
        ModelName.all.each do |model_object|
          model_object.save!
          ^^^^^^^^^^^^^^^^^^ Updating or manipulating data in migration is unsafe!
        end
      RUBY
    end

    it_behaves_like "added to AllowedMethods", "save!",
                    <<~RUBY
                      ModelName.save!
                    RUBY
  end
end
