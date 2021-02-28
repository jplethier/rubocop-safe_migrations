# frozen_string_literal: true
module RuboCop
  module Cop
    module Migration
      class UpdatingDataInMigration < RuboCop::Cop::Cop
        MSG = 'Updating or manipulating data in migration is unsafe!'.freeze

        def on_send(node)
          add_offense(node) if forbidden_methods.include?(node.method_name)
        end

        private

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
    end
  end
end
