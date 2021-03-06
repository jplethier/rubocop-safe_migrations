# frozen_string_literal: true
module RuboCop
  module Cop
    module Migration
      class UpdatingDataInMigration < RuboCop::Cop::Cop
        MSG = "Updating or manipulating data in migration is unsafe!".freeze

        def on_send(node)
          return if allowed_methods.include?(node.method_name.to_s)

          add_offense(node) if forbidden_methods.include?(node.method_name)
        end

        private

        def allowed_methods
          cop_config["AllowedMethods"] || []
        end

        def forbidden_methods
          %i[
            update
            update!
            update_all
            update_attribute
            update_column
            update_columns
            toggle
            toggle!
            delete
            delete_all
            destroy
            destroy_all
            save
            save!
          ]
        end
      end

      class RenamingTableInMigration < RuboCop::Cop::Cop
        MSG = "Renaming table on migration should be avoided".freeze

        def_node_matcher :renaming_table?, <<-PATTERN
          (send nil? :rename_table ...)
        PATTERN

        def on_send(node)
          renaming_table?(node) { add_offense(node) }
        end
      end
    end
  end
end
