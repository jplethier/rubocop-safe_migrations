RSpec.describe RuboCop::Cop::Migration::RenamingTableInMigration do
  let(:config) { RuboCop::Config.new("Migration/RenamingTableInMigration" => cop_config) }
  let(:cop_config) do
    {
      "Enabled" => true,
    }
  end
  subject(:cop) { described_class.new(config) }

  context "creating table" do
    it "does not register any offense" do
      expect_no_offenses(<<~RUBY)
        create_table :table_name do |t|
          t.integer :attribute1
          t.string :attribute2
        end
      RUBY
    end
  end

  context "renaming table" do
    it "register an offense" do
      expect_offense(<<~RUBY)
        rename_table :old_name, :new_name
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Renaming table on migration should be avoided
      RUBY
    end
  end
end
