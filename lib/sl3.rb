require "active_record"
require "sl3/conditions"
require "sl3/ordering"
require "sl3/association_conditions"
require "sl3/core_ext/proc"
require "sl3/core_ext/object"

Proc.send(:include, Sl3::CoreExt::Proc)
Object.send(:include, Sl3::CoreExt::Object)

ActiveRecord::Base.extend Sl3::Conditions
ActiveRecord::Base.extend Sl3::Ordering
ActiveRecord::Base.extend Sl3::AssociationConditions

ActiveRecord::Relation.extend Sl3::Conditions
ActiveRecord::Relation.extend Sl3::Ordering
ActiveRecord::Relation.extend Sl3::AssociationConditions
