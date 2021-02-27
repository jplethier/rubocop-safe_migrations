# frozen_string_literal: true
require "pry"

module RuboCop
  module Cop
    module Migration
      class UpdatingDataInMigration < RuboCop::Cop::Cop
        MSG = 'Updating or manipulating data in migration is unsafe!'.freeze

        def_node_matcher :update_in_migration?, <<-PATTERN
          (send _ {:update | :update_all | :update!} _+)
        PATTERN

        def_node_matcher :delete_in_migration?, <<-PATTERN
          (send _ {:delete | :delete_all | :destroy} _?)
        PATTERN

        def_node_matcher :save_in_migration?, <<-PATTERN
          (send _ {:save | :save!})
        PATTERN

        def on_send(node)
          update_in_migration?(node) { add_offense(node) }
          delete_in_migration?(node) { add_offense(node) }
          save_in_migration?(node) { add_offense(node) }
        end
      end
    end
  end
end
